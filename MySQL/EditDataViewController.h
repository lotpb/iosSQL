//
//  EditDataViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 1/10/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LeadDetailViewControler.h"
#import "LookupCity.h"
#import "LookupJob.h"
#import "LookupProduct.h"

@interface EditDataViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *formController;
@property (strong, nonatomic) NSString *custNo;
@property (strong, nonatomic) NSString *leadNo;
@property (weak, nonatomic) IBOutlet UITextField *active;
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
@property (weak, nonatomic) IBOutlet UITextField *salesman;
@property (weak, nonatomic) IBOutlet UITextField *jobNo;
@property (weak, nonatomic) IBOutlet UITextField *jobName;
@property (weak, nonatomic) IBOutlet UITextField *adNo;
@property (weak, nonatomic) IBOutlet UITextField *adName;
@property (weak, nonatomic) IBOutlet UITextView *comment;

@property (strong, nonatomic) NSString *frm11;
@property (strong, nonatomic) NSString *frm12;
@property (strong, nonatomic) NSString *frm13;
@property (strong, nonatomic) NSString *frm14;
@property (strong, nonatomic) NSString *frm15;
@property (strong, nonatomic) NSString *frm16;
@property (strong, nonatomic) NSString *frm17;
@property (strong, nonatomic) NSString *frm18;
@property (strong, nonatomic) NSString *frm19;
@property (strong, nonatomic) NSString *frm20;
@property (strong, nonatomic) NSString *frm21;
@property (strong, nonatomic) NSString *frm22;
@property (strong, nonatomic) NSString *frm23;
@property (strong, nonatomic) NSString *frm24;
@property (strong, nonatomic) NSString *frm25;
@property (strong, nonatomic) NSString *frm26;
@property (strong, nonatomic) NSString *frm27;
@property (strong, nonatomic) NSString *frm28;
@property (strong, nonatomic) NSString *frm29;
@property (strong, nonatomic) NSString *frm30;


@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
@property (weak, nonatomic) IBOutlet UIButton *cityLookup;
@property (weak, nonatomic) IBOutlet UIButton *jobLookup;
@property (weak, nonatomic) IBOutlet UIButton *productLookup;

@property (weak, nonatomic) IBOutlet UITextField *photo;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) UIPickerView *pickerView;

@end
