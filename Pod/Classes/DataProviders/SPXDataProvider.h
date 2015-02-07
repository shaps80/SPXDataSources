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


/**
 *  Defines an interface for all data providers
 */
@protocol SPXDataProviderDelegate <NSObject>


/**
 *  This method will execute when the data provider will begin an update
 *
 *  @param provider The data provider that will update
 */
- (void)dataProviderWillUpdate:(id <SPXDataProvider>)provider;


/**
 *  This method will execute when a section change occurs in the data provider
 *
 *  @param provider     The dataProvider that was updated
 *  @param sectionInfo  The section info that was updated
 *  @param sectionIndex The section index that was updated
 *  @param type         The type of update that occurred
 */
- (void)dataProvider:(id <SPXDataProvider>)provider didChangeSection:(SPXDataProviderSectionInfo *)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(SPXDataProviderChangeType)type;


/**
 *  This method will execute when an object change occurs in the data provider
 *
 *  @param provider     The dataProvider that was updated
 *  @param anObject     The object that was updated
 *  @param indexPath    The indexPath of the object that was updated
 *  @param type         The type of update that occurred
 *  @param newIndexPath The new indexPath that was updated. This is only applicable to move actions.
 */
- (void)dataProvider:(id <SPXDataProvider>)provider didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(SPXDataProviderChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;


/**
 *  This method will execute when the data provider did complete an update
 *
 *  @param provider The data provider that was updated
 */
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



