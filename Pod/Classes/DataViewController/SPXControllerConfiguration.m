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
#import "SPXControllerConfiguration.h"
#import "SPXDefines.h"
#import "SPXDataViewController.h"

#define _SPXMaskHasValue(options, value) (((options) & (value)) == (value))

@interface SPXDataViewController (Private)
- (void)dismiss;
@end

@interface SPXControllerConfiguration ()
@property (nonatomic, weak) UIViewController *controller;
@property (nonatomic, assign) BOOL prefersStatusBarHiddenSet;
@end

@implementation SPXControllerConfiguration

@synthesize prefersStatusBarHidden = _prefersStatusBarHidden;

#pragma mark - Lifecycle

- (id)copyWithZone:(NSZone *)zone
{
  SPXControllerConfiguration *copy = [self.class new];
  
  copy->_dataProvider = self.dataProvider;
  copy->_hidesTabBarOnPush = self.hidesTabBarOnPush;
  copy->_leftNavItem = self.leftNavItem;
  copy->_rightNavItem = self.rightNavItem;
  copy->_presentationStyle = self.presentationStyle;
  copy->_navigationBarHidden = self.navigationBarHidden;
  copy->_toolBarHidden = self.toolBarHidden;
  copy->_title = self.title;
  copy->_supportsPullToRefresh = self.supportsPullToRefresh;
  copy->_supportedInterfaceOrientations = self.supportedInterfaceOrientations;
  copy->_preferredStatusBarStyle = self.preferredStatusBarStyle;
  copy->_prefersStatusBarHidden = self.prefersStatusBarHidden;
  copy->_prefersStatusBarHiddenSet = self.prefersStatusBarHiddenSet;
  
  return copy;
}

#pragma mark - Setters

- (void)setHidesTabBarOnPush:(BOOL)hidesTabBarOnPush
{
  _hidesTabBarOnPush = hidesTabBarOnPush;
  self.controller.hidesBottomBarWhenPushed = hidesTabBarOnPush;
}

- (void)setLeftNavItem:(SPXControllerNavItem)leftNavItem
{
  _leftNavItem = leftNavItem;
  self.controller.navigationItem.leftBarButtonItem = [self barButtonItemForNavItem:leftNavItem];
}

- (void)setRightNavItem:(SPXControllerNavItem)rightNavItem
{
  _rightNavItem = rightNavItem;
  self.controller.navigationItem.rightBarButtonItem = [self barButtonItemForNavItem:rightNavItem];
}

- (void)setPreferredStatusBarStyle:(UIStatusBarStyle)preferredStatusBarStyle
{
  _preferredStatusBarStyle = preferredStatusBarStyle;
  [self.controller setNeedsStatusBarAppearanceUpdate];
}

- (UIBarButtonItem *)barButtonItemForNavItem:(SPXControllerNavItem)item
{
  switch (item) {
    case SPXControllerNavItemDone: {
      return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.controller action:@selector(dismiss)];
    }
    case SPXControllerNavItemCancel: {
      return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.controller action:@selector(dismiss)];
    }
    case SPXControllerNavItemAdd: {
      return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self.controller action:@selector(addEntity:)];
    }
    default:
      return nil;
  }
}

#pragma mark - Getters

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
  return _supportedInterfaceOrientations ?: UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)setPrefersStatusBarHidden:(BOOL)prefersStatusBarHidden
{
  self.prefersStatusBarHiddenSet = YES;
  _prefersStatusBarHidden = prefersStatusBarHidden;
  [self.controller setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden
{
  if (!_prefersStatusBarHiddenSet) {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    BOOL hidden = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(orientation));
    return (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) ? hidden : NO;
  }
  
  return _prefersStatusBarHidden;
}

#pragma mark - Debugging

- (NSString *)stringForNavItem:(SPXControllerNavItem)item
{
  switch (self.rightNavItem) {
    case SPXControllerNavItemNone: {
      return @"None";
    }
    case SPXControllerNavItemDone: {
      return @"Done";
    }
    case SPXControllerNavItemCancel: {
      return @"Cancel";
    }
    case SPXControllerNavItemAdd: {
      return @"Add";
    }
  }
}

- (NSString *)presentationStyleValue
{
  switch (self.presentationStyle) {
    case SPXControllerPresentationStyleDefault: {
      return @"Default";
    }
    case SPXControllerPresentationStyleModal: {
      return @"Modal";
    }
    case SPXControllerPresentationStyleModalDismissOnSelection: {
      return @"Modal, Dismiss on Selection";
    }
    case SPXControllerPresentationStylePush: {
      return @"Push";
    }
    case SPXControllerPresentationStylePushPopOnSelection: {
      return @"Push, Pop on Selection";
    }
  }
}

- (NSString *)supportedOrientationsValue
{
  if (self.supportedInterfaceOrientations == UIInterfaceOrientationMaskAll) {
    return @"All";
  }
  
  if (self.supportedInterfaceOrientations == UIInterfaceOrientationMaskAllButUpsideDown) {
    return @"All but upside down";
  }
  
  if (self.supportedInterfaceOrientations == UIInterfaceOrientationMaskLandscape) {
    return @"Landscape";
  }
  
  NSMutableArray *orientations = [NSMutableArray new];
  
  if (_SPXMaskHasValue(self.supportedInterfaceOrientations, UIInterfaceOrientationMaskPortrait)) {
    [orientations addObject:@"Portrait"];
  }
  
  if (_SPXMaskHasValue(self.supportedInterfaceOrientations, UIInterfaceOrientationMaskPortraitUpsideDown)) {
    [orientations addObject:@"Portrait upside down"];
  }
  
  if (_SPXMaskHasValue(self.supportedInterfaceOrientations, UIInterfaceOrientationMaskPortrait)) {
    [orientations addObject:@"Landscape Left"];
  }
  
  if (_SPXMaskHasValue(self.supportedInterfaceOrientations, UIInterfaceOrientationMaskPortrait)) {
    [orientations addObject:@"Landscape Right"];
  }
  
  return orientations.count ? [orientations componentsJoinedByString:@", "] : @"Undefined";
}

- (NSString *)preferredStatusBarStyleValue
{
  switch (self.preferredStatusBarStyle) {
    case UIStatusBarStyleLightContent: {
      return @"Light Content";
    }
    default: {
      return @"Default";
    }
  }
}

- (NSString *)rightNavItemValue
{
  return [self stringForNavItem:self.rightNavItem];
}

- (NSString *)leftNavItemValue
{
  return [self stringForNavItem:self.leftNavItem];
}

- (NSString *)description
{
  return SPXDescription(SPXKeyPath(dataProvider), SPXKeyPath(hidesTabBarOnPush), SPXKeyPath(leftNavItemValue), SPXKeyPath(rightNavItemValue), SPXKeyPath(presentationStyleValue), SPXKeyPath(navigationBarHidden), SPXKeyPath(toolBarHidden), SPXKeyPath(title), SPXKeyPath(supportedOrientationsValue), SPXKeyPath(supportsPullToRefresh), SPXKeyPath(prefersStatusBarHidden), SPXKeyPath(preferredStatusBarStyleValue));
}

@end

