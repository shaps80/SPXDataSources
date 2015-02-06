//
//  SPXDataCoordinator+UICollectionView.m
//  OAuth
//
//  Created by Shaps Mohsenin on 14/11/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

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
