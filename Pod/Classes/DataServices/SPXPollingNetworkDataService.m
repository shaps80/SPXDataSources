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

#import "SPXPollingNetworkDataService.h"
#import "SPXDefines.h"

@interface SPXPollingNetworkDataService ()
@property (nonatomic, strong) NSDate *lastFetchDate;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SPXPollingNetworkDataService

@synthesize pollingInterval = _pollingInterval;

- (void)dealloc
{
  [self stop];
}

- (instancetype)init
{
  self = [super init];
  SPXAssertTrueOrReturnNil(self);
  self.lastFetchDate = [NSDate date];
  return self;
}

- (SPXPollingServiceInterval)pollingInterval
{
  return _pollingInterval ?: SPXPollingServiceIntervalDefault;
}

- (void)setPollingInterval:(SPXPollingServiceInterval)pollingInterval
{
  if (_pollingInterval == pollingInterval) {
    return;
  }
  
  if (pollingInterval == 0) {
    pollingInterval = SPXPollingServiceIntervalDefault;
  }
  
  _pollingInterval = pollingInterval;
  
  if (self.timer) {
    [self start];
  }
}

- (void)performFetch:(NSTimer *)timer
{
  NSTimeInterval interval = ABS([self.lastFetchDate timeIntervalSinceNow]);
  SPXLog(@"Last fetch %.0f seconds", interval);
  
  __weak typeof(self) weakInstance = self;
  [self fetchWithCompletion:^(id object, NSError *error) {
    __strong typeof(weakInstance) strongSelf = weakInstance;
    !strongSelf.responseHandler ?: strongSelf.responseHandler(object, error);
    self.lastFetchDate = [NSDate date];
  }];
}

- (void)start
{
  SPXLog(@"Fetch started for '%@'", self.URL);
  
  __weak typeof(self) weakInstance = self;
  self.timer = [NSTimer scheduledTimerWithTimeInterval:self.pollingInterval target:weakInstance selector:@selector(performFetch:) userInfo:nil repeats:YES];
  self.timer.tolerance = self.pollingInterval * 0.1;
  [self performFetch:nil];
}

- (void)stop
{
  [self.timer invalidate];
  self.timer = nil;
  self.responseHandler = nil;
  
  SPXLog(@"Fetch stopped for '%@'", self.URL);
}

- (void)cancel
{
  [self stop];
  [super cancel];
}

@end
