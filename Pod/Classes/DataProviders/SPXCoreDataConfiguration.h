//
//  SPXCoreDataConfiguration.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "SPXDataProviderConfiguration.h"


/**
 *  Provides a configuration object to be used with SPXCoreDataDataProvider
 */
@interface SPXCoreDataConfiguration : SPXDataProviderConfiguration


/**
 *  Gets/sets the managedObjectContext associated with this configuration
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


/**
 *  Gets/sets the name of the entity to associate with this configuration
 */
@property (nonatomic, strong) NSString *entityName;


@end

