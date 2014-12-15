//
//  VendorDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/28/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorModel.h"
#import "VendLocation.h"
#import "VendorViewController.h"
#import "MapViewController.h"

@interface VendorDetailController : UIViewController

@property (weak, nonatomic) IBOutlet NSString *state;
@property (weak, nonatomic) IBOutlet NSString *zip;
@property (weak, nonatomic) IBOutlet NSString *email;
@property (weak, nonatomic) IBOutlet NSString *department;
@property (weak, nonatomic) IBOutlet NSString *office;
@property (weak, nonatomic) IBOutlet NSString *manager;
@property (weak, nonatomic) IBOutlet NSString *profession;
@property (weak, nonatomic) IBOutlet NSString *assistant;
@property (weak, nonatomic) IBOutlet NSString *phone;
@property (weak, nonatomic) IBOutlet NSString *phone1;
@property (weak, nonatomic) IBOutlet NSString *phone2;
@property (weak, nonatomic) IBOutlet NSString *phone3;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UILabel *vendorNo;
@property (weak, nonatomic) IBOutlet UILabel *vendorName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *webpage;
@property (weak, nonatomic) IBOutlet UILabel *active;

@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *professionlabel;

//@property (weak, nonatomic) IBOutlet UIImageView *vendImageView;
@property (weak, nonatomic) IBOutlet UILabel *vendtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendreadmore;
@property (weak, nonatomic) IBOutlet UILabel *vendnews;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView2;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
@property (weak, nonatomic) VendLocation *selectedLocation;

@end
