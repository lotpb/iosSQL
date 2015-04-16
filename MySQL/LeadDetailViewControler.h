//
//  LeadDetailViewControler.h
//  MySQL
//
//  Created by Peter Balsamo on 10/4/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomTableViewCell.h"
#import <Parse/Parse.h>
#import "EditData.h"
#import "NewData.h"
#import "MapViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
//#import "CalenderEdit.h"


@interface LeadDetailViewControler : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollWall;
@property (strong, nonatomic) NSString *formController;
//need to share strings below give need common name
@property (strong, nonatomic) NSString *custNo;
@property (strong, nonatomic) NSString *leadNo;
@property (weak, nonatomic) IBOutlet UILabel *labelNo;
@property (strong, nonatomic) NSString *name;
@property (weak, nonatomic) IBOutlet UILabel *labelname;
@property (strong, nonatomic) NSString *amount;
@property (weak, nonatomic) IBOutlet UILabel *labelamount;
@property (strong, nonatomic) NSString *date;
@property (weak, nonatomic) IBOutlet UILabel *labeldate;
@property (strong, nonatomic) NSString *address;
@property (weak, nonatomic) IBOutlet UILabel *labeladdress;
@property (strong, nonatomic) NSString *city;
@property (weak, nonatomic) IBOutlet UILabel *labelcity;
@property (weak, nonatomic) IBOutlet UILabel *following;
//label text only
@property (strong, nonatomic) NSString *l1datetext;
@property (weak, nonatomic) IBOutlet UILabel *labeldatetext;

@property (strong, nonatomic) NSString *tbl11;
@property (strong, nonatomic) NSString *tbl12;
@property (strong, nonatomic) NSString *tbl13;
@property (strong, nonatomic) NSString *tbl14;
@property (strong, nonatomic) NSString *tbl15;
@property (strong, nonatomic) NSString *tbl16;

@property (strong, nonatomic) NSString *tbl21;
@property (strong, nonatomic) NSString *tbl22;
@property (strong, nonatomic) NSString *tbl23;
@property (strong, nonatomic) NSString *tbl24;
@property (strong, nonatomic) NSString *tbl25;
@property (strong, nonatomic) NSString *tbl26;
@property (strong, nonatomic) NSString *tbl27; //employee company
/*
@property (strong, nonatomic) NSString *t11;
@property (strong, nonatomic) NSString *t12;
@property (strong, nonatomic) NSString *t13;
@property (strong, nonatomic) NSString *t14;
@property (strong, nonatomic) NSString *t15;

@property (strong, nonatomic) NSString *t21;
@property (strong, nonatomic) NSString *t22;
@property (strong, nonatomic) NSString *t23;
@property (strong, nonatomic) NSString *t24;
@property (strong, nonatomic) NSString *t25;
*/
@property (strong, nonatomic) NSString *l11;
@property (strong, nonatomic) NSString *l12;
@property (strong, nonatomic) NSString *l13;
@property (strong, nonatomic) NSString *l14;
@property (strong, nonatomic) NSString *l15;
@property (strong, nonatomic) NSString *l16;
@property (strong, nonatomic) NSString *l21;
@property (strong, nonatomic) NSString *l22;
@property (strong, nonatomic) NSString *l23;
@property (strong, nonatomic) NSString *l24;
@property (strong, nonatomic) NSString *l25;
@property (strong, nonatomic) NSString *l26;
@property (strong, nonatomic) NSString *lnewsTitle;
@property (strong, nonatomic) NSString *complete;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) NSString *comments;
@property (strong, nonatomic) NSString *active;

@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

// below from custom cell
@property (strong, nonatomic) UILabel *leadtitleLabel;
@property (strong, nonatomic) UILabel *leadsubtitleLabel;
@property (strong, nonatomic) UILabel *leadreadmore;
//@property (weak, nonatomic) IBOutlet UIImageView *leadImageView;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView2;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *activebutton;
//@property (weak, nonatomic) Location *selectedLocation;

@property (strong, nonatomic) NSString *salesman;
@property (strong, nonatomic) NSString *jobdescription;
@property (strong, nonatomic) NSString *advertiser;

@end
