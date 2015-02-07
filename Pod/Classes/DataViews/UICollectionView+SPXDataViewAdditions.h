//
//  UICollectionView+SPXDataViewAdditions.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataView.h"


/**
 *  Provides collectionView specific definitions of a dataView
 */
@interface UICollectionView (SPXDataViewAdditions) <SPXDataView>


/**
 *  Gets/sets the block to execute when the collectionView requests a cell
 */
@property (nonatomic, copy) UICollectionViewCell *(^viewForItemAtIndexPathBlock)(UICollectionView *collectionView, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView requests a supplementary view
 */
@property (nonatomic, copy) UICollectionReusableView *(^viewForSupplementaryElementOfKindAtIndexPathBlock)(UICollectionView *collectionView, NSString *kind, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView requests the cell to be configured (optional)
 */
@property (nonatomic, copy) void (^configureViewForItemAtIndexPathBlock)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath);


@end

