//
//  NewDataViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 1/1/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "JobModel.h"
#import "SalesModel.h"
#import <Parse/Parse.h>

@interface NewDataViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, JobModelProtocol, SalesModelProtocol>

@property (weak, nonatomic) NSString *leadNo;
@property (weak, nonatomic) NSString *active;
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
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *photo;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) UIPickerView *pickerView;

@end
