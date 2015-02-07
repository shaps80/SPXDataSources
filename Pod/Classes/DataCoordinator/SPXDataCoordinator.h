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

