//
//  EmployeeDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"
#import "EmployeeLocation.h"
#import "EmployeeViewController.h"
#import "MapViewController.h"

@interface EmployeeDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *employeeNo;
@property (weak, nonatomic) IBOutlet NSString *first;
@property (weak, nonatomic) IBOutlet NSString *middle;
@property (weak, nonatomic) IBOutlet UILabel *lastname;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *street;
@property (weak, nonatomic) IBOutlet NSString *state;
@property (weak, nonatomic) IBOutlet NSString *zip;
@property (weak, nonatomic) IBOutlet NSString *phone;
@property (weak, nonatomic) IBOutlet NSString *homephone;
@property (weak, nonatomic) IBOutlet NSString *workphone;
@property (weak, nonatomic) IBOutlet NSString *cellphone;
@property (weak, nonatomic) IBOutlet NSString *email;
@property (weak, nonatomic) IBOutlet NSString *company;
@property (weak, nonatomic) IBOutlet NSString *social;
@property (weak, nonatomic) IBOutlet NSString *country;
@property (weak, nonatomic) IBOutlet NSString *titleEmploy;
@property (weak, nonatomic) IBOutlet UILabel *manager;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UILabel *active;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

//@property (weak, nonatomic) IBOutlet UIImageView *employImageView;
@property (weak, nonatomic) IBOutlet UILabel *employtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *employsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *employreadmore;
@property (weak, nonatomic) IBOutlet UILabel *employnews;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView2;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
@property (weak, nonatomic) EmployeeLocation *selectedLocation;

@end
