//
//  SPXCoreDataConfiguration.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import CoreData;
#import "SPXDataProviderConfiguration.h"

@interface SPXCoreDataConfiguration : SPXDataProviderConfiguration

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *entityName;

@end
