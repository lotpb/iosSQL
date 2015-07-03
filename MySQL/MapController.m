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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showdone:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
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
