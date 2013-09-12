//
//  AUParseWrapper.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-04.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUParseWrapper.h"
#import <Parse/Parse.h>

@implementation AUParseWrapper

+(void)saveCurrentUser:(AUUser*)user
{
    if ([self allowToSave]) {
        PFQuery* query = [PFQuery queryWithClassName:@"AUUser"];
        [query whereKey:@"userId" equalTo:[NSNumber numberWithInteger:user.userId]];
        [query findObjectsInBackgroundWithBlock:^(NSArray* results,
                                                  NSError* error) {
            PFObject* object = nil;
            if (results.count) {
                //there's result so let's update
                object = [results lastObject];
                [object setObject:user.lon ? [NSNumber numberWithFloat:user.lon] : [NSNull null] forKey:@"lon"];
                [object setObject:user.lat ? [NSNumber numberWithFloat:user.lat] : [NSNull null] forKey:@"lat"];
            }
            else {
                //no result so let's create a new object
                object = [PFObject objectWithClassName:@"AUUser"];
                [object setObject:[NSNumber numberWithInteger:user.userId] forKey:@"userId"];
                [object setObject:user.lon ? [NSNumber numberWithFloat:user.lon] : [NSNull null] forKey:@"lon"];
                [object setObject:user.lat ? [NSNumber numberWithFloat:user.lat] : [NSNull null] forKey:@"lat"];
                [object setObject:user.username ? user.username : [NSNull null] forKey:@"username"];
            }
            //let's save it back to Parse
            [object saveInBackgroundWithBlock:^(BOOL success,
                                                NSError* error) {
                
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (success) {
                    NSLog(@"My profile data is updated");
                    [self timeStampOnRequest];
                }
            }];
        }];
    }
}

+(void)getUserWithId:(NSInteger)userId withDelegate:(id<AUParseWrapperDelegate>)delegate
{
    __block AUUser* user = nil;
    
    PFQuery* query = [PFQuery queryWithClassName:@"AUUser"];
    [query whereKey:@"userId" equalTo:[NSNumber numberWithInteger:user.userId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray* results,
                                              NSError* error) {
        if (results.count) {
            PFObject* result = [results lastObject];
            user = [[AUUser alloc]initUserWithId:userId];
            user.lon = [(NSNumber*)[result objectForKey:@"lon"] integerValue];
            user.lat = [(NSNumber*)[result objectForKey:@"lat"] integerValue];
            user.username = [result objectForKey:@"username"];
            //user.profileImageURL = [result objectForKey:@"profileImageURL"];
            
            [delegate userWithIdRecieved:user];
        }
    }];
}

+(void)getAllFriendsInArray:(NSArray*)friendIdArray withDelegate:(id<AUParseWrapperDelegate>)delegate
{
    __block NSMutableArray* friends = [[NSMutableArray alloc]init];
    
    PFQuery* query = [PFQuery queryWithClassName:@"AUUser"];
    [query whereKey:@"userId" containedIn:friendIdArray];
    [query findObjectsInBackgroundWithBlock:^(NSArray* results,
                                              NSError* error) {
        for (PFObject* result in results) {
            PFObject* result = [results lastObject];
            AUUser* user = [[AUUser alloc]initUserWithId:[[result objectForKey:@"userId"] integerValue]];
            user.lon = [(NSNumber*)[result objectForKey:@"lon"] integerValue];
            user.lat = [(NSNumber*)[result objectForKey:@"lat"] integerValue];
            user.username = [result objectForKey:@"username"];
            //user.profileImageURL = [result objectForKey:@"profileImageURL"];
            [friends addObject:user];
        }
        [delegate allFriendsResultsRecieved:friends];
    }];
}

+(BOOL)allowToSave
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate* lastRequestDate = [userDefaults objectForKey:@"UserUpdateTimeStamp"];
    if (lastRequestDate == nil) {
        //always allow to send request on first time
        return YES;
    }
    if ([[NSDate date]timeIntervalSinceDate:lastRequestDate] > 10) {
        return YES;
    }
    else {
        return NO;
    }
}

+(void)timeStampOnRequest
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSDate date] forKey:@"UserUpdateTimeStamp"];
    [userDefaults synchronize]; 
}

@end
