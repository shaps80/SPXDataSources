//
//  SPXAppDelegate.m
//  SPXDataSources
//
//  Created by CocoaPods on 02/06/2015.
//  Copyright (c) 2014 Shaps Mohsenin. All rights reserved.
//

#import <objc/runtime.h>
#import "SPXAppDelegate.h"

static void * AppContext = &AppContext;

@interface App : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation App
@end


@interface SPXAppDelegate ()
@property (nonatomic, strong) NSMutableArray *apps;
@end

@implementation SPXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.apps = [NSMutableArray new];
  
  App *app = [App new];
  [self addObserver:self forObject:app options:NSKeyValueObservingOptionNew context:AppContext];
  [self.apps addObject:app];
  
//  app.name = @"Shaps";
  
  return YES;
}

- (void)addObserver:(NSObject *)observer forObject:(id)object options:(NSKeyValueObservingOptions)options context:(void *)context
{
  unsigned int count;
  
  Class klass = [object class];
  
  do {
    objc_property_t *properties = class_copyPropertyList([klass class], &count);
    
    for (size_t i = 0; i < count; ++i) {
      NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
      NSLog(@"Added: %@", key);
      [object addObserver:observer forKeyPath:key options:options context:context];
    }
    
    free(properties);
  } while ((klass = [klass superclass]));
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == AppContext) {
    NSLog(@"%@: %@", object, change);
    return;
  }
  
  [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
