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
#import "ArrayPollingService.h"
#import "SPXTableViewCell.h"

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
@property (nonatomic, strong) ArrayPollingService *dataService;
@end

@implementation ArrayViewController

- (void)viewDidLoad
{  
  [super viewDidLoad];
  
  NSURL *url = [NSURL URLWithString:@"http://stackoverflow.com/questions/21198404/nsurlsession-with-nsblockoperation-and-queues"];
  self.dataService = [ArrayPollingService networkServiceForURL:url];
  self.dataService.pollingInterval = 2;
  [self.dataService start];
  
  SPXArrayDataProvider *provider = [SPXArrayDataProvider providerWithConfiguration:^(SPXArrayDataConfiguration *configuration) {
    NSMutableArray *people = [NSMutableArray new];
    
    for (int i = 0; i < 10; i++) {
      SPXObject *person = [SPXObject new];
      person.name = [LoremIpsum sentencesWithNumber:3];
      person.age = arc4random_uniform(3);
      [people addObject:person];
    }
    
    configuration.contents = people;
    configuration.sectionNameKeyPath = @"age";
    configuration.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES] ];
  }];
  
  [self.tableView setViewForItemAtIndexPathBlock:^UITableViewCell *(UITableView *tableView, id object, NSIndexPath *indexPath) {
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  }];
  
  [self.tableView setConfigureViewForItemAtIndexPathBlock:^(UITableView *tableView, UITableViewCell *cell, SPXObject *object, NSIndexPath *indexPath) {
    SPXTableViewCell *c = (SPXTableViewCell *)cell;
    c.titleLabel.text = object.name;
  }];
  
  [self.tableView setCanEditItemAtIndexPathBlock:^BOOL(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath) {
    return YES;
  }];
  
  self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:provider];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id object = [self.coordinator.dataProvider objectAtIndexPath:indexPath];
  return [tableView heightForItemAtIndexPath:indexPath object:object reuseIdentifier:@"cell"];
}

@end
