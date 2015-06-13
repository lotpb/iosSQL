//
//  EditData.h
//  MySQL
//
//  Created by Peter Balsamo on 1/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ParseConnection.h"
#import <Parse/Parse.h>
#import "LeadDetailViewControler.h"
#import "LookupCity.h"
#import "LookupJob.h"
#import "LookupProduct.h"
#import "LookupSalesman.h"


@interface EditData : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) NSString *formController;
@property (strong, nonatomic) NSString *objectId; //Parse
@property (strong, nonatomic) NSString *time; //Parse
@property (strong, nonatomic) NSString *custNo;
@property (strong, nonatomic) NSString *leadNo;
@property (strong, nonatomic) NSString *active;
@property (weak, nonatomic) IBOutlet UITextField *first;
@property (weak, nonatomic) IBOutlet UITextField *last;
@property (weak, nonatomic) IBOutlet UITextField *company;

@property (strong, nonatomic) UITextField  *date;
@property (strong, nonatomic) UITextField *address;
@property (strong, nonatomic) UITextField *city;
@property (strong, nonatomic) UITextField *state;
@property (strong, nonatomic) UITextField *zip;
@property (strong, nonatomic) UITextField *aptDate;
@property (strong, nonatomic) UITextField *phone;
@property (strong, nonatomic) UITextField *salesman;
@property (strong, nonatomic) UITextField *jobName;
@property (strong, nonatomic) UITextField *adName;
@property (strong, nonatomic) UITextField *amount;
@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) UITextField *spouse;
@property (strong, nonatomic) UITextField *callback;
@property (strong, nonatomic) UITextView *comment;
@property (strong, nonatomic) UITextField *start; // cust
@property (strong, nonatomic) UITextField *complete; //cust

@property (strong, nonatomic) NSString *rate; //cust
@property (strong, nonatomic) NSString *saleNo;
@property (strong, nonatomic) NSString *jobNo;
@property (strong, nonatomic) NSString *adNo;

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
@property (strong, nonatomic) NSString *frm31; //start
@property (strong, nonatomic) NSString *frm32; //completion date

//@property (weak, nonatomic) IBOutlet UIButton *clearBTN;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;

@property (weak, nonatomic) IBOutlet UITextField *photo;
@property (strong, nonatomic) NSString *photo1;
@property (strong, nonatomic) NSString *photo2;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
