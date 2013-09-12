//
//  AUAppDelegate.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-03.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUAppDelegate.h"

//#import "AUViewController.h"
#import "AULoginViewController.h"
#import "AUMoreViewController.h"
#import "AUAroundUViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>

NSString *const AUSessionStateChangedNotification = @"com.facebook.AroundU:AUSessionStateChangedNotification";

@interface AUAppDelegate ()

@property (nonatomic, strong) UITabBarController* tabController;
//@property (nonatomic,strong) UINavigationController* navController;
//@property (strong, nonatomic) AUViewController *mainViewController;

-(void)showLoginView;

@end

@implementation AUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //setting up parse backend stuff
    [Parse setApplicationId:@"x4Ujfl4EB5ryfZQcO2IRXS6yV0dpJTFZNV6Za7Ze"
                  clientKey:@"64e2DyQGTY5Vy8kp9Wzrif3jRuVePPjrGEglPtEG"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
/*
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[AUViewController alloc]initWithNibName:@"AUViewController" bundle:nil];
    self.navController = [[UINavigationController alloc]initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
*/    
    // See if the app has a valid token for the current state.
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)showLoginView
{
    /*UIViewController* topViewController = [self.navController topViewController];
    AULoginViewController* loginViewController = [[AULoginViewController alloc]initWithNibName:@"AULoginViewController" bundle:nil];
    [topViewController presentViewController:loginViewController animated:YES completion:nil];*/
    
    UIViewController *topViewController = [self.tabController selectedViewController];
    UIViewController *presentedViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![presentedViewController isKindOfClass:[AULoginViewController class]]) {
        AULoginViewController* loginViewController = [[AULoginViewController alloc] initWithNibName:@"AULoginViewController" bundle:nil];
        [topViewController presentViewController:loginViewController animated:YES completion:nil];
    } else {
        AULoginViewController* loginViewController = (AULoginViewController*)presentedViewController;
        [loginViewController loginFailed];
    }
    
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController = [self.tabController selectedViewController];
            if ([[topViewController presentedViewController] isKindOfClass:[AULoginViewController class]]) {
                [topViewController dismissViewControllerAnimated:YES completion:nil];
            }
            NSLog(@"successful login");
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //[self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AUSessionStateChangedNotification object:session];
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:@[@"user_education_history", @"friends_education_history"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url    
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
