//
//  UITableView+SPXDataViewAdditions.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import UIKit;
#import "SPXDataView.h"


@interface UITableView (SPXDataViewAdditions) <SPXDataView>

@property (nonatomic, copy) UITableViewCell *(^viewForItemAtIndexPathBlock)(UITableView *tableView, id object, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^configureViewForItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);

@property (nonatomic, copy) NSString *(^titleForHeaderInSectionBlock)(UITableView *tableView, NSUInteger section);
@property (nonatomic, copy) NSString *(^titleForFooterInSectionBlock)(UITableView *tableView, NSUInteger section);

@property (nonatomic, copy) BOOL (^canMoveItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);
@property (nonatomic, copy) BOOL (^canEditItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);
@property (nonatomic, copy) void (^commitEditingStyleForItemAtIndexPathBlock)(UITableView *tableView, UITableViewCell *cell, id object, NSIndexPath *indexPath);

@property (nonatomic, copy) void (^moveItemAtSourceIndexPathToDestinationIndexPathBlock)(UITableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;

@end
