//
//  AUMapAnnotation.h
//  AroundU
//
//  Created by Peter Yeung on 2013-08-05.
//  Copyright (c) 2013 Peter Yeung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AUMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign)CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end
