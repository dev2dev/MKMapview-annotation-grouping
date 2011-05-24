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
    if ([places count]==1) {
        return currentSubTitle;
    }
    else{
        return @"";
    }
}

- (NSString *)title{
    
    if ([places count]==1) {
        return currentTitle;
    }
    else{
        return [NSString stringWithFormat:@"%d places", [places count]];
    }
}
-(void)addPlace:(MyPlace *)place{
    [places addObject:places];
}
-(CLLocationCoordinate2D)getCoordinate{
    return coordinate;
}
-(void)cleanPlaces{

    [places removeAllObjects];
    [places addObject:self];
}
-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
    places=[[NSMutableArray alloc] initWithCapacity:0];
	return self;
}
-(int)placesCount{
    return [places count];
}

@end
