//
//  UICollectionView+SPXDataViewAdditions.m
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import <objc/runtime.h>
#import "UICollectionView+SPXDataViewAdditions.h"


static void *ViewForItemAtIndexPathKey = &ViewForItemAtIndexPathKey;
static void *ViewForSupplementaryElementOfKindAtIndexPathKey = &ViewForSupplementaryElementOfKindAtIndexPathKey;
static void *ConfigureItemAtIndexPathKey = &ConfigureItemAtIndexPathKey;


@implementation UICollectionView (SPXDataViewAdditions)

- (void)performBatchUpdates:(void (^)(void))updates
{
  [self performBatchUpdates:updates completion:nil];
}

#pragma mark - 

- (void)setViewForItemAtIndexPathBlock:(UICollectionViewCell *(^)(UICollectionView *collectionView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &ViewForItemAtIndexPathKey, viewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setConfigureViewForItemAtIndexPathBlock:(void (^)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &ConfigureItemAtIndexPathKey, configureViewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setViewForSupplementaryElementOfKindAtIndexPathBlock:(UICollectionReusableView *(^)(UICollectionView *, NSString *, NSIndexPath *))viewForSupplementaryElementOfKindAtIndexPathBlock
{
  objc_setAssociatedObject(self, &ViewForSupplementaryElementOfKindAtIndexPathKey, viewForSupplementaryElementOfKindAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UICollectionViewCell *(^)(UICollectionView *collectionView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &ViewForItemAtIndexPathKey);
}

- (void (^)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &ConfigureItemAtIndexPathKey);
}

- (UICollectionReusableView *(^)(UICollectionView *, NSString *, NSIndexPath *))viewForSupplementaryElementOfKindAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &ViewForSupplementaryElementOfKindAtIndexPathKey);
}

@end
