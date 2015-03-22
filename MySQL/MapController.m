//
//  MapController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MapController.h"
#import "SWRevealViewController.h"



@interface MapController ()

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(MAPTITLE, nil);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
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
    [self.myMapView setRegion:newRegion animated:YES];
}

@end
