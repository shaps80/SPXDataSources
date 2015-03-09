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

#import "UITableView+SPXDataViewAdditions.h"
#import <objc/runtime.h>


static void *ViewForItemAtIndexPathKey = &ViewForItemAtIndexPathKey;
static void *ConfigureItemAtIndexPathKey = &ConfigureItemAtIndexPathKey;
static void *CanMoveItemAtIndexPathKey = &CanMoveItemAtIndexPathKey;
static void *CanEditItemAtIndexPathKey = &CanEditItemAtIndexPathKey;
static void *CommitEditingStyleForItemAtIndexPathKey = &CommitEditingStyleForItemAtIndexPathKey;
static void *TitleForHeaderInSectionKey = &TitleForHeaderInSectionKey;
static void *TitleForFooterInSectionKey = &TitleForFooterInSectionKey;
static void *MoveItemAtSourceIndexPathToDestinationIndexPathKey = &MoveItemAtSourceIndexPathToDestinationIndexPathKey;


@implementation UITableView (SPXDataViewAdditions)

#pragma mark - Updates

- (void)performBatchUpdates:(void (^)(void))updates
{
  [self performBatchUpdates:updates completion:nil];
}

- (void)performBatchUpdates:(void (^)(void))updates completion:(void (^)(BOOL))completion
{
  [self beginUpdates];
  !updates ?: updates();
  [self endUpdates];
  !completion ?: completion(YES);
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths
{
  [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadSections:(NSIndexSet *)sections
{
  [self reloadSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - DataSource

- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [self cellForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
  return [self numberOfRowsInSection:section];
}

- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point
{
  return [self indexPathForRowAtPoint:point];
}

- (NSArray *)indexPathsForSelectedItems
{
  return self.indexPathsForSelectedRows;
}

- (NSArray *)indexPathsForVisibleItems
{
  return self.indexPathsForVisibleRows;
}

#pragma mark - Insert, Move, Delete Sections

- (void)insertSections:(NSIndexSet *)sections
{
  [self insertSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteSections:(NSIndexSet *)sections
{
  [self deleteSections:sections withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Insert, Move, Delete Items

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths
{
  [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths
{
  [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
  [self deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
  [self insertRowsAtIndexPaths:@[ newIndexPath ] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Selection

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
  [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
  [self deselectRowAtIndexPath:indexPath animated:animated];
}

#pragma mark - Setters/Getters for Blocks

- (void)setMoveItemAtSourceIndexPathToDestinationIndexPathBlock:(void (^)(UITableView *, NSIndexPath *, NSIndexPath *))moveItemAtSourceIndexPathToDestinationIndexPathBlock
{
  objc_setAssociatedObject(self, &MoveItemAtSourceIndexPathToDestinationIndexPathKey, moveItemAtSourceIndexPathToDestinationIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *, NSIndexPath *, NSIndexPath *))moveItemAtSourceIndexPathToDestinationIndexPathBlock
{
  return objc_getAssociatedObject(self, &MoveItemAtSourceIndexPathToDestinationIndexPathKey);
}

- (void)setViewForItemAtIndexPathBlock:(UITableViewCell *(^)(UITableView *tableView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &ViewForItemAtIndexPathKey, viewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setConfigureViewForItemAtIndexPathBlock:(void (^)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &ConfigureItemAtIndexPathKey, configureViewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTitleForHeaderInSectionBlock:(NSString *(^)(UITableView *tableView, NSUInteger section))titleForHeaderInSectionBlock
{
  objc_setAssociatedObject(self, &TitleForHeaderInSectionKey, titleForHeaderInSectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTitleForFooterInSectionBlock:(NSString *(^)(UITableView *tableView, NSUInteger section))titleForFooterInSectionBlock
{
  objc_setAssociatedObject(self, &TitleForFooterInSectionKey, titleForFooterInSectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITableViewCell *(^)(UITableView *tableView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &ViewForItemAtIndexPathKey);
}

- (void (^)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &ConfigureItemAtIndexPathKey);
}

- (NSString *(^)(UITableView *tableView, NSUInteger section))titleForHeaderInSectionBlock
{
  return objc_getAssociatedObject(self, &TitleForHeaderInSectionKey);
}

- (NSString *(^)(UITableView *tableView, NSUInteger section))titleForFooterInSectionBlock
{
  return objc_getAssociatedObject(self, &TitleForFooterInSectionKey);
}

- (void)setCanMoveItemAtIndexPathBlock:(BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canMoveItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &CanMoveItemAtIndexPathKey, canMoveItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canMoveItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &CanMoveItemAtIndexPathKey);
}

- (void)setCanEditItemAtIndexPathBlock:(BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canEditItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &CanEditItemAtIndexPathKey, canEditItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canEditItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &CanEditItemAtIndexPathKey);
}

- (void)setCommitEditingStyleForItemAtIndexPathBlock:(void (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))commitEditingStyleForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, &CommitEditingStyleForItemAtIndexPathKey, commitEditingStyleForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))commitEditingStyleForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, &CommitEditingStyleForItemAtIndexPathKey);
}

@end
