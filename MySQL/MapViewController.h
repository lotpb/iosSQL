//
//  MapViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 9/30/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LeadDetailViewControler.h"
#import "VendorDetailController.h"
#import "EmployeeDetailController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate,  CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (strong, nonatomic) NSString *mapaddress;
@property (strong, nonatomic) NSString *mapcity;
@property (strong, nonatomic) NSString *mapstate;
@property (strong, nonatomic) NSString *mapzip;
@property (weak, nonatomic) IBOutlet UILabel *travelTime;
@property (weak, nonatomic) IBOutlet UILabel *travelDistance;
@property (weak, nonatomic) IBOutlet UITextView *steps;
@property (strong, nonatomic) NSString *allSteps;
@property (weak, nonatomic) IBOutlet UIView *routeView;
@property (weak, nonatomic) IBOutlet UIButton *clearRoute;

@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegmentedControl;

- (IBAction)mapTypeChanged:(id)sender;

@end
