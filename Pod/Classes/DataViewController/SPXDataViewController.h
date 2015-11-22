/*
   Copyright (c) 2015 shaps.me. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY shaps.me `AS IS' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL shaps.me OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SPXControllerConfiguration.h"
#import "SPXDataSources.h"


/**
 *  Provides a UIViewController subclass that's designed to work closely with <SPXDataProvider> and <SPXDataView> classes. It provides a separate configuration class along with automatic presentation, dismissal, etc... (ideal for prototyping, but also production ready)
 */
@interface SPXDataViewController : UIViewController <UITableViewDelegate>


/**
 *  Get/set the <SPXDataView> associated with this controller. You can also set this property via Interface Builder
 */
@property (nonatomic, weak, readonly) UITableView *tableView;


/**
 *  Returns the data coordinator associated with this controller. The coordinator is configured automatically
 */
@property (nonatomic, readonly) SPXDataCoordinator *dataCoordinator;


/**
 *  Gets the refresh control (if specified in the configuration) associated with this controller
 */
@property (nonatomic, readonly) UIRefreshControl *refreshControl;


/**
 *  Get/set the selected indexPath for the <SPXDataView>. You can use this to select a default selection. This property is also KVO compliant
 */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;


/**
 *  Get/set a block to execute when a selection occurs
 */
@property (nonatomic, copy) void (^selectionBlock)(id item, NSIndexPath *indexPath);


/**
 *  Provided as a convenience, this provides a consistent method for adding an entity to the <SPXDataProvider>. By default this method does nothing -- you are responsible for implementing in your subclasses
 *
 *  @param sender The object that performed this method
 */
- (IBAction)addEntity:(id)sender NS_REQUIRES_SUPER;
- (BOOL)canAddEntity;


/**
 *  Provided as a convenience, this provides a consistent method for refreshing the <SPXDataView>
 *
 *  @param sender The object that performed this method
 */
- (IBAction)refresh:(id)sender;


/**
 *  By default this method configures the controller. Your subclasses can override this method but MUST call super
 */
- (void)viewDidLoad NS_REQUIRES_SUPER;


/**
 *  By default this method configures the controller. Your subclasses can override this method but MUST call super
 *
 *  @param animated If YES, then the view will appear animated
 */
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;


/**
 *  By default this method configures the controller. Your subclasses can override this method but MUST call super
 *
 *  @param animated If YES, then the view will disappear animated
 */
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;


/**
 *  Returns a new SPXDataViewController from the specified storyboard and controller identifier
 *
 *  @param storyboard The storyboard that contains this controller
 *  @param identifier The identifier for this controller
 *
 *  @return A new SPXDataViewController instance if it exists, nil otherwise
 */
+ (instancetype)viewControllerFromStoryboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier;


/**
 *  Returns a new SPXDataViewController with the specified configuration
 *
 *  @param configuration The configuration to use for this instance
 *
 *  @return A new SPXDataViewController instance
 */
+ (instancetype)viewControllerWithConfiguration:(SPXControllerConfiguration *)configuration;


- (void)prepareConfiguration:(SPXControllerConfiguration *)configuration;
- (void)prepareTableView:(UITableView *)tableView NS_REQUIRES_SUPER;
- (id <SPXDataProvider>)prepareDataProvider;
- (void)configureDataCoordinator;

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (void)prepareCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath item:(id)item;


@end


/**
 *  Provides additional convenience methods for presenting SPXDataViewController's
 */
@interface UIViewController (SPXControllerAdditions)


/**
 *  Get/set the configuration associated with this controller
 */
@property (nonatomic, readonly) SPXControllerConfiguration *configuration;


/**
 *  Presents a new SPXDataViewController instance with the specified configuration
 *
 *  @param configuration The configuration to use for this SPXDataViewController
 *
 *  @return A new SPXDataViewController instance
 */
- (SPXDataViewController *)presentViewControllerWithConfiguration:(SPXControllerConfiguration *)configuration;


/**
 *  Presents a new SPXDataViewController instance with the specified configuration
 *
 *  @param controllerClass The SPXDataViewController class to use for this instance
 *  @param configuration   The configuration to use for this SPXDataViewController
 *
 *  @return A new SPXDataViewController subclass instance
 */
- (SPXDataViewController *)presentViewControllerOfType:(Class)controllerClass configuration:(SPXControllerConfiguration *)configuration;


/**
 *  Presents the SPXDataViewController instance with the specified configuration
 *
 *  @param controller    The controller to present
 *  @param configuration The configuration to use for this SPXDataViewController
 *
 *  @return The configured SPXDataViewController instance
 */
- (SPXDataViewController *)presentViewController:(SPXDataViewController *)controller configuration:(SPXControllerConfiguration *)configuration;


@end


