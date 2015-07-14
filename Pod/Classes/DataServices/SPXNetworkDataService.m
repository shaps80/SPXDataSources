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
#import "SPXDefines.h"

NSUInteger const SPXNetworkDataServiceRunningErrorCode = -111999;

@interface SPXNetworkDataService () <NSURLSessionDataDelegate>
@property (nonatomic, copy) NSURL *URL;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;
@end

@implementation SPXNetworkDataService

- (void)dealloc
{
  [self cancel];
}

+ (instancetype)networkServiceForURL:(NSURL *)URL
{
  SPXNetworkDataService *service = [self new];
  service.URL = URL;
  return service;
}

- (NSURLSession *)session
{
  return _session ?: ({
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    _session = session;
  });
}

- (void)cancel
{
  [self.session invalidateAndCancel];
  self.currentTask = nil;
}

- (void)fetchWithCompletion:(void (^)(id object, NSError *error))completion
{
  if (self.currentTask) {
    return;
  }
  
  SPXAssertTrueOrReturn(completion);
  
  __weak typeof(self) weakInstance = self;
  self.currentTask = [self.session dataTaskWithURL:self.URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    weakInstance.currentTask = nil;
    NSError *internalError = error ?: [self errorForResponseData:data];
    
    if (error && weakInstance.errorHandlerBlock) {
      internalError = weakInstance.errorHandlerBlock(data, error);
    }
    
    NSInteger code = ((NSHTTPURLResponse *)response).statusCode;
    
    if (!internalError && code >= 400) {
      NSDictionary *userInfo = @
      { NSLocalizedDescriptionKey : @"Resource Not Found",
        @"html" : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]
      };
      
      internalError = [NSError errorWithDomain:@"uk.co.snippex.ios.data_service" code:code userInfo:userInfo];
    }
    
    !completion ?: completion([self objectForResponseData:data], internalError);
  }];
  
  [self.currentTask resume];
}

- (NSData *)fetch:(NSError *__autoreleasing *)error
{
  if (self.currentTask) {
    if (error) {
      *error = [NSError errorWithDomain:@"uk.co.snippex.ios.data_service" code:SPXNetworkDataServiceRunningErrorCode userInfo:@{ NSLocalizedDescriptionKey : @"This service is already running, please wait for it to complete before attempting again." }];
    }
    
    return nil;
  }
  
  dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
  
  __block id internalObject = nil;
  __block NSError *internalError = nil;
  
  [self fetchWithCompletion:^(NSData *data, NSError *error) {
    internalObject = data;
    internalError = error;
    dispatch_semaphore_signal(semaphore);
  }];
  
  dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
  
  if (internalError) {
    *error = internalError;
  }
  
  self.currentTask = nil;
  return internalObject;
}

@end
