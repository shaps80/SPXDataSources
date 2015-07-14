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


/**
 *  Returns the calculated height for this item
 *
 *  @param indexPath       The indexPath for this item
 *  @param object          The object associated with this item
 *  @param reuseIdentifier The reuse identifier for this item
 *
 *  @return The calculated height
 */
- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath object:(id)object reuseIdentifier:(NSString *)reuseIdentifier;


@end


