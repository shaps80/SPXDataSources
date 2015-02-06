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

@interface SPXArrayDataProvider : NSObject <SPXDataProvider>

+ (instancetype)providerWithConfiguration:(void (^)(SPXArrayDataConfiguration *configuration))configurationBlock;
- (void)applyConfiguration:(SPXArrayDataConfiguration *)configuration;

@end

