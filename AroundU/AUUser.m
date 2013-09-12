//
//  AUFriend.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-04.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUUser.h"

@implementation AUUser

-(id)initUserWithId:(NSInteger)userId
{
    self = [super init];
    if (self) {
        _userId = userId;
    }
    return self;
}

@end
