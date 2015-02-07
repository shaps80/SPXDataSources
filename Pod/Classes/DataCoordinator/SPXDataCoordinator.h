//
//  SPXDataCoordinator.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPXDataProvider.h"
#import "SPXDataView.h"

/**
 *  This reuse identifier can be used to load a default cell implementation. Useful while prototyping
 */
extern NSString * const SPXDataViewViewReuseIdentifier;

@protocol SPXDataCoordinatorDelegate;


/**
 *  A data coordinator provides a middle-man between your dataView and dataProvider.
 *  Its recommended that you retain the coordinator and use it to get access to your data through its dataProvider.
 *
 *  @example
 *
 *    - (void)viewDidLoad 
 *    {
 *      SPXCoreDataDataProvider *provider = [SPXCoreDataProvider providerWithConfiguration:^ (SPXCoreDataConfiguration *config) {
 *        config.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES] ];
 *      }];
 *
 *      self.coordinator = [SPXDataCoordinator coordinatorForDataView:self.tableView dataProvider:provider];
 *    }
 */
@interface SPXDataCoordinator : NSObject


/**
 *  Gets/sets the delegate for this coordinator
 */
@property (nonatomic, weak) id <SPXDataCoordinatorDelegate> delegate;


/**
 *  Returns the dataProvider associated with this coordinator
 */
@property (nonatomic, readonly) id <SPXDataProvider> dataProvider;


/**
 *  Returns the dataView associated with this coordinator
 */
@property (nonatomic, weak, readonly) id <SPXDataView> dataView;


/**
 *  Initializes a new coordinator with the specified view and data provider
 *
 *  @param dataView     The dataView that will present your data
 *  @param dataProvider The dataProvider that will provide your data to your view
 *
 *  @return A new instance of SPXDataCoordinator
 */
+ (instancetype)coordinatorForDataView:(id <SPXDataView>)dataView dataProvider:(id <SPXDataProvider>)dataProvider;


@end



/**
 *  Defines the interface required for a data coordinator's delegate
 */
@protocol SPXDataCoordinatorDelegate <NSObject>


/**
 *  This method is called when changes are applied to the dataProvider managed by this coordinator
 *
 *  @param coordinator The coordinator where these changes occurred
 */
- (void)coordinatorDidUpdate:(SPXDataCoordinator *)coordinator;


@end

