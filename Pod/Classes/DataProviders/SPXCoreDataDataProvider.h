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

@interface SPXCoreDataDataProvider : NSObject <SPXDataProvider>

@property (nonatomic, readonly) SPXCoreDataConfiguration *configuration;;

+ (instancetype)providerWithConfiguration:(void (^)(SPXCoreDataConfiguration *configuration))configurationBlock;
- (void)applyConfiguration:(SPXCoreDataConfiguration *)configuration;

@end


