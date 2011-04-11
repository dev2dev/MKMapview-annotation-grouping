//
//  mapViewViewController.m
//  mapView
//
//  Created by Boris Erceg on 11.04.2011..
//  Copyright 2011 PetMinuta. All rights reserved.
//

#import "mapViewViewController.h"

//mapview starting points
#define kCenterPointLatitude  44.691058
#define kCenterPointLongitude 16.382895
#define kSpanDeltaLatitude    5.263112
#define kSpanDeltaLongitude   5.697419

#define iphoneScaleFactorLatitude   9.0    
#define iphoneScaleFactorLongitude  11.0  

@implementation mapViewViewController

- (void)dealloc
{
    [myMapView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


-(void)loadDummyPlaces{
    srand((unsigned)time(0));
    
    NSMutableArray *tempPlaces=[[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<1000; i++) {
        
        MyPlace *place=[[MyPlace alloc] initWithCoordinate:CLLocationCoordinate2DMake([self RandomFloatStart:42.0 end:47.0],[self RandomFloatStart:14.0 end:19.0])];
        [place setCurrentTitle:[NSString stringWithFormat:@"Place %d title",i]];
        [place setCurrentSubTitle:[NSString stringWithFormat:@"Place %d subtitle",i]];
        [place setShow:[NSNumber numberWithBool:TRUE]];
            
        [tempPlaces addObject:place];
        [place release];
    
    }
    places=[[NSArray alloc] initWithArray:tempPlaces];
    
    [tempPlaces release];
}

-(float)RandomFloatStart:(float)a end:(float)b {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self loadDummyPlaces];
    
    CLLocationCoordinate2D centerPoint = {kCenterPointLatitude, kCenterPointLongitude};
	MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(kSpanDeltaLatitude, kSpanDeltaLongitude);
	MKCoordinateRegion coordinateRegion = MKCoordinateRegionMake(centerPoint, coordinateSpan);
    
	[myMapView setRegion:coordinateRegion];
	[myMapView regionThatFits:coordinateRegion];
    [self filterAnnotations:places];
    
    [super viewDidLoad];
}


#pragma mark - mapView



- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation{
	
	
	MKAnnotationView *annotationView = nil;
	
	static NSString *StartPinIdentifier = @"PinIdentifier";
	MKPinAnnotationView *startPin = (id)[mV dequeueReusableAnnotationViewWithIdentifier:StartPinIdentifier];
	if ([annotation isKindOfClass:[MKUserLocation class]]){
		startPin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StartPinIdentifier] autorelease];
        startPin.pinColor = MKPinAnnotationColorGreen;
        startPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        startPin.canShowCallout = YES;
        startPin.enabled = YES;
	}
	else{
		if (startPin == nil) {
            startPin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StartPinIdentifier] autorelease];
            startPin.animatesDrop = NO;
            startPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];            
            startPin.canShowCallout = YES;
            startPin.pinColor = MKPinAnnotationColorRed;
            startPin.enabled = YES;
        }
	}
    annotationView = startPin;
	return annotationView;
}




-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (zoomLevel!=mapView.region.span.longitudeDelta) {     
        [self filterAnnotations:places];
        zoomLevel=mapView.region.span.longitudeDelta;
    }
}




-(void)filterAnnotations:(NSArray *)placesToFilter{
    float latDelta=myMapView.region.span.latitudeDelta/iphoneScaleFactorLatitude;
    float longDelta=myMapView.region.span.longitudeDelta/iphoneScaleFactorLongitude;
    
    NSMutableArray *shopsToShow=[[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i=0; i<[placesToFilter count]; i++) {
        MyPlace *checkingLocation=[placesToFilter objectAtIndex:i];
        CLLocationDegrees latitude = [checkingLocation getCoordinate].latitude;
        CLLocationDegrees longitude = [checkingLocation getCoordinate].longitude;

        bool found=FALSE;
        for (MyPlace *tempPlacemark in shopsToShow) {
            if(fabs([tempPlacemark getCoordinate].latitude-latitude) < latDelta && fabs([tempPlacemark getCoordinate].longitude-longitude)<longDelta ){
                [myMapView removeAnnotation:checkingLocation];
                found=TRUE;
                break;
            }
        }
        if (!found) {
            [shopsToShow addObject:checkingLocation];
            [myMapView addAnnotation:checkingLocation];
        }
        
    }
    [shopsToShow release];
}


- (void)viewDidUnload
{
    
    [myMapView release];
    myMapView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
