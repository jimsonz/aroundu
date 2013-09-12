//
//  AUAroundUViewController.m
//  AroundU
//
//  Created by Jimson Zhang on 8/5/13.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUAroundUViewController.h"
#import "AUAppDelegate.h"
#import "AUMoreViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FacebookSDK/FBGraphUser.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "AUMapAnnotation.h"

@interface AUAroundUViewController () <UITableViewDataSource,UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *myLocationLabel;
@property (strong, nonatomic) NSMutableArray* peopleAroundArray;
@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation AUAroundUViewController

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Filter"
                                              style:UIBarButtonItemStyleBordered
                                              target:self
                                              action:@selector(showFilterOptions:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Refresh"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(refresh:)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:AUSessionStateChangedNotification
                                               object:nil];
    self.peopleAroundArray = [[NSMutableArray alloc]init];
    [self updateMyLocation];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.title = @"Friends Near By";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMyLocation
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)refresh:(id)sender {
    [self getFriends];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(self.myLocation.coordinate.latitude, self.myLocation.coordinate.longitude);
    
    AUMapAnnotation* annotation = [[AUMapAnnotation alloc]initWithTitle:@"Jimson Zhang" andCoordinate:location];
    [self.mapView addAnnotation:annotation];
    
    [self setMapZoomLevelForUser:location atLevelLat:50 atLevelLon:50];
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    //
    [self getFriends];
    //[self populateUserDetails];
    //[self saveCurrentUserInfo];
}

- (void)showFilterOptions:(id)sender
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc]initWithTitle:@"Filter"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Male"
                                                  otherButtonTitles:@"Female", @"Custom", nil];
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
    //[popupQuery ];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            // show male peopleArray only
            break;
        case 1:
            //show female peopleArray only
            break;
        case 2:
            //show custom peopleArray only
            break;
        case 3:
            //cancel
            break;
    }
}

- (void)getFriends
{
    if ([FBSession activeSession].isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection* connection,
                                                                      NSDictionary* result,
                                                                      NSError* error) {
            if (!error) {
                NSArray<FBGraphUser>* friends = [result objectForKey:@"data"];
                NSMutableArray* friendsId = [[NSMutableArray alloc]init];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    [friendsId addObject:[NSNumber numberWithInteger:[friend.id integerValue]]];
                }
                [AUParseWrapper getAllFriendsInArray:friendsId withDelegate:self];
            }
        }];
    }
}

- (NSString *)getMatchedEducation
{
    __block NSString *matchedSchool = @"";
    NSMutableArray *schoolName = [[NSMutableArray alloc]init];
    if ([FBSession activeSession].isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id result,
                                                               NSError *error) {
            NSDictionary *userData = (NSDictionary *)result;
            NSArray *userSchool = userData[@"education"];
            for (int i = 0; i < [userSchool count]; i++) {
                schoolName[i] = userSchool[i];
            }
            //matchedSchool = @"Peter went to Univeristy of Brithis Columbia with you.";
        }];
    }
    return matchedSchool;
}

-(void)showMapAnnotation
{
    /*
    // set pin for current user 
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_myLocation.coordinate.latitude, _myLocation.coordinate.longitude);
    AUMapAnnotation* annotation = [[AUMapAnnotation alloc]initWithTitle:_myName andCoordinate:location];
    [self.mapView addAnnotation:annotation];
    */
    for (int i=0;i<self.peopleAroundArray.count;i++) {
        AUUser* user = [self.peopleAroundArray objectAtIndex:i];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(user.lat, user.lon);
        AUMapAnnotation* annotation = [[AUMapAnnotation alloc]initWithTitle:user.username andCoordinate:location];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)setMapZoomLevelForUser:(CLLocationCoordinate2D)userLocation atLevelLat:(float)lat atLevelLon:(float)lon
{
    MKCoordinateRegion region;
    region = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(userLocation, 800, 800)];;
    
    MKCoordinateSpan span;
    span.latitudeDelta = lat;
    span.longitudeDelta = lon;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Tableview Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StrangerCell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    AUUser* user = (AUUser*)[self.peopleAroundArray objectAtIndex:indexPath.row];
    
    //calculate distance between user and friend
    CLLocationDistance distance;
    CLLocation *friendLocation = [[CLLocation alloc] initWithLatitude:user.lat longitude:user.lon];
    
    distance = [self.myLocation distanceFromLocation:friendLocation];
    
    UILabel *strangerNameLabel = (UILabel *)[cell viewWithTag:100];
    strangerNameLabel.text = user.username;
    UILabel *strangerLocationLabel = (UILabel *)[cell viewWithTag:101];
    strangerLocationLabel.text = [NSString stringWithFormat:@"lon: %0.2f lat: %0.2f",user.lon,user.lat];
    UILabel *strangerDistanceLabel = (UILabel *)[cell viewWithTag:102];
    strangerDistanceLabel.text = [NSString stringWithFormat:@"%0.2f kms", distance/1000];
    FBProfilePictureView *strangerProfileImage = (FBProfilePictureView *)[cell viewWithTag:103];
    strangerProfileImage.profileID = [NSString stringWithFormat:@"%d",user.userId];
    UILabel *commonBGLabel = (UILabel *)[cell viewWithTag:104];
    commonBGLabel.text = [NSString stringWithFormat:@"%@ went to UBC with you!", user.username];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //specify number of rows in a table since we only have 1 section so we don't need to specify that
    return self.peopleAroundArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //specify how many sections there are
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AUUser* user = (AUUser*)[self.peopleAroundArray objectAtIndex:indexPath.row];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(user.lat, user.lon);
    
    [self setMapZoomLevelForUser:location atLevelLat:5 atLevelLon:5];
}

#pragma mark - CLLocationManager Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //this is your location
    CLLocation* location = [locations lastObject];
    self.myLocation = location;
}

#pragma mark - AUParseDelegate

-(void)userWithIdRecieved:(AUUser *)user
{
    NSLog(@"user with id delegate recieved %@",user.username);
}

-(void)allFriendsResultsRecieved:(NSArray *)friendArray
{
    [self.peopleAroundArray removeAllObjects];
    [self.peopleAroundArray addObjectsFromArray:friendArray];
    [self.friendTableView reloadData];
    [self showMapAnnotation];
}

@end
