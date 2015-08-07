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
//@property (nonatomic, strong) NSMutableArray *locations;
@end

@implementation MapViewController
{
    UIBarButtonItem *shareItem;
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
    self.mapView.camera.altitude = 200;
    self.mapView.camera.pitch = 70;
  //self.mapView.pitchEnabled = YES; // 3d dont work
  //self.mapView.showsTraffic = YES;
    
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    //[self startLocationUpdates];
    
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
                         
                        //[NSString stringWithFormat:@"%@ %@ %@ %@", topResult.country, topResult.locality, topResult.subLocality, topResult.thoroughfare];
                         
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         MKCoordinateRegion region = self.mapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 8.0; //1500.0;
                         region.span.latitudeDelta /= 8.0; //1500.0;
                         region = [self.mapView regionThatFits:region];
                         [self.mapView setRegion:region animated:YES];
                         [self.mapView addAnnotation:annotation];
                     }
                 }
     ];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Annotation
// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([mp coordinate], 1500, 1500); //MKCoordinateRegionForMapRect(MKMapRectWorld);
    //region.span.longitudeDelta = 0.005f;
    //region.span.longitudeDelta = 0.005f;
    [mv setRegion:region animated:NO];
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

#pragma mark - CLLocationManagerDelegate
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

// CLLocationManager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:
(NSArray *)locations
{
    NSLog(@"location info object=%@", [locations lastObject]);
    /*
    for (CLLocation *newLocation in locations) {
        
        NSDate *eventDate = newLocation.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        
        if (fabs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
            
            // update distance
            if (self.locations.count > 0) {
              //  self.distance += [newLocation distanceFromLocation:self.locations.lastObject];
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:newLocation];
        }
    } */
}

#pragma mark - Location Authorized Crap

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
        
        //MKAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:nil];
        UIImage *image = snapshot.image;
        //NSData *data = UIImagePNGRepresentation(image);
        //[data writeToFile:[self snapshotFilename] atomically:YES];
        NSString *message;
        message = [NSString stringWithFormat:@"%@ %@ %@ %@", self.mapaddress, self.mapcity, self.mapstate, self.mapzip];
        NSArray * shareItems = @[message, image];
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        avc.modalInPopover = UIModalTransitionStyleCoverVertical;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            avc.popoverPresentationController.barButtonItem = shareItem;
            avc.popoverPresentationController.sourceView = self.view;
        }
        
        [self presentViewController:avc animated:YES completion:nil];
    }];
}

@end
