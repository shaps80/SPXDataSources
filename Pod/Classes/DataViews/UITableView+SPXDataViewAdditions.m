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

@interface UITableView (SPXDataViewPrivateAdditions)
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation UITableView (SPXDataViewAdditions)

- (UITableViewCell *)prototypeCell
{
  return objc_getAssociatedObject(self, @selector(prototypeCell));
}

- (void)setPrototypeCell:(UITableViewCell *)prototypeCell
{
  objc_setAssociatedObject(self, @selector(prototypeCell), prototypeCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
  return [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (CGFloat)heightForItemAtIndexPath:(NSIndexPath *)indexPath object:(id)object reuseIdentifier:(NSString *)reuseIdentifier
{
  if (![self.prototypeCell.reuseIdentifier isEqualToString:reuseIdentifier]) {
    self.prototypeCell = [self dequeueReusableCellWithIdentifier:reuseIdentifier];
  }
  
  !self.configureViewForItemAtIndexPathBlock ?: self.configureViewForItemAtIndexPathBlock(self, self.prototypeCell, object, indexPath);
  return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
}

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
  [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
  if (indexPath.section < [self numberOfSections] && indexPath.item < [self numberOfItemsInSection:indexPath.section]) {
    [self selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
  }
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
  [self deselectRowAtIndexPath:indexPath animated:animated];
}

#pragma mark - Setters/Getters for Blocks

- (void)setMoveItemAtSourceIndexPathToDestinationIndexPathBlock:(void (^)(UITableView *, NSIndexPath *, NSIndexPath *))moveItemAtSourceIndexPathToDestinationIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(moveItemAtSourceIndexPathToDestinationIndexPathBlock), moveItemAtSourceIndexPathToDestinationIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *, NSIndexPath *, NSIndexPath *))moveItemAtSourceIndexPathToDestinationIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(moveItemAtSourceIndexPathToDestinationIndexPathBlock));
}

- (void)setViewForItemAtIndexPathBlock:(UITableViewCell *(^)(UITableView *tableView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(viewForItemAtIndexPathBlock), viewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setConfigureViewForItemAtIndexPathBlock:(void (^)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(configureViewForItemAtIndexPathBlock), configureViewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTitleForHeaderInSectionBlock:(NSString *(^)(UITableView *tableView, NSUInteger section))titleForHeaderInSectionBlock
{
  objc_setAssociatedObject(self, @selector(titleForHeaderInSectionBlock), titleForHeaderInSectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setTitleForFooterInSectionBlock:(NSString *(^)(UITableView *tableView, NSUInteger section))titleForFooterInSectionBlock
{
  objc_setAssociatedObject(self, @selector(titleForFooterInSectionBlock), titleForFooterInSectionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITableViewCell *(^)(UITableView *tableView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(viewForItemAtIndexPathBlock));
}

- (void (^)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(configureViewForItemAtIndexPathBlock));
}

- (NSString *(^)(UITableView *tableView, NSUInteger section))titleForHeaderInSectionBlock
{
  return objc_getAssociatedObject(self, @selector(titleForHeaderInSectionBlock));
}

- (NSString *(^)(UITableView *tableView, NSUInteger section))titleForFooterInSectionBlock
{
  return objc_getAssociatedObject(self, @selector(titleForFooterInSectionBlock));
}

- (void)setCanMoveItemAtIndexPathBlock:(BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canMoveItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(canMoveItemAtIndexPathBlock), canMoveItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canMoveItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(canMoveItemAtIndexPathBlock));
}

- (void)setCanEditItemAtIndexPathBlock:(BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canEditItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(canEditItemAtIndexPathBlock), canEditItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))canEditItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(canEditItemAtIndexPathBlock));
}

- (void)setCommitEditingStyleForItemAtIndexPathBlock:(void (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))commitEditingStyleForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(commitEditingStyleForItemAtIndexPathBlock), commitEditingStyleForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UITableView *, UITableViewCell *, id, NSIndexPath *))commitEditingStyleForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(commitEditingStyleForItemAtIndexPathBlock));
}

@end
