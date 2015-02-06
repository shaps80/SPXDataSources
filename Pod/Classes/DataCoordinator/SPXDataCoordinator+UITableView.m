//
//  SPXDataCoordinator+UITableView.m
//  OAuth
//
//  Created by Shaps Mohsenin on 14/11/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataCoordinator+UITableView.h"
#import "UITableView+SPXDataViewAdditions.h"
#import "SPXAssertionDefines.h"

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
