//
//  AUParseWrapper.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-04.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AUUser.h"

@protocol AUParseWrapperDelegate <NSObject>

-(void)userWithIdRecieved:(AUUser*)user;
-(void)allFriendsResultsRecieved:(NSArray*)friendArray;

@end

@interface AUParseWrapper : NSObject

+(void)saveCurrentUser:(AUUser*)user;
+(void)getUserWithId:(NSInteger)userId withDelegate:(id<AUParseWrapperDelegate>)delegate;
+(void)getAllFriendsInArray:(NSArray*)friendIdArray withDelegate:(id<AUParseWrapperDelegate>)delegate;
+(BOOL)allowToSave;
+(void)timeStampOnRequest;

@end
