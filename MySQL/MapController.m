//
//  MapController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(MAPTITLE, nil);
    
    self.MapView.delegate = self;
    [self.MapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    self.MapView.showsUserLocation = YES;
    [self.MapView setZoomEnabled:YES];
    [self.MapView setScrollEnabled:YES];
    [self.MapView setRotateEnabled:YES];
    self.MapView.showsPointsOfInterest = YES;
    self.MapView.showsBuildings = YES;
    self.MapView.showsCompass = YES;
    self.MapView.showsScale = YES;
    self.MapView.camera.altitude = 200;
    self.MapView.camera.pitch = 70;
  //self.MapView.pitchEnabled = YES;
  //self.mapView.showsTraffic = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self gotoLocation];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor orangeColor];
    renderer.lineWidth = 6.0;
    return renderer;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
CLLocationCoordinate2D sanFrancisco = { 37.774929, -122.419416 };
CLLocationCoordinate2D newYork = { 40.714353, -74.005973 };
CLLocationCoordinate2D points[] = { sanFrancisco, newYork };

MKGeodesicPolyline *geodesic = [MKGeodesicPolyline polylineWithCoordinates:&points[0] count:2];

[self.MapView addOverlay:geodesic];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showdone:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SegmentedControl
- (IBAction)mapTypeChanged:(id)sender {
    
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 0) {
        self.MapView.mapType = MKMapTypeStandard;
    }
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 1) {
        self.MapView.mapType = MKMapTypeHybrid;
    }
    if (self.mapTypeSegmentedControl.selectedSegmentIndex == 2) {
        self.MapView.mapType = MKMapTypeSatellite;
    }
}

- (void)gotoLocation
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = NY_LATITUDE;
    newRegion.center.longitude = NY_LONGTITUDE;
    newRegion.span.latitudeDelta = 0.5f;
    newRegion.span.longitudeDelta = 0.5f;
    [self.MapView setRegion:newRegion animated:YES];
}

@end
