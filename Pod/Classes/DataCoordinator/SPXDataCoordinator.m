//
//  SPXDataCoordinator.m
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import <objc/runtime.h>
#import "SPXDataCoordinator.h"
#import "SPXDataView.h"
#import "UITableView+SPXDataViewAdditions.h"
#import "UICollectionView+SPXDataViewAdditions.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"

NSString * const SPXDataViewViewReuseIdentifier = @"SPXDataViewViewReuseIdentifier";


@interface SPXDataCoordinator () <SPXDataProviderDelegate>

@property (nonatomic, weak) id <SPXDataView> dataView;
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;

@end

@implementation SPXDataCoordinator

+ (instancetype)coordinatorForDataView:(id<SPXDataView>)dataView dataProvider:(id<SPXDataProvider>)dataProvider
{
  SPXDataCoordinator *coordinator = [SPXDataCoordinator new];
  coordinator.dataProvider = dataProvider;
  coordinator.dataView = dataView;
  dataView.dataSource = coordinator;
  dataProvider.delegate = coordinator;

  return coordinator;
}

- (void)dataProviderWillUpdate:(id<SPXDataProvider>)provider
{
  if ([self.dataView isKindOfClass:[UITableView class]]) {
    [((UITableView *)self.dataView) beginUpdates];
  }
}

- (void)dataProvider:(id<SPXDataProvider>)provider didChangeSection:(SPXDataProviderSectionInfo *)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(SPXDataProviderChangeType)type
{
  switch (type) {
    case SPXDataProviderChangeTypeInsert:
      [self.dataView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
      break;
    case SPXDataProviderChangeTypeDelete:
      [self.dataView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
      break;
    default:
      [self.dataView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
      break;
  }
}

- (void)dataProvider:(id<SPXDataProvider>)provider didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SPXDataProviderChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  switch (type) {
    case SPXDataProviderChangeTypeInsert:
      [self.dataView insertItemsAtIndexPaths:@[ newIndexPath ]];
      break;
    case SPXDataProviderChangeTypeUpdate:
      [self.dataView reloadItemsAtIndexPaths:@[ indexPath ]];
      break;
    case SPXDataProviderChangeTypeMove:
      [self.dataView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
      break;
    case SPXDataProviderChangeTypeDelete:
      [self.dataView deleteItemsAtIndexPaths:@[ indexPath ]];
      break;
  }
}

- (void)dataProviderDidUpdate:(id<SPXDataProvider>)provider
{
  if ([self.dataView isKindOfClass:[UITableView class]]) {
    [((UITableView *)self.dataView) endUpdates];
  }
  
  if ([self.delegate respondsToSelector:@selector(coordinatorDidUpdate:)]) {
    [self.delegate coordinatorDidUpdate:self];
  }
}

@end


#pragma clang diagnostic pop

