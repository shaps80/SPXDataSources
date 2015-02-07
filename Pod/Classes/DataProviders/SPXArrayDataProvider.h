//
//  SPXArrayDataProvider.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataProvider.h"
#import "SPXArrayConfiguration.h"

@import Foundation;


/**
 *  A data provider that manages data in an array
 */
@interface SPXArrayDataProvider : NSObject <SPXDataProvider>


/**
 *  Initializes a new array dataProvider with the specified configuration
 *
 *  @param configurationBlock A configuration block, use this to configure your provider
 *
 *  @return A new instance of SPXArrayDataProvider
 */
+ (instancetype)providerWithConfiguration:(void (^)(SPXArrayDataConfiguration *configuration))configurationBlock;


/**
 *  Applies the specified configuration to this provider
 *
 *  @param configuration The configuration to apply
 */
- (void)applyConfiguration:(SPXArrayDataConfiguration *)configuration;


@end

