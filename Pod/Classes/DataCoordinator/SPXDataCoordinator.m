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
#import "SPXDefines.h"

NSString * const SPXDataViewViewReuseIdentifier = @"SPXDataViewViewReuseIdentifier";

@interface SPXDataCoordinatorChanges : NSObject

@property (nonatomic, strong) NSHashTable *sectionInserts;
@property (nonatomic, strong) NSHashTable *sectionDeletes;

@property (nonatomic, strong) NSHashTable *itemInserts;
@property (nonatomic, strong) NSHashTable *itemUpdates;
@property (nonatomic, strong) NSHashTable *itemDeletes;
@property (nonatomic, strong) NSHashTable *itemMoves;

@end

@implementation SPXDataCoordinatorChanges

- (instancetype)init
{
  self = [super init];
  SPXAssertTrueOrReturnNil(self);
  
  _sectionInserts = [NSHashTable new];
  _sectionDeletes = [NSHashTable new];
  _itemInserts = [NSHashTable new];
  _itemUpdates = [NSHashTable new];
  _itemMoves = [NSHashTable new];
  _itemDeletes = [NSHashTable new];
  
  return self;
}

- (void)insertSectionWithBlock:(void (^)())block
{
  [self.sectionInserts addObject:block];
}

- (void)deleteSectionWithBlock:(void (^)())block
{
  [self.sectionDeletes addObject:block];
}

- (void)insertWithBlock:(void (^)())block
{
  [self.itemInserts addObject:block];
}

- (void)updateWithBlock:(void (^)())block
{
  [self.itemUpdates addObject:block];
}

- (void)moveWithBlock:(void (^)())block
{
  [self.itemMoves addObject:block];
}

- (void)deleteWithBlock:(void (^)())block
{
  [self.itemDeletes addObject:block];
}

- (void)processChanges
{
  for (void (^changes)() in self.sectionDeletes) {
    changes();
  }
  
  for (void (^changes)() in self.sectionInserts) {
    changes();
  }
  
  for (void (^changes)() in self.itemDeletes) {
    changes();
  }
  
  for (void (^changes)() in self.itemInserts) {
    changes();
  }
  
  for (void (^changes)() in self.itemUpdates) {
    changes();
  }
  
  for (void (^changes)() in self.itemMoves) {
    changes();
  }
}

@end


@interface SPXDataCoordinator () <SPXDataProviderDelegate>

@property (nonatomic, weak) id <SPXDataView> dataView;
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;
@property (nonatomic, assign) BOOL sectionsDidChange;
@property (nonatomic, strong) SPXDataCoordinatorChanges *changes;

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
  self.changes = [SPXDataCoordinatorChanges new];
}

- (void)dataProvider:(id<SPXDataProvider>)provider didChangeSection:(SPXDataProviderSectionInfo *)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(SPXDataProviderChangeType)type
{
  switch (type) {
    case SPXDataProviderChangeTypeInsert: {
      [self.changes insertSectionWithBlock:^{ [self.dataView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]]; }];
    }
      break;
    case SPXDataProviderChangeTypeDelete: {
      [self.changes deleteSectionWithBlock:^{ [self.dataView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]]; }];
    }
      break;
    default:
      break; // do nothing
  }
  
  self.sectionsDidChange = YES;
}

- (void)dataProvider:(id<SPXDataProvider>)provider didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SPXDataProviderChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  switch (type) {
    case SPXDataProviderChangeTypeInsert: {
      [self.changes insertWithBlock:^{ [self.dataView insertItemsAtIndexPaths:@[ newIndexPath ]]; }];
    }
      break;
    case SPXDataProviderChangeTypeUpdate: {
      [self.changes insertWithBlock:^{ [self.dataView reloadItemsAtIndexPaths:@[ indexPath ]]; }];
    }
      break;
    case SPXDataProviderChangeTypeMove: {
      [self.changes insertWithBlock:^{ [self.dataView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath]; }];
    }
      break;
    case SPXDataProviderChangeTypeDelete: {
      [self.changes insertWithBlock:^{ [self.dataView deleteItemsAtIndexPaths:@[ indexPath ]]; }];
    }
      break;
  }
}

- (void)dataProviderDidUpdate:(id<SPXDataProvider>)provider
{
  __weak typeof(self) weakInstance = self;

  [self.dataView performBatchUpdates:^{
    [weakInstance.changes processChanges];
  }];
  
  if ([self.delegate respondsToSelector:@selector(coordinatorDidUpdate:)]) {
    [self.delegate coordinatorDidUpdate:self];
  }
}

@end

