//
//  SPXArrayConfiguration.m
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXArrayConfiguration.h"

@interface SPXArrayDataConfiguration ()
@property (nonatomic, strong) NSMutableArray *data;
@end


@implementation SPXArrayDataConfiguration

- (id)copyWithZone:(NSZone *)zone
{
  SPXArrayDataConfiguration *configuration = [super copyWithZone:zone];
  configuration.data = self.data;
  return configuration;
}

- (NSArray *)contents
{
  return self.data;
}

- (void)setContents:(NSArray *)contents
{
  self.data = contents.mutableCopy;
}

- (void)deleteItemAtIndex:(NSUInteger)index
{
  [self.data removeObjectAtIndex:index];
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(data));
}

@end

