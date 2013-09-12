//
//  AUMoreViewController.m
//  AroundU
//
//  Created by Jimson Zhang on 8/5/13.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUMoreViewController.h"
#import "AUAroundUViewController.h"
#import "AUAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <CoreLocation/CoreLocation.h>

@interface AUMoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet FBProfilePictureView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLocationLabel;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation AUMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:AUSessionStateChangedNotification
                                               object:nil];
 
    [self updateMyLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (FBSession.activeSession.isOpen) {
        [self populateUserDetails];
    }
}

- (IBAction)logoutButtonWasPressed:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id result,
                                                               NSError *error) {
            if (!error) {
                NSDictionary *userData = (NSDictionary *)result;
                self.userNameLabel.text = userData[@"name"];
                self.userProfileImage.profileID = userData[@"id"];
            }
        }];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    //
    //[self getFriends];
    [self populateUserDetails];
    [self saveCurrentUserInfo];
}

- (void)updateMyLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

- (void)saveCurrentUserInfo
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id result,
                                                               NSError *error) {
            AUUser* currentUser;
            if (!error) {
                NSDictionary *userData = (NSDictionary *)result;
                currentUser = [[AUUser alloc]initUserWithId:[userData[@"id"] integerValue]];
                currentUser.username = userData[@"name"];
            }
            [AUParseWrapper saveCurrentUser:currentUser];
        }];
    }
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
    self.myLocationLabel.text = [NSString stringWithFormat:@"Lon %0.2f Lat %0.2f",location.coordinate.longitude,location.coordinate.latitude];
    
    //save locaiton to parse
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id result,
                                                               NSError *error) {
            AUUser* currentUser;
            NSDictionary *userData = (NSDictionary *)result;
            if (!error) {
                currentUser = [[AUUser alloc]initUserWithId:[userData[@"id"] integerValue]];
                currentUser.lon = location.coordinate.longitude;
                currentUser.lat = location.coordinate.latitude;
            }
            [AUParseWrapper saveCurrentUser:currentUser];
            
//            NSArray *userSchool = userData[@"education"];
//            NSLog(@"%@",userData);
        }];
    }
    
}

@end
