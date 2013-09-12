//
//  AUViewController.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-03.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AUViewController : UIViewController

@property (nonatomic,strong)IBOutlet UITableView* friendTableView;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;

@end
