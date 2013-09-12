//
//  AUAroundUViewController.h
//  AroundU
//
//  Created by Jimson Zhang on 8/5/13.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "AUParseWrapper.h"
#import <MapKit/MapKit.h>

@interface AUAroundUViewController : UIViewController<CLLocationManagerDelegate,AUParseWrapperDelegate,MKMapViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)IBOutlet UITableView* friendTableView;
@property (strong, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (strong, nonatomic) IBOutlet MKMapView* mapView;
@property (nonatomic, retain) CLLocation *myLocation;
@property (nonatomic, retain) NSString *myName;

@end
