//
//  MyPlace.m
//  mapView
//
//  Created by Boris Erceg on 11.04.2011..
//  Copyright 2011 PetMinuta. All rights reserved.
//

#import "MyPlace.h"


@implementation MyPlace


@synthesize coordinate;
@synthesize currentTitle;
@synthesize currentSubTitle;


- (NSString *)subtitle{
	return currentSubTitle;
}

- (NSString *)title{
	return currentTitle;
}
-(CLLocationCoordinate2D)getCoordinate{
    return coordinate;
}
-(void)setShow:(NSNumber *)show{
    show_on_map=[show boolValue];
}
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end
