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

#import "SPXViewController.h"
#import "LoremIpsum.h"

@interface SPXPerson : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@end

@implementation SPXPerson
- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ (%zd)", self.name, self.age];
}
@end


@implementation SPXViewController

- (void)prepareConfiguration
{
  SPXArrayDataProvider *provider = [SPXArrayDataProvider providerWithConfiguration:^(SPXArrayDataConfiguration *configuration) {
    NSMutableArray *people = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
      SPXPerson *person = [SPXPerson new];
      person.name = [LoremIpsum name];
      person.age = arc4random_uniform(3);
      [people addObject:person];
    }
    
    configuration.contents = people;
    configuration.sectionNameKeyPath = @"age";
    configuration.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
  }];
  
  self.configuration.dataProvider = provider;
  self.configuration.title = @"People";
  self.configuration.rightNavItem = SPXControllerNavItemAdd;
}

- (void)addEntity:(id)sender
{
  [super addEntity:sender];
  
  if (![self canAddEntity]) {
    return;
  }
  
  SPXControllerConfiguration *config = self.configuration.copy;
  config.presentationStyle = SPXControllerPresentationStyleModalDismissOnSelection;
  config.rightNavItem = SPXControllerNavItemNone;
  config.title = @"Select Person";
  
  SPXDataViewController *controller = [self presentViewControllerWithConfiguration:config];
  
  [controller.tableView setConfigureViewForItemAtIndexPathBlock:^(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.text = [object description];
  }];
}

@end
