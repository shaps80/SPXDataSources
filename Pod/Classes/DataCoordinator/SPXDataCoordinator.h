//
//  SPXDataCoordinator.h
//  OAuth
//
//  Created by Shaps Mohsenin on 30/10/2014.
//  Copyright (c) 2014 Snippex. All rights reserved.
//

@import Foundation;

#import "SPXDataProvider.h"
#import "SPXDataView.h"

extern NSString * const SPXDataViewViewReuseIdentifier;

@protocol SPXDataCoordinatorDelegate;

@interface SPXDataCoordinator : NSObject

@property (nonatomic, weak) id <SPXDataCoordinatorDelegate> delegate;
@property (nonatomic, strong, readonly) id <SPXDataProvider> dataProvider;

+ (instancetype)coordinatorForDataView:(id <SPXDataView>)dataView dataProvider:(id <SPXDataProvider>)dataProvider;

@end


@protocol SPXDataCoordinatorDelegate <NSObject>
- (void)coordinatorDidUpdate:(SPXDataCoordinator *)coordinator;
@end