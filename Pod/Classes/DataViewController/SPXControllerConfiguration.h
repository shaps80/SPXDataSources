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

@import UIKit;
#import "SPXDataSources.h"


/**
 *  Defines the available presentation style
 */
typedef NS_ENUM(NSInteger, SPXControllerPresentationStyle){
  /**
   *  Specifies that the most appropriate presentation style should be used. If presented from a navigationController, a push will occur, otherwise a modal presentation will be used
   */
  SPXControllerPresentationStyleDefault,
  /**
   *  Specifies the controller should be pushed onto the navigation stack
   */
  SPXControllerPresentationStylePush,
  /**
   *  Specifies the controller should be pushed onto the navigation stack and automatically dismissed on selection
   */
  SPXControllerPresentationStylePushPopOnSelection,
  /**
   *  Specifies the controller should be presented modally
   */
  SPXControllerPresentationStyleModal,
  /**
   *  Specifies the controller should be presented modally and automatically dismissed on selection
   */
  SPXControllerPresentationStyleModalDismissOnSelection,
};


/**
 *  Defines the available nav bar items
 */
typedef NS_ENUM(NSInteger, SPXControllerNavItem){
  /**
   *  Specifies no nav item
   */
  SPXControllerNavItemNone,
  /**
   *  Specifies a Done button for the nav item
   */
  SPXControllerNavItemDone,
  /**
   *  Specifies a Cancel button for the nav item
   */
  SPXControllerNavItemCancel,
  /**
   *  Specifies an Add button for the nav item
   */
  SPXControllerNavItemAdd,
};


/**
 *  Defines an SPXDataViewController configuration
 */
@interface SPXControllerConfiguration : NSObject <NSCopying>


/**
 *  Get/set the title for this controller
 */
@property (nonatomic, strong) NSString *title;


/**
 *  Get/set the <SPXDataProvider> for this controller
 */
@property (nonatomic, strong) id <SPXDataProvider> dataProvider;


/**
 *  Get/set the presentation style for this controller
 */
@property (nonatomic, assign) SPXControllerPresentationStyle presentationStyle;


/**
 *  Get/set the left nav item for this controller
 */
@property (nonatomic, assign) SPXControllerNavItem leftNavItem;


/**
 *  Get/set the right nav item for this controller
 */
@property (nonatomic, assign) SPXControllerNavItem rightNavItem;


/**
 *  Get/set the supported interface orientations for this controller
 */
@property (nonatomic, assign) UIInterfaceOrientationMask supportedInterfaceOrientations;


/**
 *  Get/set the preferred interface orientations for this controller when presented
 */
@property (nonatomic, assign) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;


/**
 *  Get/set the preferred status bar style for this controller
 */
@property (nonatomic, assign) UIStatusBarStyle preferredStatusBarStyle;


/**
 *  Get/set whether or not the status bar is hidden
 */
@property (nonatomic, assign) BOOL prefersStatusBarHidden;


/**
 *  Get/set whether or not the navigation bar is hidden
 */
@property (nonatomic, assign) BOOL navigationBarHidden;


/**
 *  Get/set whether or not the toolbar is hidden
 */
@property (nonatomic, assign) BOOL toolBarHidden;


/**
 *  Get/set whether or not the tab bar should be hidden no push
 */
@property (nonatomic, assign) BOOL hidesTabBarOnPush;


/**
 *  Get/set whether or not the controller supports Pull to Refresh
 */
@property (nonatomic, assign) BOOL supportsPullToRefresh;


@end


