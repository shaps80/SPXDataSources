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

#import "SPXArrayDataProvider.h"
#import "SPXDefines.h"

@import UIKit;

@interface SPXArrayDataProvider ()
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMapTable *sectionToItemsMapping;
@property (nonatomic, strong) SPXArrayDataConfiguration *configuration;
@end

@implementation SPXArrayDataProvider

@synthesize delegate = _delegate;

+ (instancetype)providerWithConfiguration:(void (^)(SPXArrayDataConfiguration *))configurationBlock
{
  SPXAssertTrueOrReturnNil(configurationBlock);
  
  SPXArrayDataProvider *provider = [SPXArrayDataProvider new];
  SPXArrayDataConfiguration *configuration = [SPXArrayDataConfiguration new];
  configuration.sectionNameKeyPath = @"";
  configurationBlock(configuration);
  [provider applyConfiguration:configuration];
  return provider;
}

- (void)applyConfiguration:(SPXArrayDataConfiguration *)configuration
{
  self.configuration = configuration;
  [self reloadData];
}

- (NSUInteger)numberOfSections
{
  return self.sections.count;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
  if (section > [self numberOfSections] - 1) {
    return 0;
  }
  
  NSArray *items = [self.sectionToItemsMapping objectForKey:self.sections[section]];
  return items.count;
}

- (NSString *)sectionNameForSection:(NSInteger)section
{
  id object = self.sections[section];
  
  if ([object isKindOfClass:[NSString class]]) {
    return object;
  }
  
  if ([object respondsToSelector:@selector(stringValue)]) {
    return [object stringValue];
  }
  
  return [NSString stringWithFormat:@"%@", object];
}

- (NSUInteger)numberOfItems
{
  return self.configuration.contents.count;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  id section = self.sections[indexPath.section];
  return [self.sectionToItemsMapping objectForKey:section][indexPath.item];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
  for (int section = 0; section < self.sections.count; section++) {
    for (int item = 0; item < [self numberOfItemsInSection:section]; item++) {
      id sectionObject = self.sections[section];
      NSArray *items = [self.sectionToItemsMapping objectForKey:sectionObject];
      if (items[item] == object) {
        return [NSIndexPath indexPathForItem:item inSection:section];
      }
    }
  }
  
  return nil;
}

- (NSArray *)allItems
{
  return self.configuration.contents;
}

- (NSError *)reloadData
{
  [self reloadContent];
  [self reloadSortDescriptors];
  
  return nil;
}

- (void)reloadContent
{
  self.sections = [NSMutableArray new];
  self.sectionToItemsMapping = [NSMapTable weakToStrongObjectsMapTable];
  
  NSMutableArray *contents = self.configuration.contents.mutableCopy;
  
  if (!self.configuration.sectionNameKeyPath.length) {
    if (self.configuration.predicate) {
      [contents filterUsingPredicate:self.configuration.predicate];
    }
    
    if (self.configuration.sortDescriptors) {
      [contents sortUsingDescriptors:self.configuration.sortDescriptors];
    }
    
    [self.sections addObject:[NSNull null]];
    [self.sectionToItemsMapping setObject:[NSNull null] forKey:contents];
  }
  
//  NSHashTable *sections = [NSHashTable weakObjectsHashTable];
//  NSMapTable *sectionsToItems = [NSMapTable weakToStrongObjectsMapTable];
//  
//  for (id item in self.configuration.contents) {
//    id value = [item valueForKeyPath:self.configuration.sectionNameKeyPath];
//    NSMutableArray *items = [sectionsToItems objectForKey:value];
//    
//    if (!items) {
//      items = [NSMutableArray new];
//      [sectionsToItems setObject:items forKey:value];
//      [sections addObject:value];
//    }
//    
//    [items addObject:item];
//  }
//  
//  if (self.configuration.sortDescriptors.count) {
//    
//  }
//  
//  for (id section in self.sections) {
//    id items = [sectionsToItems objectForKey:section];
//    [sectionsToItems setObject:items forKey:section];
//  }
//  
//  self.sectionToItemsMapping = sectionsToItems;
}

- (void)reloadSortDescriptors
{
  
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self.delegate respondsToSelector:@selector(dataProviderWillUpdate:)]) {
    [self.delegate dataProviderWillUpdate:self];
  }
  
  NSMutableArray *items = [self.sectionToItemsMapping objectForKey:@(indexPath.section)];
  [items removeObjectAtIndex:indexPath.item];
  
  if ([self.delegate respondsToSelector:@selector(dataProviderDidUpdate:)]) {
    [self.delegate dataProviderDidUpdate:self];
  }
}

@end

