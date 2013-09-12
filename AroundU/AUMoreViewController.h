//
//  AUMoreViewController.h
//  AroundU
//
//  Created by Jimson Zhang on 8/5/13.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AUParseWrapper.h"

@interface AUMoreViewController : UIViewController<CLLocationManagerDelegate>

- (IBAction)logoutButtonWasPressed:(id)sender;

@end
