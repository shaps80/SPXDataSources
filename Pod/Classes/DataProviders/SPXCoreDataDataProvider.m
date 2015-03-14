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

#import "SPXCoreDataDataProvider.h"
#import "SPXDefines.h"

@interface SPXCoreDataDataProvider () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) SPXCoreDataConfiguration *configuration;
@end

@implementation SPXCoreDataDataProvider

@synthesize delegate = _delegate;

+ (instancetype)providerWithConfiguration:(void (^)(SPXCoreDataConfiguration *))configurationBlock
{
  SPXAssertTrueOrReturnNil(configurationBlock);
  
  SPXCoreDataDataProvider *provider = [SPXCoreDataDataProvider new];
  SPXCoreDataConfiguration *configuration = [SPXCoreDataConfiguration new];
  configurationBlock(configuration);
  [provider applyConfiguration:configuration];
  return provider;
}

- (void)applyConfiguration:(SPXCoreDataConfiguration *)configuration
{
  self.configuration = configuration;
  self.configuration.fetchedResultsController.delegate = self;
  [self reloadData];
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
  SPXAssertTrueOrPerformAction(self.deletionHandler, SPXLog(@"You must provide a deletion handler to handle deletes"); return);
  
  if ([self.delegate respondsToSelector:@selector(dataProviderWillUpdate:)]) {
    [self.delegate dataProviderWillUpdate:self];
  }
  
  !self.deletionHandler ?: self.deletionHandler(indexPath);
  
  if ([self.delegate respondsToSelector:@selector(dataProviderDidUpdate:)]) {
    [self.delegate dataProviderDidUpdate:self];
  }
}

- (NSArray *)allItems
{
  return self.fetchedResultsController.fetchedObjects;
}

- (NSArray *)sections
{
  return self.fetchedResultsController.sections;
}

- (NSUInteger)numberOfSections
{
  return self.fetchedResultsController.sections.count;
}

- (NSUInteger)numberOfItems
{
  return self.fetchedResultsController.fetchedObjects.count;
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)section
{
  return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
  if (!((NSUInteger)indexPath.section < self.fetchedResultsController.sections.count)) {
    return nil;
  }
  
  id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
  
  if (!((NSUInteger)indexPath.item < sectionInfo.numberOfObjects)) {
    return nil;
  }
  
  return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
  return [self.fetchedResultsController indexPathForObject:object];
}

- (NSPredicate *)predicate
{
  return self.configuration.predicate;
}

- (NSArray *)sortDescriptors
{
  return self.configuration.sortDescriptors;
}

- (NSString *)sectionNameForSection:(NSInteger)section
{
  return [self.fetchedResultsController.sections[section] name];
}

- (NSFetchedResultsController *)fetchedResultsController
{
  return self.configuration.fetchedResultsController;
}

- (NSError *)reloadData
{
  SPXAssertTrueOrReturnNil([NSThread isMainThread]);
  _fetchedResultsController = nil;
  
  __block NSError *error = nil;
  [self.fetchedResultsController performFetch:&error];
  return error;
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(configuration));
}

#pragma mark - FetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  if ([self.delegate respondsToSelector:@selector(dataProviderWillUpdate:)]) {
    [self.delegate dataProviderWillUpdate:self];
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  SPXDataProviderSectionInfo *info = [SPXDataProviderSectionInfo sectionInfoFromFetchedResultsSectionInfo:sectionInfo];
  
  if ([self.delegate respondsToSelector:@selector(dataProvider:didChangeSection:atIndex:forChangeType:)]) {
    [self.delegate dataProvider:self didChangeSection:info atIndex:sectionIndex forChangeType:(SPXDataProviderChangeType)type];
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  if ([self.delegate respondsToSelector:@selector(dataProvider:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
    [self.delegate dataProvider:self didChangeObject:anObject atIndexPath:indexPath forChangeType:(SPXDataProviderChangeType)type newIndexPath:newIndexPath];
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  if ([self.delegate respondsToSelector:@selector(dataProviderDidUpdate:)]) {
    [self.delegate dataProviderDidUpdate:self];
  }
}

@end
