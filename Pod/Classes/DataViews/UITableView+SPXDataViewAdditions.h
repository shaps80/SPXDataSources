//
//  UITableView+SPXDataViewAdditions.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import UIKit;
#import "SPXDataView.h"


/**
 *  Provides collectionView specific definitions of a dataView
 */
@interface UITableView (SPXDataViewAdditions) <SPXDataView>


/**
 *  Gets/sets the block to execute when the collectionView requests a cell
 */
@property (nonatomic, copy) UITableViewCell *(^viewForItemAtIndexPathBlock)(UITableView *tableView, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView requests the cell to be configured
 */
@property (nonatomic, copy) void (^configureViewForItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView requests a section header
 */
@property (nonatomic, copy) NSString *(^titleForHeaderInSectionBlock)(UITableView *tableView, NSUInteger section);


/**
 *  Gets/sets the block to execute when the collectionView requests a section footer
 */
@property (nonatomic, copy) NSString *(^titleForFooterInSectionBlock)(UITableView *tableView, NSUInteger section);


/**
 *  Gets/sets the block to execute when the collectionView requests whether or not a cell can be moved
 */
@property (nonatomic, copy) BOOL (^canMoveItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView requests whether or not a cell can be edited
 */
@property (nonatomic, copy) BOOL (^canEditItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView commits an editing action for a cell
 */
@property (nonatomic, copy) void (^commitEditingStyleForItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);


/**
 *  Gets/sets the block to execute when the collectionView moves a cell
 */
@property (nonatomic, copy) void (^moveItemAtSourceIndexPathToDestinationIndexPathBlock)(UITableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);


@end


