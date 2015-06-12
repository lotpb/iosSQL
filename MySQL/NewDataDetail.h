//
//  NewDataDetail.h
//  MySQL
//
//  Created by Peter Balsamo on 2/10/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface NewDataDetail : UIViewController <UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSString *formController;
@property (strong, nonatomic) NSString *formStatus;
@property (strong, nonatomic) NSString *objectId; //Parse
@property (strong, nonatomic) NSString *active;
@property (strong, nonatomic) UITextField *salesNo;
@property (strong, nonatomic) UITextField *salesman;

@property (strong, nonatomic) NSString *frm11;
@property (strong, nonatomic) NSString *frm12;
@property (strong, nonatomic) NSString *frm13;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
