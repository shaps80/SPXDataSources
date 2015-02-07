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


