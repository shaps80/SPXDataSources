//
//  UICollectionView+SPXDataViewAdditions.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataView.h"

@import UIKit;

@interface UICollectionView (SPXDataViewAdditions) <SPXDataView>

// these are provided as overrides for the block definitions to improve autocomplete!
@property (nonatomic, copy) UICollectionViewCell *(^viewForItemAtIndexPathBlock)(UICollectionView *collectionView, id object, NSIndexPath *indexPath);
@property (nonatomic, copy) UICollectionReusableView *(^viewForSupplementaryElementOfKindAtIndexPathBlock)(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^configureViewForItemAtIndexPathBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath);

@end

