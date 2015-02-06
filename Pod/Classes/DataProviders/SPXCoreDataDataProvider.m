//
//  SPXCoreDataDataProvider.m
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import "SPXCoreDataDataProvider.h"
#import "SPXDefines.h"
#import "SPXCoreData.h"

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
  [self reloadData];
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath
{
  NSManagedObject *object = [self objectAtIndexPath:indexPath];
  NSManagedObjectID *identifier = object.objectID;
  
  [SPXCoreDataStack saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
    NSManagedObject *objectToDelete = [localContext objectWithID:identifier];
    [localContext deleteObject:objectToDelete];
  }];
}

- (NSArray *)allItems
{
  return self.fetchedResultsController.fetchedObjects;
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
  return _fetchedResultsController ?: ({
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:self.configuration.entityName];
    request.sortDescriptors = self.configuration.sortDescriptors;
    request.predicate = self.configuration.predicate;
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.configuration.managedObjectContext sectionNameKeyPath:self.configuration.sectionNameKeyPath cacheName:nil];
    fetchedResultsController.delegate = self;
    _fetchedResultsController = fetchedResultsController;
  });
}

- (NSError *)reloadData
{
  _fetchedResultsController = nil;
  
  __block NSError *error = nil;
  __weak typeof(self) weakInstance = self;
  
  [self.configuration.managedObjectContext performBlockAndWait:^{
    SPXCAssertTrueOrReturn([NSThread isMainThread]);
    [weakInstance.fetchedResultsController performFetch:&error];
  }];
  
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
