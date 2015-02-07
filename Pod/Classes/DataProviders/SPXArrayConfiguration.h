//
//  SPXArrayConfiguration.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataProviderConfiguration.h"


/**
 *  Provides a configuration object to be used with SPXArrayDataProvider
 */
@interface SPXArrayDataConfiguration : SPXDataProviderConfiguration


/**
 *  Gets/sets the initial content to associate with this configuration
 */
@property (nonatomic, strong) NSArray *contents;


@end

