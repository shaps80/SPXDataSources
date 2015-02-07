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

#import "SPXDataCoordinator+UITableView.h"
#import "UITableView+SPXDataViewAdditions.h"
#import "SPXAssertionDefines.h"
#import "SPXLoggingDefines.h"

@interface SPXDataCoordinator (Private) <UITableViewDataSource, SPXDataProviderDelegate>
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;
@property (nonatomic, weak) UITableView *dataView;
@end

@implementation SPXDataCoordinator (UITableView)

#pragma mark - DataProvider Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.dataProvider.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.dataProvider numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = nil;
  id object = [self.dataProvider objectAtIndexPath:indexPath];
  
  if (!tableView.viewForItemAtIndexPathBlock) {
    cell = [tableView dequeueReusableCellWithIdentifier:SPXDataViewViewReuseIdentifier];
    
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SPXDataViewViewReuseIdentifier];
    }
  } else {
    cell = tableView.viewForItemAtIndexPathBlock(tableView, object, indexPath);
  }
  
  if (tableView.configureViewForItemAtIndexPathBlock) {
    tableView.configureViewForItemAtIndexPathBlock(tableView, cell, object, indexPath);
  } else {
    cell.textLabel.text = [object description];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  if (tableView.moveItemAtSourceIndexPathToDestinationIndexPathBlock) {
    tableView.moveItemAtSourceIndexPathToDestinationIndexPathBlock(tableView, sourceIndexPath, destinationIndexPath);
    [tableView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
  } else {
    SPXLog(@"Unable to move %@ to %@: You MUST implement the moveItemAtSourceIndexPathToDestinationIndexPathBlock", sourceIndexPath, destinationIndexPath);
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id object = [self.dataProvider objectAtIndexPath:indexPath];
    
    if (tableView.commitEditingStyleForItemAtIndexPathBlock) {
      // if we have defined a commit block, then its callers responsibility to perform actual deletion!
      tableView.commitEditingStyleForItemAtIndexPathBlock(tableView, cell, object, indexPath);
      return;
    }

    // otherwise, lets do it for them as a convenience ;)
    [self.dataProvider deleteObjectAtIndexPath:indexPath];
    !tableView.commitEditingStyleForItemAtIndexPathBlock ?: tableView.commitEditingStyleForItemAtIndexPathBlock(tableView, cell, object, indexPath);
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  BOOL canEdit = NO;
  
  if (tableView.canEditItemAtIndexPathBlock) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id object = [self.dataProvider objectAtIndexPath:indexPath];
    return tableView.canEditItemAtIndexPathBlock(tableView, cell, object, indexPath);
  }
  
  return canEdit;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  BOOL canMove = YES;
  
  if (tableView.canMoveItemAtIndexPathBlock) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id object = [self.dataProvider objectAtIndexPath:indexPath];
    return tableView.canMoveItemAtIndexPathBlock(tableView, cell, object, indexPath);
  }
  
  return canMove;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  NSString *title = nil;
  SPXTitleForHeaderInSectionBlock block = tableView.titleForHeaderInSectionBlock;
  
  if (block) {
    title = block(tableView, section);
  }
  
  return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
  NSString *title = nil;
  SPXTitleForFooterInSectionBlock block = tableView.titleForFooterInSectionBlock;
  
  if (block) {
    title = block(tableView, section);
  }
  
  return title;
}

@end
