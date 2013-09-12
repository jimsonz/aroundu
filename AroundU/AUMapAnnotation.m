//
//  AUMapAnnotation.m
//  AroundU
//
//  Created by Peter Yeung on 2013-08-05.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import "AUMapAnnotation.h"

@implementation AUMapAnnotation

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	self = [super init];
    if (self) {
        _title = ttl;
        _coordinate = c2d;
    }
	
	return self;
}

@end
