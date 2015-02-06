//
//  SPXDataView.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@protocol SPXDataView;

typedef id (^SPXViewForItemAtIndexPathBlock)(id <SPXDataView> dataView, id object, NSIndexPath *indexPath);
typedef void (^SPXConfigureViewForItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);
typedef NSString *(^SPXTitleForHeaderInSectionBlock)(id <SPXDataView> dataView, NSUInteger section);
typedef NSString *(^SPXTitleForFooterInSectionBlock)(id <SPXDataView> dataView, NSUInteger section);
typedef void (^SPXCanEditItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);
typedef void (^SPXCommitEditingStyleForItemAtIndexPathBlock)(id <SPXDataView> dataView, id view, id object, NSIndexPath *indexPath);



@protocol SPXDataView <NSObject>


@property (nonatomic, copy) SPXViewForItemAtIndexPathBlock viewForItemAtIndexPathBlock;
@property (nonatomic, copy) SPXConfigureViewForItemAtIndexPathBlock configureViewForItemAtIndexPathBlock;
@property (nonatomic, weak) id dataSource;


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


- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)reloadSections:(NSIndexSet *)sections;
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


- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(NSUInteger)scrollPosition;
- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;


#pragma mark - IndexPaths


- (NSArray *)indexPathsForSelectedItems;
- (NSArray *)indexPathsForVisibleItems;
- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point;


#pragma mark - DataSource


/**
 *  Returns the number of items for the given section
 *
 *  @param section  The section to retrieve an item count for
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;


@end
