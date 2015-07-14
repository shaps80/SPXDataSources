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

#import "SPXNetworkDataService.h"


/**
 *  Defines the available polling priorities, which translate to various polling intervals
 */
typedef NS_ENUM(NSUInteger, SPXPollingServiceInterval){
  /**
   *  Specifies a polling interval of 10 seonds
   */
  SPXPollingServiceIntervalDefault = 10,
  /**
   *  Specifies a polling interval of 1 minute (60 seconds)
   */
  SPXPollingServiceIntervalLow = 60,
  /**
   *  Specifies a polling interval of 5 minutes (300 seconds)
   */
  SPXPollingServiceIntervalHigh = 300,
};


/**
 *  Provides an automatic polling network service
 */
@interface SPXPollingNetworkDataService : SPXNetworkDataService


/**
 *  Specifies the polling interval (in seconds) for this service
 */
@property (nonatomic, assign) SPXPollingServiceInterval pollingInterval;


/**
 *  Specifies a response handler for this service. You can either sets this externally or override the getter in a subclass
 */
@property (nonatomic, copy) void (^responseHandler)(id responseObject, NSError *error);


/**
 *  Starts the service. It is still possible to call -performWithCompletion if needed
 */
- (void)start;


/**
 *  Stops the service. Effectively the same as calling -cancel
 */
- (void)stop;


@end

