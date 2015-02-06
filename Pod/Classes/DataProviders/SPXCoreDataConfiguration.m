//
//  SPXCoreDataConfiguration.m
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXCoreDataConfiguration.h"

@implementation SPXCoreDataConfiguration

- (id)copyWithZone:(NSZone *)zone
{
  SPXCoreDataConfiguration *configuration = [super copyWithZone:zone];

  configuration.entityName = self.entityName;
  configuration.managedObjectContext = self.managedObjectContext;

  return configuration;
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(entityName), SPXKeyPath(managedObjectContext));
}

@end

