//
//  AUFriend.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-04.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AUUser : NSObject

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,assign) CGFloat lon;
@property (nonatomic,assign) CGFloat lat;
@property (nonatomic,strong) NSString* username;
@property (nonatomic,assign) NSString *userEducation;
//@property (nonatomic,strong) NSURL* profileImageURL;

-(id)initUserWithId:(NSInteger)userId;

@end
