//
//  SPXDataProviderConfiguration.h
//  Drizzle
//
//  Created by Shaps Mohsenin on 14/11/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  Defines a top level class for providing data provider's with their configuration. 
 *  This object should be subclassed to provide your own implementations and custom data providers.
 */
@interface SPXDataProviderConfiguration : NSObject <NSCopying>


/**
 *  Gets/sets the sort descriptors to associate with this configuration
 */
@property (nonatomic, strong) NSArray *sortDescriptors;


/**
 *  Gets/sets the predicate to associate with this configuration
 */
@property (nonatomic, strong) NSPredicate *predicate;


/**
 *  Gets/sets the section keyPath to associate with this configuration
 */
@property (nonatomic, strong) NSString *sectionNameKeyPath;


@end

