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

#import <objc/runtime.h>
#import "UICollectionView+SPXDataViewAdditions.h"

@interface UICollectionView (SPXDataViewPrivateAdditions)
@property (nonatomic, strong) UICollectionViewCell *prototypeCell;
@end

@implementation UICollectionView (SPXDataViewAdditions)

- (UICollectionViewCell *)prototypeCell
{
  return objc_getAssociatedObject(self, @selector(prototypeCell));
}

- (void)setPrototypeCell:(UICollectionViewCell *)prototypeCell
{
  objc_setAssociatedObject(self, @selector(prototypeCell), prototypeCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath object:(id)object reuseIdentifier:(NSString *)reuseIdentifier
{
  if (![self.prototypeCell.reuseIdentifier isEqualToString:reuseIdentifier]) {
    self.prototypeCell = [self dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  }
  
  !self.configureViewForItemAtIndexPathBlock ?: self.configureViewForItemAtIndexPathBlock(self, self.prototypeCell, object, indexPath);
  return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
}

- (void)performBatchUpdates:(void (^)(void))updates
{
  [self performBatchUpdates:updates completion:nil];
}

#pragma mark - Setters/Getters for Blocks

- (void)setViewForItemAtIndexPathBlock:(UICollectionViewCell *(^)(UICollectionView *collectionView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(viewForItemAtIndexPathBlock), viewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setConfigureViewForItemAtIndexPathBlock:(void (^)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(configureViewForItemAtIndexPathBlock), configureViewForItemAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setViewForSupplementaryElementOfKindAtIndexPathBlock:(UICollectionReusableView *(^)(UICollectionView *, NSString *, NSIndexPath *))viewForSupplementaryElementOfKindAtIndexPathBlock
{
  objc_setAssociatedObject(self, @selector(viewForSupplementaryElementOfKindAtIndexPathBlock), viewForSupplementaryElementOfKindAtIndexPathBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UICollectionViewCell *(^)(UICollectionView *collectionView, id object, NSIndexPath *indexPath))viewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(viewForItemAtIndexPathBlock));
}

- (void (^)(UICollectionView *collectionView, UICollectionViewCell *cell, id object, NSIndexPath *indexPath))configureViewForItemAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(configureViewForItemAtIndexPathBlock));
}

- (UICollectionReusableView *(^)(UICollectionView *, NSString *, NSIndexPath *))viewForSupplementaryElementOfKindAtIndexPathBlock
{
  return objc_getAssociatedObject(self, @selector(viewForSupplementaryElementOfKindAtIndexPathBlock));
}

@end
