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

@import Foundation;


/**
 *  Defines an abstract data service class. By default this class does nothing and should not be used directly
 */
@interface SPXDataService : NSObject


/**
 *  Performs a synchronous fetch
 *
 *  @param error If an error occurred, this will contain its value, nil otherwise
 *
 *  @return If no error occurred, an NSData object will be returned
 */
- (NSData *)fetch:(NSError * __autoreleasing *)error;


/**
 *  Cancels the current service request
 */
- (void)cancel;


/**
 *  You can override this method to inspect the response data for any JSON errors
 *
 *  @param data The response data
 *
 *  @return Return an NSError instance if the response data represents an error, nil otherwise
 */
- (NSError *)errorForResponseData:(NSData *)data;


/**
 *  You can override this method to return another object type from the given response data. (e.g. JSON from NSData)
 *
 *  @param data The original response data
 *
 *  @return A new object representation of the data
 */
- (id)objectForResponseData:(NSData *)data;


@end

