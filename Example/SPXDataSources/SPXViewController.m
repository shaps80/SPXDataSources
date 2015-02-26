//
//  SPXViewController.m
//  SPXDataSources
//
//  Created by Shaps Mohsenin on 02/06/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "SPXViewController.h"
#import "SPXDataSources.h"
#import "sPXDefines.h"

@interface SPXObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation SPXObject

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(name), SPXKeyPath(age));
}

@end

@interface SPXViewController ()
@property (nonatomic, strong) SPXDataCoordinator *coordinator;
@end

@implementation SPXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  SPXArrayDataProvider *provider = [SPXArrayDataProvider providerWithConfiguration:^(SPXArrayDataConfiguration *configuration) {
    SPXObject *one = [SPXObject new];
    one.name = @"One";
    one.age = 10;
    
    SPXObject *two = [SPXObject new];
    two.name = @"Two";
    two.age = 17;
    
    SPXObject *three = [SPXObject new];
    three.name = @"Three";
    three.age = 20;
    
    SPXObject *four = [SPXObject new];
    four.name = @"Four";
    four.age = 10;
    
    SPXObject *five = [SPXObject new];
    five.name = @"Five";
    five.age = 20;
    
    SPXObject *six = [SPXObject new];
    six.name = @"Six";
    six.age = 13;
    
    SPXObject *seven = [SPXObject new];
    seven.name = @"Seven";
    seven.age = 10;
    
    configuration.contents = @[ one, two,three, four, five, six, seven ];
    configuration.sectionNameKeyPath = @"age";
  }];
  
  [self.tableView setConfigureViewForItemAtIndexPathBlock:^(UITableView *tableView, UITableViewCell *cell, SPXObject *object, NSIndexPath *indexPath) {
    cell.textLabel.text = object.name;
  }];
  
  self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:provider];
}

@end
