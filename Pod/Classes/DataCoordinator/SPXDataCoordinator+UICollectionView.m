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

#import "SPXDataCoordinator+UICollectionView.h"
#import "UICollectionView+SPXDataViewAdditions.h"

@interface SPXDataCoordinator (Private) <UICollectionViewDataSource, SPXDataProviderDelegate>
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;
@property (nonatomic, weak) UICollectionView *dataView;
@end

@implementation SPXDataCoordinator (UICollectionView)

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return self.dataProvider.numberOfSections;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *view = nil;
  
  if (!collectionView.viewForSupplementaryElementOfKindAtIndexPathBlock) {
    view = collectionView.viewForSupplementaryElementOfKindAtIndexPathBlock(collectionView, kind, indexPath);
  }
  
  return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  UICollectionViewCell *cell = nil;
  id object = [self.dataProvider objectAtIndexPath:indexPath];
  
  if (!collectionView.viewForItemAtIndexPathBlock) {
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPXDataViewViewReuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
      cell = [UICollectionViewCell new];
    }
  } else {
    cell = collectionView.viewForItemAtIndexPathBlock(collectionView, object, indexPath);
  }
  
  if (collectionView.configureViewForItemAtIndexPathBlock) {
    collectionView.configureViewForItemAtIndexPathBlock(collectionView, cell, object, indexPath);
  }
  
  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.dataProvider numberOfItemsInSection:section];
}

@end
