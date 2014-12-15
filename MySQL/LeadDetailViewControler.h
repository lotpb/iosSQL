//
//  LeadDetailViewControler.h
//  MySQL
//
//  Created by Peter Balsamo on 10/4/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "Location.h"
#import "MapViewController.h"
#import "WebViewController.h"

@interface LeadDetailViewControler : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *leadNo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *callback;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *zip;
@property (weak, nonatomic) IBOutlet UILabel *photo;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *first;
@property (weak, nonatomic) IBOutlet UITextField *spouse;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet UITextField *salesman;
@property (weak, nonatomic) IBOutlet UITextView *aptdate;
@property (weak, nonatomic) IBOutlet UITextField *jobNo;
@property (weak, nonatomic) IBOutlet UITextField *adNo;
@property (weak, nonatomic) IBOutlet UITextField *active;
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

//@property (weak, nonatomic) IBOutlet UIImageView *leadImageView;
@property (weak, nonatomic) IBOutlet UILabel *leadtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadreadmore;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView2;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
@property (weak, nonatomic) Location *selectedLocation;

@end
