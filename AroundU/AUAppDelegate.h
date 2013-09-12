//
//  AUAppDelegate.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-03.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AUViewController;

@interface AUAppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const AUSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;

- (void)openSession;

@end
