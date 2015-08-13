//
//  MapViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 9/30/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
//@property (nonatomic, strong) MKCircle *circleOverlay;

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay;
//@property (nonatomic, strong) NSMutableArray *locations;
@end

@implementation MapViewController
{
    UIBarButtonItem *shareItem;
    //MKPlacemark *placemark;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
     self.mapView.showsUserLocation = YES;
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setRotateEnabled:YES];
     self.mapView.showsPointsOfInterest = YES;
     self.mapView.showsBuildings = YES;
     self.mapView.showsCompass = YES;
     self.mapView.showsScale = YES;
   //self.mapView.showsTraffic = YES;
   //self.mapView.camera.altitude = 200;
   //self.mapView.camera.pitch = 70;
   //self.mapView.pitchEnabled = YES; // 3d dont work
    self.routView.hidden = false;
    
    //if (self.routView.hidden) {
        //self.mapView.frame = self.view.bounds;
        //self.mapView.autoresizingMask = self.view.autoresizingMask;
   // }
    
    [self.travelTime setTextColor:BLUECOLOR];
    [self.travelDistance setTextColor:BLUECOLOR];
    self.steps.font = [UIFont systemFontOfSize:IPHONEFONT16];
    
    self.allSteps = @"";
    self.travelTime.text = @"";
    self.travelDistance.text = @"";
    [self.travelTime sizeToFit];
    [self.travelDistance sizeToFit];
    
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [self startLocationUpdates];
    
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
  //  self.mapView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
   
    NSString *location = [NSString stringWithFormat:@"%@ %@ %@ %@", self.mapaddress, self.mapcity, self.mapstate, self.mapzip];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         
                         MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                         annotation.coordinate = topResult.location.coordinate;
                         annotation.title = self.mapaddress;
                         annotation.subtitle = [NSString stringWithFormat:@"%@ %@ %@", self.mapcity, self.mapstate, self.mapzip];
                        
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];

                         [self.mapView addAnnotation:annotation];

 //-------------------------------Directions below------------------------------
                         
                         CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake(self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude);
                         MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
                         MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];

                         // Make the destination location
                         CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                         MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
                         MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
                         
                         MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
                         [directionsRequest setSource:source];
                         [directionsRequest setDestination:destination];
                          directionsRequest.transportType = MKDirectionsTransportTypeAutomobile;

                         MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
                         [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                             if (error) {
                                 return;
                             }
                             // So there wasn't an error - let's plot those routes
                             MKRoute *route = [response.routes lastObject];
                             [self.mapView setVisibleMapRect:route.polyline.boundingMapRect animated:NO];
                             //[self.mapView addOverlay:route.polyline];
                             [self showRoute:response];
                         }];
                         
                     }
                 }
     ];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
  /*
    MKMapRect newDisplayRect;
    [_mapView setVisibleMapRect:newDisplayRect animated:YES];
    
    [_mapView setVisibleMapRect:newDisplayRect edgePadding:UIEdgeInsetsMake(0, 0, 10, 10) animated:YES];
    
    //_mapView.showsUserLocation = YES; */
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        self.travelTime.text = [NSString stringWithFormat:@"Time %0.1f minutes" ,route.expectedTravelTime/60];
        self.travelDistance.text = [NSString stringWithFormat:@"Distance %0.1f Miles" ,route.distance/1609.344];
        
        for (int i = 0; i < route.steps.count; i++) {
            MKRouteStep *step = [route.steps objectAtIndex:i];
            NSString *newStep = step.instructions;
            NSString *distStep = [NSString stringWithFormat:@"%0.2f Miles" ,step.distance/1609.344];
            self.allSteps = [self.allSteps stringByAppendingString:newStep];
            self.allSteps = [self.allSteps stringByAppendingString:@"\n"];
            self.allSteps = [self.allSteps stringByAppendingString:distStep];
            self.allSteps = [self.allSteps stringByAppendingString:@"\n\n"];
            self.steps.text = self.allSteps;
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}
//----------------------------directions end-------------------------------------

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
   /* //green pins
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    [annView setSelected:YES];
    annView.pinColor = MKPinAnnotationColorGreen;
    annView.calloutOffset = CGPointMake(15, 15);
    return annView; */
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"MyPin"];
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPin"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
} 

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    [mv selectAnnotation:mp animated:YES];
}

#pragma mark - SegmentedControl
- (IBAction)mapTypeChanged:(id)sender {
    
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 0) {
        self.mapView.mapType = MKMapTypeStandard;
    }
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 1) {
        self.mapView.mapType = MKMapTypeHybrid;
    }
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 2) {
        self.mapView.mapType = MKMapTypeSatellite;
    }
}

#pragma mark - Location Authorized Crap
#pragma mark  CLLocationManagerDelegate
- (void)startLocationUpdates {
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //self.locationManager.activityType = CLActivityTypeFitness;
    //self.locationManager.distanceFilter = 10; // meters
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *)locations
{
    // Turn off the location manager to save power.
    [manager stopUpdatingLocation];
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    // Check authorization status (with class method)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // User has never been asked to decide on location authorization
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Requesting when in use auth");
        [self.locationManager requestWhenInUseAuthorization];
    }
    // User has denied location use (either for this app or for all apps
    else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"Location services denied");
        // Alert the user and send them to the settings to turn on location
    }
}

- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

#pragma mark - BarButton
- (void)share:(id)sender {
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = self.mapView.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        if (error) {
            NSLog(@"[Error] %@", error);
            return;
        }
        
        MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
        
        UIImage *image = snapshot.image;
        UIGraphicsBeginImageContextWithOptions(image.size, YES, image.scale);
        {
            [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
            
            CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
            for (id <MKAnnotation> annotation in self.mapView.annotations) {
                CGPoint point = [snapshot pointForCoordinate:annotation.coordinate];
                if (CGRectContainsPoint(rect, point)) {
                    point.x = point.x + pin.centerOffset.x -
                    (pin.bounds.size.width / 2.0f);
                    point.y = point.y + pin.centerOffset.y -
                    (pin.bounds.size.height / 2.0f);
                    [pin.image drawAtPoint:point];
                }
            }
            
            UIImage *compositeImage = UIGraphicsGetImageFromCurrentImageContext();
            NSString *message;
            message = [NSString stringWithFormat:@"%@ %@ %@ %@", self.mapaddress, self.mapcity, self.mapstate, self.mapzip];
            NSArray * shareItems = @[message, compositeImage];
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            avc.modalInPopover = UIModalTransitionStyleCoverVertical;
            
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                avc.popoverPresentationController.barButtonItem = shareItem;
                avc.popoverPresentationController.sourceView = self.view;
            }
                  [self presentViewController:avc animated:YES completion:nil];
        }
        UIGraphicsEndImageContext();
    }];
}

@end
