//
//  SPXDataProvider.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import Foundation;
#import "SPXDataView.h"
#import "SPXDataProviderSectionInfo.h"


/**
 *  Defines the type of change that occured on a dataProvider
 */
typedef NS_ENUM (NSUInteger, SPXDataProviderChangeType) {
  /**
   *  An item was inserted into the model
   */
  SPXDataProviderChangeTypeInsert = 1,
  /**
   *  An item was deleted from the model
   */
  SPXDataProviderChangeTypeDelete = 2,
  /**
   *  An item was moved inside the model
   */
  SPXDataProviderChangeTypeMove = 3,
  /**
   *  An item was changed inside the model
   */
  SPXDataProviderChangeTypeUpdate = 4
};


@protocol SPXDataProvider;

@protocol SPXDataProviderDelegate <NSObject>
- (void)dataProviderWillUpdate:(id <SPXDataProvider>)provider;
- (void)dataProvider:(id <SPXDataProvider>)provider didChangeSection:(SPXDataProviderSectionInfo *)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(SPXDataProviderChangeType)type;
- (void)dataProvider:(id <SPXDataProvider>)provider didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SPXDataProviderChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)dataProviderDidUpdate:(id <SPXDataProvider>)provider;
@end


@protocol SPXDataProvider <NSObject>
@required


// The DataCoordinator will be the delegate, you should never override this. Instead use the delegate provided on the dataCoordinator;
@property (nonatomic, weak) id <SPXDataProviderDelegate> delegate;


/**
 *  Returns the total number of items in the dataProvider
 */
- (NSUInteger)numberOfItems;


/**
 *  Returns a readonly copy of all items currently in the dataProvider
 *  @note Sort Descriptors and the Predicate will be respected
 */
- (NSArray *)allItems;


/**
 *  Returns the NSIndexPath for the specified object
 *
 *  @param object The object to get the indexPath for
 *
 *  @return The NSIndexPath for the specified object, nil if not found
 */
- (NSIndexPath *)indexPathForObject:(id)object;


/**
 *  Returns the object at the specified NSIndexPath
 *
 *  @param indexPath The indexPath of the object
 *
 *  @return The object at the indexPath, nil if not found
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;



/**
 *  Reloads the data
 *
 *  @return An NSError if something went wrong, nil otherwise
 */
- (NSError *)reloadData;


/**
 *  Returns the number of section for this data provider
 *
 *  @return The number of sections
 */
- (NSUInteger)numberOfSections;


/**
 *  Returns the number of rows in the specified section
 *
 *  @param section The section to inspect
 *
 *  @return The number of rows in the specified section
 */
- (NSUInteger)numberOfItemsInSection:(NSUInteger)section;


/**
 *  Returns the name associaed with this section
 *
 *  @param index The index of the section
 *
 *  @return An NSString representation of this section
 */
- (NSString *)sectionNameForSection:(NSInteger)section;


/**
 *  Although you may choose not to use these methods, it is recommended for persisting updates in a consistent manner and must be implemented even if you plan not to use them.
 */


/**
 *  DataProvider's are also responsible for the adding/removing of items.
 *
 *  @param indexPath The indexPath of the item to delete
 */
- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath;


@end



