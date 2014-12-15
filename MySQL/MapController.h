//
//  MapController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
