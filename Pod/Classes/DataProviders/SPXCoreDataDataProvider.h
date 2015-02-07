//
//  SPXCoreDataDataProvider.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataProvider.h"
#import "SPXCoreDataConfiguration.h"

@import UIKit;
@import CoreData;


/**
 *  Defines a deletion handler block
 *
 *  @param objectID The objectID of the NSManagedObject that should be deleted
 */
typedef void (^SPXCoreDataDeletionHandler)(NSManagedObjectID *objectID);


/**
 *  A data provider that binds to CoreData
 */
@interface SPXCoreDataDataProvider : NSObject <SPXDataProvider>


/**
 *  Returns the current configuration applied to this provider. To make changes to this configuration, use -applyConfiguration: below
 */
@property (nonatomic, readonly) SPXCoreDataConfiguration *configuration;


/**
 *  Description
 *
 *  @example
 *  
 *    [SPXCoreDataStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
 *      NSManagedObject *objectToDelete = [localContext objectWithID:identifier];
 *      [localContext deleteObject:objectToDelete];
 *    }];
 */
@property (nonatomic, strong) SPXCoreDataDeletionHandler deletionHandler;


/**
 *  Returns a new instance of this provider with the specified configuration
 *
 *  @param configurationBlock The configuration block, this allows you to configure this data provider
 *
 *  @return A new instance of SPXCoreDataDataProvider
 */
+ (instancetype)providerWithConfiguration:(void (^)(SPXCoreDataConfiguration *configuration))configurationBlock;


/**
 *  Apply a new configuration to this provider
 *
 *  @param configuration The configuration to apply
 */
- (void)applyConfiguration:(SPXCoreDataConfiguration *)configuration;


@end


