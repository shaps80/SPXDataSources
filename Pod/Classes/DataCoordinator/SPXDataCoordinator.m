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

#import <objc/runtime.h>
#import "SPXDataCoordinator.h"
#import "SPXDataView.h"
#import "UITableView+SPXDataViewAdditions.h"
#import "UICollectionView+SPXDataViewAdditions.h"

NSString * const SPXDataViewViewReuseIdentifier = @"SPXDataViewViewReuseIdentifier";


@interface SPXDataCoordinator () <SPXDataProviderDelegate>

@property (nonatomic, weak) id <SPXDataView> dataView;
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;
@property (nonatomic, assign) BOOL sectionsDidChange;

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
  self.sectionsDidChange = NO;
  
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
      break; // do nothing
  }
  
  self.sectionsDidChange = YES;
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
  [self.dataView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dataView numberOfSections])]];

  if ([self.dataView isKindOfClass:[UITableView class]]) {
    [((UITableView *)self.dataView) endUpdates];
  }
  
  if (self.sectionsDidChange) {
    [self.dataView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.dataView numberOfSections])]];
  }
  
  if ([self.delegate respondsToSelector:@selector(coordinatorDidUpdate:)]) {
    [self.delegate coordinatorDidUpdate:self];
  }
}

@end

