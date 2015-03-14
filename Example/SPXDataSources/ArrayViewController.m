//
//  SPXViewController.m
//  SPXDataSources
//
//  Created by Shaps Mohsenin on 02/06/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "ArrayViewController.h"
#import "SPXDataSources.h"
#import "LoremIpsum.h"

@interface SPXObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@end

@implementation SPXObject
- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ (%zd)", self.name, self.age];
}
@end


@interface ArrayViewController ()
@property (nonatomic, strong) SPXDataCoordinator *coordinator;
@end

@implementation ArrayViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  SPXArrayDataProvider *provider = [SPXArrayDataProvider providerWithConfiguration:^(SPXArrayDataConfiguration *configuration) {
    NSMutableArray *people = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
      SPXObject *person = [SPXObject new];
      person.name = [LoremIpsum name];
      person.age = arc4random_uniform(3);
      [people addObject:person];
    }
    
    configuration.contents = people;
    configuration.sectionNameKeyPath = @"age";
    configuration.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
  }];
  
  [self.tableView setCanEditItemAtIndexPathBlock:^BOOL(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    return YES;
  }];
    
  [self.tableView setConfigureViewForItemAtIndexPathBlock:^(UITableView *tableView, UITableViewCell *cell, SPXObject *object, NSIndexPath *indexPath) {
    cell.textLabel.text = object.name;
  }];
  
  self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:provider];
}

@end
