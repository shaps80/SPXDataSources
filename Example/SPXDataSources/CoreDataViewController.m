/*
   Copyright (c) 2015 Shaps Mohsenin. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY Shaps Mohsenin `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL Shaps Mohsenin OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "CoreDataViewController.h"
#import "SPXDataSources.h"
#import "Stack.h"
#import "Person.h"
#import "LoremIpsum.h"

@interface CoreDataViewController ()
@property (nonatomic, strong) SPXDataCoordinator *coordinator;
@end

@implementation CoreDataViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  for (int i = 0; i < 10; i++) {
    Stack.defaultStack.transaction(^{
      StackQuery *query = Stack.defaultStack.query(Person.class);
      Person *person = query.whereIdentifier([NSString stringWithFormat:@"%zd", i], YES);
      person.name = [LoremIpsum name];
      person.age = @(arc4random_uniform(3));
    }).synchronous(YES);
  }
  
  SPXCoreDataDataProvider *provider = [SPXCoreDataDataProvider providerWithConfiguration:^(SPXCoreDataConfiguration *configuration) {
    NSArray *sorting = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
    StackQuery *query = Stack.defaultStack.query(Person.class);
    configuration.fetchedResultsController = query.sortWithDescriptors(sorting).fetchedResultsController(@"age", nil);
  }];
  
  self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:provider];
  
  [self.tableView setConfigureViewForItemAtIndexPathBlock:^(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    cell.textLabel.text = [object name];
  }];
  
  [self.tableView setCanEditItemAtIndexPathBlock:^BOOL(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    return YES;
  }];
  
  __weak typeof(self) weakInstance = self;
  [provider setDeletionHandler:^(NSIndexPath *indexPath) {
    Stack *stack = Stack.defaultStack;
    Person *person = [weakInstance.coordinator.dataProvider objectAtIndexPath:indexPath];
    
    stack.transaction(^{
      @stack_copy(person);
      stack.query(Person.class).deleteObjects(@[ person ]);
    }).synchronous(YES);
  }];
}

@end
