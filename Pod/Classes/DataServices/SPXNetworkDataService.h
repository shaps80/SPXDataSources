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

#import "SPXDataService.h"


/**
 *  This code will be returned in an NSError when you attempt to run a fetch twice on a given service
 */
extern NSUInteger const SPXNetworkDataServiceRunningErrorCode;


@protocol SPXNetworkDataServiceDelegate;


/**
 *  Defines a network service
 */
@interface SPXNetworkDataService : SPXDataService


/**
 *  The URL associated with this service
 */
@property (nonatomic, copy, readonly) NSURL *URL;


/**
 *  An error handler block -- can be specified to handle JSON errors, etc...
 */
@property (nonatomic, copy) NSError* (^errorHandlerBlock)(NSData *data, NSError *error);


/**
 *  Convenience initializer
 *
 *  @param URL The URL for this service
 *
 *  @return A new instance
 */
+ (instancetype)networkServiceForURL:(NSURL *)URL NS_REQUIRES_SUPER;


/**
 *  Performs a fetch for this service
 *
 *  @param completion The completion block to execute after this fetch has completed
 */
- (void)fetchWithCompletion:(void (^)(id object, NSError *error))completion NS_REQUIRES_SUPER;


@end

