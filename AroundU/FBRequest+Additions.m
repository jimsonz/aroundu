//
//  FBRequest+Additions.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-04.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "FBRequest+Additions.h"

@implementation FBRequest (Additions)

+(NSArray*)getMyFriendsId
{
    __block NSMutableArray* friendIdArray = [[NSMutableArray alloc]init];
    if ([FBSession activeSession].isOpen) {
        [[FBRequest requestForMyFriends] startWithCompletionHandler:^(FBRequestConnection* connection,
                                                                      NSDictionary* result,
                                                                      NSError* error) {
            if (!error) {
                NSArray<FBGraphUser>* friends = [result objectForKey:@"data"];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    if (friend.id) {
                        [friendIdArray addObject:friend.id];
                    }
                }
            }
        }];
    }
    return friendIdArray;
}

@end
