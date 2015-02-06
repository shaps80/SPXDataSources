//
//  SPXViewController.m
//  SPXDataSources
//
//  Created by Shaps Mohsenin on 02/06/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import "SPXViewController.h"
#import "SPXDataSources.h"

@interface SPXViewController ()
@property (nonatomic, strong) SPXDataCoordinator *coordinator;
@end

@implementation SPXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:nil];
}

@end
