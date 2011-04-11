//
//  mapViewViewController.h
//  mapView
//
//  Created by Boris Erceg on 11.04.2011..
//  Copyright 2011 PetMinuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "MyPlace.h"

@interface mapViewViewController : UIViewController {
    
    IBOutlet MKMapView *myMapView;
    NSArray *places;
    CLLocationDegrees zoomLevel;
    

}
-(void)loadDummyPlaces;
-(float)RandomFloatStart:(float)a end:(float)b;
-(void)filterAnnotations:(NSArray *)placesToFilter;
@end
