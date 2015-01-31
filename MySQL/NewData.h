//
//  NewData.h
//  MySQL
//
//  Created by Peter Balsamo on 1/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LeadDetailViewControler.h"
#import "LookupCity.h"
#import "LookupJob.h"
#import "LookupProduct.h"
#import "LookupSalesman.h"

@interface NewData : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate>

//may be a problem with employee lastname may be under custNo
@property (strong, nonatomic) NSString *formController;
@property (strong, nonatomic) NSString *custNo;
@property (strong, nonatomic) NSString *leadNo;
@property (strong, nonatomic) NSString *active;
@property (strong, nonatomic) UITextField  *date;
@property (strong, nonatomic) IBOutlet UITextField *first;
@property (strong, nonatomic) IBOutlet UITextField *last;
@property (strong, nonatomic) IBOutlet UITextField *company;
@property (strong, nonatomic) UITextField *address;
@property (strong, nonatomic) UITextField *city;
@property (strong, nonatomic) UITextField *state;
@property (strong, nonatomic) UITextField *zip;
@property (strong, nonatomic) UITextField *phone;
@property (strong, nonatomic) UITextField *aptDate;
@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) UITextField *amount;
@property (strong, nonatomic) UITextField *spouse;
@property (strong, nonatomic) UITextField *callback;
@property (strong, nonatomic) UITextField *rate;
@property (strong, nonatomic) NSString *saleNo;
@property (strong, nonatomic) UITextField *salesman;
@property (strong, nonatomic) NSString *jobNo;
@property (strong, nonatomic) UITextField *jobName;
@property (strong, nonatomic) NSString *adNo;
@property (strong, nonatomic) UITextField *adName;
@property (strong, nonatomic) UITextView *comment;

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
//@property (strong, nonatomic) NSString *frm31; //rate

@property (weak, nonatomic) IBOutlet UIButton *clearBTN;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
//@property (weak, nonatomic) IBOutlet UIButton *cityLookup;
//@property (weak, nonatomic) IBOutlet UIButton *jobLookup;
//@property (weak, nonatomic) IBOutlet UIButton *productLookup;

@property (weak, nonatomic) IBOutlet UITextField *photo;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (retain, nonatomic) UIPickerView *pickerView;


@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
