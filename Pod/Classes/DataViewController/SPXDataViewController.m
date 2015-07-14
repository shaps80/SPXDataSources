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

#import <objc/runtime.h>
#import "SPXDataViewController.h"
#import "SPXDefines.h"

@interface SPXControllerConfiguration (Private)
@property (nonatomic, weak) UIViewController *controller;
@end

@interface UIViewController (SPXDataViewPrivateAdditions)
@property (nonatomic, strong) SPXControllerConfiguration *configuration;
@end

@interface SPXDataViewController () <UITableViewDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) SPXDataCoordinator *dataCoordinator;
@property (nonatomic, strong) IBOutlet UIRefreshControl *refreshControl;

@end

@implementation SPXDataViewController

@synthesize selectedIndexPath = _selectedIndexPath;

#pragma mark - Lifecycle

- (void)loadView
{
  [super loadView];
  
  if (!self.configuration) {
    self.configuration = [SPXControllerConfiguration new];
  }
  
  [self prepareConfiguration];
  
  UIView *view = super.view;
  
  if (![self.view conformsToProtocol:@protocol(SPXDataView)]) {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    view = tableView;
  }
  
  self.view = view;
}

- (UIView<SPXDataView> *)dataView
{
  return (UIView <SPXDataView>*)self.view;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = self.configuration.title;
  
  if (self.configuration.supportsPullToRefresh && !self.refreshControl) {
    self.refreshControl = [UIRefreshControl new];
    [self.dataView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
  }
  
  if (self.configuration.dataProvider) {
    self.dataCoordinator = [SPXDataCoordinator coordinatorForDataView:self.dataView dataProvider:self.configuration.dataProvider];
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:self.configuration.navigationBarHidden animated:YES];
  
  if (self.toolbarItems) {
    [self.navigationController setToolbarHidden:self.configuration.toolBarHidden animated:YES];
  }
  
  if (self.configuration.hidesTabBarOnPush) {
    [self.tabBarController hidesBottomBarWhenPushed];
  }
  
  if (self.selectedIndexPath) {
    [self.dataView selectItemAtIndexPath:self.selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  UIViewController *nextController = self.navigationController.topViewController;
  
  if (!nextController) {
    nextController = self.presentingViewController ?: self.presentedViewController;
  }
  
  [self.navigationController setNavigationBarHidden:nextController.configuration.navigationBarHidden animated:YES];
  
  if (nextController.toolbarItems) {
    [self.navigationController setToolbarHidden:nextController.configuration.toolBarHidden animated:YES];
  }
}

#pragma mark - Actions

- (void)addEntity:(id)sender
{
  // do nothing by default
}

- (void)dismiss
{
  if (self.configuration.presentationStyle == SPXControllerPresentationStylePush ||
      self.configuration.presentationStyle == SPXControllerPresentationStylePushPopOnSelection) {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  
  if (self.configuration.presentationStyle == SPXControllerPresentationStyleModal ||
      self.configuration.presentationStyle == SPXControllerPresentationStyleModalDismissOnSelection) {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  } else {
    if (self.navigationController.viewControllers.firstObject != self) {
      [self.navigationController popViewControllerAnimated:YES];
    } else {
      [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
  }
}

- (void)refresh:(id)sender
{
  [self.dataCoordinator.dataProvider reloadData];
  [self.refreshControl endRefreshing];
}

#pragma mark - Configuration

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.configuration.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
  return self.configuration.prefersStatusBarHidden;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return self.configuration.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return self.configuration.preferredInterfaceOrientationForPresentation;
}

#pragma mark - TableView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [self selectIndexPath:indexPath userInitiated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self selectIndexPath:indexPath userInitiated:YES];
}

- (void)selectIndexPath:(NSIndexPath *)indexPath userInitiated:(BOOL)userInitiated
{
  self.selectedIndexPath = indexPath;
  [self.dataView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
  
  id item = [self.dataCoordinator.dataProvider objectAtIndexPath:indexPath];
  !self.selectionBlock ?: self.selectionBlock(item, indexPath);
  
  if (!userInitiated) {
    return;
  }
  
  if (self.configuration.presentationStyle == SPXControllerPresentationStyleModalDismissOnSelection ||
      self.configuration.presentationStyle == SPXControllerPresentationStylePushPopOnSelection) {
    [self dismiss];
  }
}

#pragma mark - Class method helpers

+ (instancetype)viewControllerFromStoryboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier
{
  SPXDataViewController *controller = [storyboard instantiateViewControllerWithIdentifier:identifier];
  SPXAssertTrueOrReturnNil([controller isKindOfClass:[SPXDataViewController class]]);
  return controller;
}

+ (SPXControllerConfiguration *)configurationForPresentationStyle:(SPXControllerPresentationStyle)style
{
  SPXControllerConfiguration *configuration = [SPXControllerConfiguration new];
  configuration.presentationStyle = style;
  return configuration;
}

+ (instancetype)viewControllerWithConfiguration:(SPXControllerConfiguration *)configuration
{
  SPXDataViewController *controller = [self.class new];
  controller.configuration = configuration;
  return controller;
}

@end

@implementation UIViewController (SPXControllerAdditions)

- (void)prepareConfiguration
{
  
}

- (SPXControllerConfiguration *)configuration
{
  return objc_getAssociatedObject(self, @selector(configuration));
}

- (void)setConfiguration:(SPXControllerConfiguration *)configuration
{
  configuration.controller = self;
  objc_setAssociatedObject(self, @selector(configuration), configuration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SPXDataViewController *)presentViewControllerWithConfiguration:(SPXControllerConfiguration *)configuration
{
  return [self presentViewControllerOfType:SPXDataViewController.class configuration:configuration];
}

- (SPXDataViewController *)presentViewControllerOfType:(Class)controllerClass configuration:(SPXControllerConfiguration *)configuration
{
  SPXDataViewController *controller = [controllerClass new];
  return [self presentViewController:controller configuration:configuration];
}

- (SPXDataViewController *)presentViewController:(SPXDataViewController *)controller configuration:(SPXControllerConfiguration *)configuration
{
  SPXAssertTrueOrReturnNil([controller isKindOfClass:[SPXDataViewController class]]);
  
  SPXControllerConfiguration *config = configuration.copy;
  
  if (!config.supportedInterfaceOrientations) {
    config.supportedInterfaceOrientations = controller.supportedInterfaceOrientations;
    configuration.supportedInterfaceOrientations = controller.supportedInterfaceOrientations;
  }
  
  controller.configuration = config;
  
  if ((config.presentationStyle == SPXControllerPresentationStyleDefault && self.navigationController) ||
      config.presentationStyle == SPXControllerPresentationStylePush ||
      config.presentationStyle == SPXControllerPresentationStylePushPopOnSelection) {
    [self.navigationController pushViewController:controller animated:YES];
  } else {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
  }
  
  return controller;
}

@end


