//
//  NewDataViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 1/1/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JobModel.h"
#import <Parse/Parse.h>
//#import "AddData.h"
//#import "HomeModel.h"

@interface NewDataViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, JobModelProtocol>

//@property (weak, nonatomic) NSString *leadNo;
@property (weak, nonatomic) NSString *active;
@property (weak, nonatomic) NSString *leadNo;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UITextField *first;
@property (weak, nonatomic) IBOutlet UITextField *last;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *zip;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *aptDate;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *spouse;
@property (weak, nonatomic) IBOutlet UITextField *callback;
@property (weak, nonatomic) IBOutlet UITextField *saleNo;
@property (weak, nonatomic) IBOutlet UITextField *jobNo;
@property (weak, nonatomic) IBOutlet UITextField *adNo;
@property (weak, nonatomic) IBOutlet UITextView *comment;

@property (strong, nonatomic) NSString *tfi11;
@property (strong, nonatomic) NSString *tla12;
@property (strong, nonatomic) NSString *tad13;
@property (strong, nonatomic) NSString *tci14;
@property (strong, nonatomic) NSString *tst15;

@property (strong, nonatomic) NSString *tzi21;
@property (strong, nonatomic) NSString *tph22;
@property (strong, nonatomic) NSString *tem23;
@property (strong, nonatomic) NSString *tam24;
@property (strong, nonatomic) NSString *tsp25;
@property (strong, nonatomic) NSString *tsa21;
@property (strong, nonatomic) NSString *tjo22;
@property (strong, nonatomic) NSString *tco23;
@property (strong, nonatomic) NSString *tph24;

@property (weak, nonatomic) NSString *time;
@property (weak, nonatomic) IBOutlet UITextField *photo;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) UIPickerView *pickerView;

@end
