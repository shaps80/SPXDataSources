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

#import <UIKit/UIKit.h>

@class SPXDataCoordinator;
@protocol SPXDataView;



/**
 *  Defines a block for providing items for your dataView
 *
 *  @param dataView  The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param object    The object associated with this item
 *  @param indexPath The indexPath of the item
 *
 *  @return You would return a UITableViewCell, UICollectionViewCell, or your own implementation for any custom dataView's
 */
typedef id (^SPXViewForItemAtIndexPathBlock)(id <SPXDataView> dataView, id object, NSIndexPath *indexPath);


/**
 *  Defines a block for configuring items in your dataView
 *
 *  @param dataView  The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param view      The view to configure
 *  @param object    The object associated with this item
 *  @param indexPath The indexPath of this item
 */
typedef void (^SPXConfigureViewForItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);


/**
 *  Defines a block for providing the title for your headers
 *
 *  @param dataView The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param section  The index of the section header for this title
 *
 *  @return An NSString representing this section's header title
 */
typedef NSString *(^SPXTitleForHeaderInSectionBlock)(id <SPXDataView> dataView, NSUInteger section);


/**
 *  Defines a block for providing the title for your footers
 *
 *  @param dataView The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param section  The index of the section footer for this title
 *
 *  @return An NSString representing this section's footer title
 */
typedef NSString *(^SPXTitleForFooterInSectionBlock)(id <SPXDataView> dataView, NSUInteger section);


/**
 *  Defines a block for determining whether or not an item can be edited
 *
 *  @param dataView  The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param view      The view associated with this edit
 *  @param object    The object associated with this edit
 *  @param indexPath The indexPath associated with this edit
 *
 *  @return YES if this item can be edited, NO otherwise
 */
typedef BOOL (^SPXCanEditItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);


/**
 *  Commits the editing style for this item. You can implement this to perform additional tasks when a delete occurs.
 *
 *  @param dataView  The view these items will be presented in. This will usually be a UITableView, UICollectionView. But can also be your own dataView implementation
 *  @param view      The view associated with this edit
 *  @param object    The object associated with this edit
 *  @param indexPath The indexPath associated with this edit
 */
typedef void (^SPXCommitEditingStyleForItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);



/**
 *  Defines an interface for all views to be used with SPXDataCoordinator
 */
@protocol SPXDataView <NSObject>


/**
 *  Gets/sets the block to execute for providing your cells. To configure your cells, use `configureViewForItemAtIndexPathBlock`
 */
@property (nonatomic, copy) SPXViewForItemAtIndexPathBlock viewForItemAtIndexPathBlock;


/**
 *  Gets/sets the block to execute for configuring your cells
 */
@property (nonatomic, copy) SPXConfigureViewForItemAtIndexPathBlock configureViewForItemAtIndexPathBlock;


/**
 *  The datasource for this view. This should always be the dataCoordinator and is managed automatically.
 */
@property (nonatomic, weak) SPXDataCoordinator *dataSource;


#pragma mark - Updates


/**
 *  Animates multiple insert, delete, reload, and move operations as a group.
 *  The equivalent of calling @c performBatchUpdates:completion: with no @c completion parameter.
 *
 *  @param updatesBlock The block that performs the relevant insert, delete, reload, or move operations.
 */
- (void)performBatchUpdates:(void (^)(void))updates;


/**
 *  Defines a way to perform batch updates consistently
 *
 *  @param updates    The block to execute updates
 *  @param completion The block to execute when competed
 */
- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL finished))completion;


#pragma mark - Sections


/**
 *  Inserts the specified sections
 *
 *  @param sections The sections to insert
 */
- (void)insertSections:(NSIndexSet *)sections;


/**
 *  Deletes all of the specified sections
 *
 *  @param sections The sections to delete
 */
- (void)deleteSections:(NSIndexSet *)sections;


/**
 *  Reloads all of the specified sections
 *
 *  @param sections The sections to reload
 */
- (void)reloadSections:(NSIndexSet *)sections;


/**
 *  Moves the specified section to a new position
 *
 *  @param section    The index of the section to move
 *  @param newSection The new section index
 */
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection;


#pragma mark - Items


/**
 *  Insert items into the fetched results view.
 *
 *  @param indexPaths An array containing the index paths of items to be inserted.
 */
- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;


/**
 *  Remove items from the fetched results view.
 *
 *  @param indexPaths An array containing the index paths of items to be removed.
 */
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;


/**
 *  Reload items in the fetched results view.
 *
 *  @param indexPaths An array containing the index paths of items to be reloaded.
 */
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;


/**
 *  Move an item within the fetched results view.
 *
 *  @param indexPath    The index path of the item to be moved.
 *  @param newIndexPath The index path where the item should be moved to.
 */
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;


#pragma mark - Cells


/**
 *  Returns the view at the specified indexPath. This would be a UITableViewCell instance in a UITableView and a UICollectionViewCell in a UICollectionView
 *
 *  @param indexPath The indexPath of the view to retrieve
 */
- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath;


#pragma mark - Selection


/**
 *  Selects the item at the specified indexPath
 *
 *  @param indexPath      The indexPath to select
 *  @param animated       If YES, animates the selection
 *  @param scrollPosition The scroll position this item should appear in when selected
 */
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(NSUInteger)scrollPosition;


/**
 *  De-selects the item at the specified indexPath
 *
 *  @param indexPath The indexPath to de-select
 *  @param animated  If YES, animates the de-selection
 */
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;


#pragma mark - IndexPaths


/**
 *  Returns the indexPaths for selected items
 */
- (NSArray *)indexPathsForSelectedItems;


/**
 *  Returns the indexPaths for all visible items
 */
- (NSArray *)indexPathsForVisibleItems;


/**
 *  Returns the indexPath for an item at the specified point
 *
 *  @param point The point to inspect
 *
 *  @return An indexPath if it exists at the point, nil otherwise
 */
- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;


#pragma mark - DataSource


/**
 *  Returns the number of items for the given section
 *
 *  @param section  The section to retrieve an item count for
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;


/**
 *  Returns the number of sections for this view
 *
 *  @return The number of section
 */
- (NSInteger)numberOfSections;


/**
 *  Dequeues a new view
 *
 *  @param identifier The identifier for this view
 *  @param indexPath  The indexPath where this view will be used
 *
 *  @return A new or reused view
 */
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath*)indexPath;


/**
 *  Forces a reload of the view's data
 */
- (void)reloadData;


@end
