//
//  SPXDataProviderConfiguration.m
//  Drizzle
//
//  Created by Shaps Mohsenin on 14/11/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXDataProviderConfiguration.h"
#import "SPXDefines.h"

@implementation SPXDataProviderConfiguration

- (id)copyWithZone:(NSZone *)zone
{
  SPXDataProviderConfiguration *configuration = [[self.class alloc] init];
  
  configuration.predicate = self.predicate;
  configuration.sectionNameKeyPath = self.sectionNameKeyPath;
  configuration.sortDescriptors = self.sortDescriptors;
  
  return configuration;
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(predicate), SPXKeyPath(sectionNameKeyPath), SPXKeyPath(sortDescriptors));
}

@end
