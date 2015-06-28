//
//  LeadDetailViewControler.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "LeadDetailViewControler.h"

@interface LeadDetailViewControler ()
{
  UIRefreshControl *refreshControl;    
}

@end

@implementation LeadDetailViewControler
{
    NSMutableArray *tableData, *tableData2, *tableData3, *tableData4;
    NSString *t12, *t11, *t13, *t14, *t15, *t16, *t21, *t22, *t23, *t24, *t25, *t26, *p1, *p12;
}
@synthesize leadNo, date, name, address, city, state, zip, comments, amount, active, photo, salesman, jobdescription, advertiser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(name, nil);
   // self.listTableView.delegate = self;
  //  self.listTableView.dataSource = self;
  //  self.listTableView2.delegate = self;
  //  self.listTableView2.dataSource = self;
  //  self.newsTableView.delegate = self;
  //  self.newsTableView.dataSource = self;
    self.listTableView.rowHeight = 25;
    self.listTableView2.rowHeight = 25;
    self.newsTableView.estimatedRowHeight = 250.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.edgesForExtendedLayout = UIRectEdgeNone;
   [self parseData];
   [self followButton];
 
    if ((![self.date isEqual:[NSNull null]] ) && ( [self.date length] != 0 ))
           self.date = self.date;
      else self.date = @"None";
    
    if ((![self.comments isEqual:[NSNull null]] ) && ( [self.comments length] != 0 ))
           self.comments = self.comments;
      else self.comments = @"No Comments";
    
   if ( ([_formController isEqual:TNAME3]) || ([_formController isEqual:TNAME4]) ) {
     self.labelamount.font = CELL_FONT1(20);
   }
    
#pragma mark Bar Button
        UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNew:)];
           UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showEdit:)];
        NSArray *actionButtonItems = @[editItem, newItem];
        self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.scrollWall insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
    
}
/*
//Call Number from here
NSString *phoneNo = [NSString stringWithFormat:@"+1234567890"];
NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phoneNo]];

if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
    [[UIApplication sharedApplication] openURL:phoneUrl];
}
else
{
    UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"You cannot call this consumer" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [calert show];
} */

- (void)viewDidAppear:(BOOL)animated { //fix only works in viewdidappear
    [super viewDidAppear:animated];
    [self fieldData];
    [self reloadTable];
    
    //animate label
    self.following.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 animations:^{
        self.following.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
}

- (void)reloadTable {
    [self.newsTableView reloadData];
    [self.listTableView reloadData]; [self.listTableView2 reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Fix
- (void) viewDidLayoutSubviews { //added to fix the left side margin
    [super viewDidLayoutSubviews];
    self.listTableView.layoutMargins = UIEdgeInsetsZero;
    self.listTableView2.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    [self reloadTable];
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:KEY_DATEREFRESH];
        NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }
        
        [refreshControl endRefreshing];
    }
}

#pragma mark - Buttons
- (void)followButton {
    
    UIImage *buttonImage1 = [UIImage imageNamed:ACTIVEBUTTONYES];
    UIImage *buttonImage2 = [UIImage imageNamed:ACTIVEBUTTONNO];
    if ([self.active isEqual:@"1"]) {
        [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
        self.following.text = @"Following";
    } else {
        [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
        self.following.text = @"Follow";}
    
    // Switch button
    if ( [t11 isEqual:@"Sold"] )
        [self.mySwitch setOn:YES];
    else [self.mySwitch setOn:NO];
}

#pragma mark  Map Buttons
- (IBAction)mapButton:(UIButton *)sender {
    [self performSegueWithIdentifier:MAPSEGUE sender:self];
}

#pragma mark Edit Buttons
-(void)showEdit:(id)sender {
    [self performSegueWithIdentifier:VIEWSEGUE sender:self];
}

#pragma mark UIActivityViewController
- (void)share:(id)sender {
    
    NSString * message = [NSString stringWithFormat:@"United News \n%@ \n%@ \n%@ %@ %@ \n%@ ", self.name, self.address, city, state, zip, self.comments];
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.listTableView]) {
        return [tableData count];
    } else if ([tableView isEqual:self.listTableView2]) {
        return [tableData count];
    } else if ([tableView isEqual:self.newsTableView]) {
        return 1;
    }
      return 0;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.listTableView]) {
    
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
     myCell.textLabel.text = [tableData4 objectAtIndex:indexPath.row];
    [myCell.textLabel setFont:CELL_FONT(DETAILFONTSIZE)];
    [myCell.textLabel setTextColor:DETAILCOLOR];
     myCell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
    [myCell.detailTextLabel setFont:CELL_MEDFONT(DETAILFONTSIZE)];
    [myCell.detailTextLabel setTextColor:DETAILTITLECOLOR];

    return myCell;
}
    else if ([tableView isEqual:self.listTableView2]) {
    
    static NSString *CellIdentifier2 = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
     myCell.textLabel.text = [tableData3 objectAtIndex:indexPath.row];
    [myCell.textLabel setFont:CELL_FONT(DETAILFONTSIZE)];
    [myCell.textLabel setTextColor:DETAILCOLOR];
     myCell.detailTextLabel.text = [tableData2 objectAtIndex:indexPath.row];
    [myCell.detailTextLabel setFont:CELL_MEDFONT(DETAILFONTSIZE)];
    [myCell.detailTextLabel setTextColor:DETAILTITLECOLOR];

        //draw red vertical line
    UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, myCell.frame.size.height)];
    vertLine.backgroundColor = DIVIDERCOLOR;
    [myCell.contentView addSubview:vertLine];

    return myCell;
}
     else if ([tableView isEqual:self.newsTableView]) {
      
    static NSString *CellIdentifier1 = IDCELL;
            CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];

     //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.separatorInset = UIEdgeInsetsMake(0.0f, myCell.frame.size.width, 0.0f, 400.0f);
    myCell.leadtitleLabel.text = self.lnewsTitle;
    myCell.leadtitleLabel.numberOfLines = 0;
    myCell.leadtitleLabel.font = CELL_FONT(DETAILNEWS);
   [myCell.leadtitleLabel setTextColor:DETAILTITLECOLOR];
         
//---------------------animate label--------------------------------
       /*
         //animate label
         myCell.leadtitleLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
         [UIView animateWithDuration:0.5 animations:^{
             myCell.leadtitleLabel.transform = CGAffineTransformIdentity;
         } completion:^(BOOL finished) {
             
         }]; */
     /*
         [UIView animateWithDuration:0.5
                               delay:0.0
                             options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                          animations:^{
                              myCell.leadtitleLabel.transform = CGAffineTransformScale(myCell.leadtitleLabel.transform, 0.7, 0.7);
                          }
                          completion:nil]; */
     
          myCell.leadtitleLabel.transform = CGAffineTransformMakeScale(0.3, 0.3);
         [UIView animateWithDuration:2.0
                               delay: 0.1
                             options: UIViewAnimationOptionBeginFromCurrentState
                          animations:^{
                               myCell.leadtitleLabel.transform = CGAffineTransformMakeScale(1.5, 1.5); //grow
                          }
                          completion:^(BOOL finished){
                               myCell.leadtitleLabel.transform = CGAffineTransformMakeScale(1, 1);
                          }];
//---------------------animate label--------------------------------
         
        static NSDateFormatter *dateFormater = nil;
        if (dateFormater == nil) {
            
            NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
            [dateFormater setDateFormat:KEY_DATESQLFORMAT];
            dateFormater.timeZone = [NSTimeZone localTimeZone];
            NSDate *creationDate = [dateFormater dateFromString:self.date];
            NSDate *datetime1 = creationDate;
            NSDate *datetime2 = [NSDate date];
            double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
            NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
        
    myCell.leadsubtitleLabel.text = [NSString stringWithFormat:@"%@, %@",@"United News", resultDateDiff];
    myCell.leadsubtitleLabel.font = CELL_FONT(DETAILNEWSFONTSIZE);
   [myCell.leadsubtitleLabel setTextColor:DETAILSUBCOLOR];
   }
    myCell.leadreadmore.text = @"Read more";
    myCell.leadreadmore.font = CELL_FONT(DETAILNEWSFONTSIZE);
        
    myCell.leadnews.text = self.comments;
    myCell.leadnews.numberOfLines = 0;
    myCell.leadnews.font = CELL_MEDFONT(DETAILNEWSFONTSIZE);
   [myCell.leadnews setTextColor:DETAILCOLOR];
    
    //Social buttons - code below
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45 ,self.newsTableView.frame.size.height-80, 20, 20)];//height 97
    [faceBtn setImage:[UIImage imageNamed:@"Upload50.png"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:faceBtn];
 /*
    UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(42,97, 20, 20)];
    [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:twitBtn];
        
    UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(72,97, 20, 20)];
    [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
    [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:tumblrBtn];
        
    UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(102,97, 20, 20)];
    [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
    [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:yourBtn]; */
        
    //add dark line border TableView Header - code below
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, .7)];
    separatorLineView.backgroundColor = [UIColor grayColor];// you can also put image here
    [myCell.contentView addSubview:separatorLineView];

return myCell;
        
    } else {
      NSLog(@"I have no idea what's going on...");
      return nil;
    }
}

#pragma mark - AlertController ios8
-(void)showNew:(id)sender {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Confirm"
                                 message:@"Enter data entry"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* addr = [UIAlertAction
                          actionWithTitle:@"Add to Contact"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              //Do some thing here
                               [self setContact:sender];
                         }];
    
    UIAlertAction* cal = [UIAlertAction
                          actionWithTitle:@"Add to Calender"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              //Do some thing here
                              [self performSegueWithIdentifier:CALENDSEGUE sender:self];
                              [view dismissViewControllerAnimated:YES completion:nil];
                          }];
    
                          if ([_formController isEqual:TNAME1]) {
    UIAlertAction* new = [UIAlertAction
                         actionWithTitle:@"Add to Customer"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                         [self performSegueWithIdentifier:NEWCUSTSEGUE sender:self];
                         [view dismissViewControllerAnimated:YES completion:nil];
                         }];
                         [view addAction:new];
                         }
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                            [view dismissViewControllerAnimated:YES completion:nil];
                            }];
                              
    [view addAction:addr];
    [view addAction:cal];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}
#pragma mark - LoadFieldData
- (void)fieldData {

    if ((![self.name isEqual:[NSNull null]] ) && ( [self.name length] != 0))
        self.name = self.name;
    else self.name = @"";
    
    if ((![self.address isEqual:[NSNull null]] ) && ( [self.address length] != 0))
        self.address = self.address;
    else self.address = @"Address";
    
    if ((![self.city isEqual:[NSNull null]] ) && ( [self.city length] != 0 ))
        self.city = self.city;
    else self.city = @"City";
    
    if ((![self.state isEqual:[NSNull null]] ) && ( [self.state length] != 0 ))
        self.state = self.state;
    else self.state = @"State";
    
    if ((![self.zip isEqual:[NSNull null]] ) && ( [self.zip length] != 0 ))
        self.zip = self.zip;
    else self.zip = @"Zip";
    
    if ((![self.amount isEqual:[NSNull null]] ) && ( [self.amount length] != 0 ))
        self.amount = self.amount;
    else self.amount = @"None";
   
  /*  if ((![self.date isEqual:[NSNull null]] ) && ( [self.date length] != 0 ))
        self.date = self.date;
    else self.date = @"None";
    
    if ((![self.comments isEqual:[NSNull null]] ) && ( [self.comments length] != 0 ))
        self.comments = self.comments;
    else self.comments = @"No Comments"; */
    
    if ((![self.photo isEqual:[NSNull null]] ) && ( [self.photo length] != 0 ))
        p1 = self.photo;
    else p1 = @"None";
    
    if ((![self.tbl11 isEqual:[NSNull null]] ) && ( [self.tbl11 length] != 0 ))
        t11 = self.tbl11;
    else t11 = @"None";
    
    if ((![self.tbl12 isEqual:[NSNull null]] ) && ( [self.tbl12 length] != 0 ))
        t12 = self.tbl12;
    else t12 = @"None";
    
    if ((![self.tbl13 isEqual:[NSNull null]] ) && ( [self.tbl13 length] != 0 ))
        t13 = self.tbl13;
    else t13 = @"None";
    
    if ((![self.tbl14 isEqual:[NSNull null]] ) && ( [self.tbl14 length] != 0 ))
        t14 = self.tbl14;
    else t14 = @"None";
    
    if ((![self.tbl15 isEqual:[NSNull null]] ) && ( [self.tbl15 length] != 0 ))
        t15 = self.tbl15;
    else t15 = @"None";
    
    if ((![self.tbl16 isEqual:[NSNull null]] ) && ( [self.tbl16 length] != 0 ))
        t16 = self.tbl16;
    else t16 = @"None";
    
    if ((![self.tbl21 isEqual:[NSNull null]] ) && ( [self.tbl21 length] != 0 ))
        t21 = self.tbl21;
    else t21 = @"None";
    
    if ( ([_formController isEqual: TNAME1]) || ([_formController isEqual: TNAME2]) ) {
        
        if ((![self.salesman isEqual:[NSNull null]] ) && ( [self.salesman length] != 0 ))
            t22 = self.salesman;
        else t22 = @"None";
        
        if ((![self.jobdescription isEqual:[NSNull null]] ) && ( [self.jobdescription length] != 0 ))
            t23 = self.jobdescription;
        else t23 = @"None";
        
        if ((![self.advertiser isEqual:[NSNull null]] ) && ( [self.advertiser length] != 0 ))
            t24 = self.advertiser;
        else t24 = @"None";
        
    } else {
        
        if ((![self.tbl22 isEqual:[NSNull null]] ) && ( [self.tbl22 length] != 0 ))
            t22 = self.tbl22;
        else t22 = @"None";
        
        if ((![self.tbl23 isEqual:[NSNull null]] ) && ( [self.tbl23 length] != 0 ))
            t23 = self.tbl23;
        else t23 = @"None";
        
        if ((![self.tbl24 isEqual:[NSNull null]] ) && ( [self.tbl24 length] != 0 ))
            t24 = self.tbl24;
        else t24 = @"None";
    }
    
    if ((![self.tbl25 isEqual:[NSNull null]] ) && ( [self.tbl25 length] != 0 ))
        t25 = self.tbl25;
    else t25 = @"None";
    
//if ([_formController isEqual: TNAME1]) { //was displaying null in photofield
    if ((![self.tbl26 isEqual:[NSNull null]] ) && ( [self.tbl26 length] != 0 ))
        t26 = self.tbl26;
    else t26 = @"None";
//} else {
//    if ((![self.tbl26 isEqual:[NSNull null]] ) && ( [self.tbl26 length] != 0 ))
//        t26 = self.tbl26;
//    else t26 = @"None";
//}
    self.labelNo.text = leadNo;
    self.labeldate.text = date;
    self.labeldatetext.text = self.l1datetext;
    self.labelname.text = name;
    self.labeladdress.text = address;
    self.labelcity.text = [NSString stringWithFormat:@"%@ %@ %@", city, state, zip];
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if (([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) && (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2])))
        self.labelamount.text = [NSString stringWithFormat:@"%@.00",amount];
     else
        self.labelamount.text = amount;
    
    //self.photo = p1;
    
    tableData = [NSMutableArray arrayWithObjects:t11, t12, t13, t14, t15, t16, nil];
    
    tableData2 = [NSMutableArray arrayWithObjects:t21, t22, t23, t24, t25, t26, nil];
    
    tableData4 = [NSMutableArray arrayWithObjects:self.l11, self.l12, self.l13,self.l14, self.l15, self.l16, nil];
    
    tableData3 = [NSMutableArray arrayWithObjects:self.l21, self.l22, self.l23, self.l24, self.l25, self.l26, nil];
    
}
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
#pragma mark - Parse
- (void)parseData {
    if ( ([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]) ) {
        PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
        [query21 whereKey:@"JobNo" equalTo:self.tbl23];
        query21.cachePolicy = kPFCACHEPOLICY;
        [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.jobdescription = [object objectForKey:@"Description"];
        }];
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
        [query31 whereKey:@"SalesNo" equalTo:self.tbl22];
        query31.cachePolicy = kPFCACHEPOLICY;
        [query31 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.salesman = [object objectForKey:@"Salesman"];
            // NSLog(@"adStr is %@",self.salesman);
        }];
    }
    
    if ([_formController isEqual:TNAME2]) {
        PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
        query3.cachePolicy = kPFCACHEPOLICY;
        [query3 whereKey:@"ProductNo" containsString:self.tbl24];
        [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.advertiser = [object objectForKey:@"Products"];
        }];
    }
    
    if ([_formController isEqual:TNAME1]) {
        PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
        [query11 whereKey:@"AdNo" equalTo:self.tbl24];
        query11.cachePolicy = kPFCACHEPOLICY;
        [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.advertiser = [object objectForKey:@"Advertiser"];
        }];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:MAPSEGUE]) {
    MapViewController *detailVC = segue.destinationViewController;
       detailVC.mapaddress = self.address;
       detailVC.mapcity = self.city;
       detailVC.mapstate = self.state;
       detailVC.mapzip = self.zip; }
   /*
    if ([segue.identifier isEqualToString:CALENDSEGUE]) {
        CalenderEdit *detailVC = segue.destinationViewController;
        detailVC.calname = self.name; } */
 
    if ([segue.identifier isEqualToString:NEWCUSTSEGUE]) { //new Customer from Lead
        NewData *detailVC = segue.destinationViewController;
        if ([_formController isEqual: TNAME1]) {
            detailVC.formController = TNAME2;
            detailVC.custNo = self.custNo;
            detailVC.frm31 = self.leadNo;
            detailVC.frm11 = self.tbl13; //first
            detailVC.frm12 = self.name;
            detailVC.frm13 = nil;
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = nil; //date
            detailVC.frm19 = nil; //aptdate
            detailVC.frm20 = self.tbl12; //phone
            detailVC.frm21 = self.salesman;
            detailVC.frm22 = self.jobdescription;
            detailVC.frm23 = nil; //adNo
            detailVC.frm24 = self.amount;
            detailVC.frm25 = self.tbl15; //email
            detailVC.frm26 = self.tbl14; //spouse
            detailVC.frm27 = nil; //callback
            detailVC.frm28 = self.comments;
            detailVC.frm29 = self.photo;
            detailVC.frm30 = self.active;
            detailVC.saleNoDetail = self.tbl22; //salesNo
            detailVC.jobNoDetail = self.tbl23; //jobNo
        }
    }
    
    if ([segue.identifier isEqualToString:VIEWSEGUE]) { //edit Lead
        EditData *detailVC = segue.destinationViewController;
        if ([_formController isEqual:TNAME1]) {
            detailVC.formController = TNAME1;
            detailVC.objectId = self.objectId; //Parse Only
            detailVC.leadNo = self.leadNo;
            detailVC.frm11 = self.tbl13; //first
            detailVC.frm12 = self.name;
            detailVC.frm13 = nil;
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = self.date;
            detailVC.frm19 = self.tbl21; //aptdate
            detailVC.frm20 = self.tbl12; //phone
            detailVC.frm21 = self.tbl22; //salesNo
            detailVC.frm22 = self.tbl23; //jobNo
            detailVC.frm23 = self.tbl24; //adNo
            detailVC.frm24 = self.amount;
            detailVC.frm25 = self.tbl15; //email
            detailVC.frm26 = self.tbl14; //spouse
            detailVC.frm27 = self.tbl11; //callback
            detailVC.frm28 = self.comments;
            detailVC.frm29 = self.photo;
            detailVC.frm30 = self.active;
            detailVC.saleNo = self.tbl22;
            detailVC.jobNo = self.tbl23;
            detailVC.adNo = self.tbl24;
            
        } else if ([_formController  isEqual:TNAME2]) { //edit Cust
            detailVC.formController = TNAME2;
            detailVC.objectId = self.objectId; //Parse Only
            detailVC.custNo = self.custNo;
            detailVC.leadNo = self.leadNo;
            detailVC.frm11 = self.tbl13; //first
            detailVC.frm12 = self.name; //last Name
            detailVC.frm13 = self.tbl11; //contractor
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = self.date;
            detailVC.frm19 = self.tbl26;  //rate
            detailVC.frm20 = self.tbl12; //phone
            detailVC.frm21 = self.tbl22; //salesNo
            detailVC.frm22 = self.tbl23; //jobNo
            detailVC.frm23 = self.tbl24; //productNo
            detailVC.frm24 = self.amount;
            detailVC.frm25 = self.tbl15; //email
            detailVC.frm26 = self.tbl14; //spouse
            detailVC.frm27 = self.tbl25;  //quan
            detailVC.frm28 = self.comments;
            detailVC.frm29 = self.photo;
            detailVC.frm30 = self.active;
            detailVC.frm31 = self.tbl21; //start date
            detailVC.frm32 = self.complete;
            detailVC.saleNo = self.tbl22;
            detailVC.jobNo = self.tbl23;
            detailVC.adNo = self.tbl24;
            detailVC.time = self.tbl16;
         // detailVC.frm33 = self.photo1;
         // detailVC.frm34 = self.photo2;
            
        } else if ([_formController  isEqual:TNAME3]) { //edit Vendor
            detailVC.formController = TNAME3;
            detailVC.objectId = self.objectId; //Parse Only
            detailVC.leadNo = self.leadNo; //vendorNo
            detailVC.frm11 = self.tbl24; //manager
            detailVC.frm12 = self.date; //webpage
            detailVC.frm13 = self.name; //vendorname
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = self.tbl25; //profession
            detailVC.frm19 = self.tbl15;  //assistant
            detailVC.frm20 = self.tbl11; //phone
            detailVC.frm21 = self.tbl12; //phone1
            detailVC.frm22 = self.tbl13; //phone2
            detailVC.frm23 = self.tbl14; // phone3
            detailVC.frm24 = self.tbl22; //department
            detailVC.frm25 = self.tbl21; //email
            detailVC.frm26 = self.tbl23; //office
            detailVC.frm27 = nil;
            detailVC.frm28 = self.comments;
            detailVC.frm29 = nil;
            detailVC.frm30 = self.active;
            
        } else if ([_formController  isEqual:TNAME4]) { //edit Employee
            detailVC.formController = TNAME4;
            detailVC.objectId = self.objectId; //Parse Only
            detailVC.leadNo = self.leadNo; //employeeNo
            detailVC.frm11 = self.tbl26; //first
            detailVC.frm12 = self.custNo; //lastname
            detailVC.frm13 = self.tbl27; //company
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = self.tbl23; //title
            detailVC.frm19 = self.tbl15;  //middle
            detailVC.frm20 = self.tbl11; //homephone
            detailVC.frm21 = self.tbl12; //workphone
            detailVC.frm22 = self.tbl13; //cellphone
            detailVC.frm23 = self.tbl14; //social
            detailVC.frm24 = self.tbl22; //department
            detailVC.frm25 = self.tbl21; //email
            detailVC.frm26 = self.tbl25; //country
            detailVC.frm27 = self.tbl24; //manager
            detailVC.frm28 = self.comments;
            detailVC.frm29 = nil;
            detailVC.frm30 = self.active;
        }
    }
}
#pragma mark - Contact
#pragma mark AuthorizeContact
- (void)setContact:(id)sender {
    if (ABAddressBookGetAuthorizationStatus() == kCLAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kCLAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [cantAddContactAlert show];
    } else if (ABAddressBookGetAuthorizationStatus() == kCLAuthorizationStatusAuthorizedAlways){
        //2
        NSLog(@"Authorized");
        [self addContact:sender];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!granted){
                    //4
                    UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact" message: @"You must give the app permission to add the contact first." delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
                    [cantAddContactAlert show];
                    return;
                }
                //5
                [self addContact:sender];
            });
        });
    }
}
#pragma mark addContact
- (void)addContact:(id)sender {
    
    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    ABRecordRef person = ABPersonCreate();
    
    if ([_formController isEqual:TNAME1]) {  //leads
        // Creating new entry
    // Setting basic properties
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.tbl13) , nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.name), nil);
    ABRecordSetValue(person, kABPersonNoteProperty, CFBridgingRetain(self.comments), nil);
    
    // Adding address
    ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:self.address forKey:(NSString *)kABPersonAddressStreetKey];
    [addressDictionary setObject:self.city forKey:(NSString *)kABPersonAddressCityKey];
     [addressDictionary setObject:self.state forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:self.zip forKey:(NSString *)kABPersonAddressZIPKey];
    [addressDictionary setObject:@"US" forKey:(NSString *)kABPersonAddressCountryKey];
    ABMultiValueAddValueAndLabel(addressMultipleValue, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
    ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
    CFRelease(addressMultipleValue);
    
    // Adding phone numbers
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl12), (CFStringRef)@"home", NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
    CFRelease(phoneNumberMultiValue);
    
    // Adding emails
    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(self.tbl15), (CFStringRef)@"email", NULL);
    ABRecordSetValue(person, kABPersonURLProperty, emailMultiValue, nil);
    CFRelease(emailMultiValue);
         
    // Adding photo
    //ABPersonSetImageData(person, (__bridge CFDataRef)self.photo, nil);
 
    // Adding person to the address book
    ABAddressBookAddRecord(addressBook, person, nil);
    }
    
    if ([_formController isEqual:TNAME2]) { //cust
        // Creating new entry
        // Setting basic properties
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.tbl13) , nil);
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.name), nil);
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFTypeRef)(self.tbl11), nil);
        ABRecordSetValue(person, kABPersonNoteProperty, CFBridgingRetain(self.comments), nil);
        
        // Adding address
        ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        [addressDictionary setObject:self.address forKey:(NSString *)kABPersonAddressStreetKey];
        [addressDictionary setObject:self.city forKey:(NSString *)kABPersonAddressCityKey];
        [addressDictionary setObject:self.state forKey:(NSString *)kABPersonAddressStateKey];
        [addressDictionary setObject:self.zip forKey:(NSString *)kABPersonAddressZIPKey];
        [addressDictionary setObject:@"US" forKey:(NSString *)kABPersonAddressCountryKey];
        ABMultiValueAddValueAndLabel(addressMultipleValue, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
        ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
        CFRelease(addressMultipleValue);
        
        // Adding phone numbers
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl12), (CFStringRef)@"home", NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
        
        // Adding emails
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(self.tbl15), (CFStringRef)@"email", NULL);
        ABRecordSetValue(person, kABPersonURLProperty, emailMultiValue, nil);
        CFRelease(emailMultiValue);
        
        // Adding photo
        //ABPersonSetImageData(person, (__bridge CFDataRef)self.photo, nil);
        
        // Adding person to the address book
        ABAddressBookAddRecord(addressBook, person, nil);
       }
    
    if ([_formController isEqual:TNAME3]) { //vendor

        // Setting basic properties
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFTypeRef)(self.name), nil);
        ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFTypeRef)(self.tbl25), nil);
        ABRecordSetValue(person, kABPersonNoteProperty, CFBridgingRetain(self.comments), nil);
        
        // Adding address
        ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        [addressDictionary setObject:self.address forKey:(NSString *)kABPersonAddressStreetKey];
        [addressDictionary setObject:self.city forKey:(NSString *)kABPersonAddressCityKey];
        [addressDictionary setObject:self.state forKey:(NSString *)kABPersonAddressStateKey];
        [addressDictionary setObject:self.zip forKey:(NSString *)kABPersonAddressZIPKey];
        [addressDictionary setObject:@"US" forKey:(NSString *)kABPersonAddressCountryKey];
        ABMultiValueAddValueAndLabel(addressMultipleValue, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
        ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
        CFRelease(addressMultipleValue);
        
        // Adding phone numbers
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl11), (CFStringRef)@"work", NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl12), (CFStringRef)@"work", NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl13), (CFStringRef)@"cell", NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl14), (CFStringRef)@"home", NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
        
        // Adding url
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFTypeRef)(self.date), kABPersonHomePageLabel, NULL);
        ABRecordSetValue(person, kABPersonURLProperty, urlMultiValue, nil);
        CFRelease(urlMultiValue);
        
        // Adding emails
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(self.tbl21), (CFStringRef)@"email", NULL);
        ABRecordSetValue(person, kABPersonURLProperty, emailMultiValue, nil);
        CFRelease(emailMultiValue);
        
        // Adding photo
        //ABPersonSetImageData(person, (__bridge CFDataRef)self.photo, nil);
        
        // Adding person to the address book
        ABAddressBookAddRecord(addressBook, person, nil);
       }
    
    if ([_formController isEqual:TNAME4]) { //employee
        
        // Setting basic properties
        ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.tbl26) , nil);
        ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.custNo), nil);
        ABRecordSetValue(person, kABPersonMiddleNameProperty, (__bridge CFTypeRef)(self.tbl15), nil);
        ABRecordSetValue(person, kABPersonOrganizationProperty, (__bridge CFTypeRef)(self.tbl27), nil);
        ABRecordSetValue(person, kABPersonJobTitleProperty, (__bridge CFTypeRef)(self.tbl23), nil);
        ABRecordSetValue(person, kABPersonNoteProperty, CFBridgingRetain(self.comments), nil);
        
        // Adding address
        ABMutableMultiValueRef addressMultipleValue = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        [addressDictionary setObject:self.address forKey:(NSString *)kABPersonAddressStreetKey];
        [addressDictionary setObject:self.city forKey:(NSString *)kABPersonAddressCityKey];
        [addressDictionary setObject:self.state forKey:(NSString *)kABPersonAddressStateKey];
        [addressDictionary setObject:self.zip forKey:(NSString *)kABPersonAddressZIPKey];
        [addressDictionary setObject:self.tbl25 forKey:(NSString *)kABPersonAddressCountryKey];
        ABMultiValueAddValueAndLabel(addressMultipleValue, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
        ABRecordSetValue(person, kABPersonAddressProperty, addressMultipleValue, nil);
        CFRelease(addressMultipleValue);
        
        // Adding phone numbers
        ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl11), (CFStringRef)@"home", NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl12), (CFStringRef)@"work", NULL);
        ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)(self.tbl13), (CFStringRef)@"cell", NULL);
        ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
        CFRelease(phoneNumberMultiValue);
        
        // Adding emails
        ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(self.tbl21), (CFStringRef)@"email", NULL);
        ABRecordSetValue(person, kABPersonURLProperty, emailMultiValue, nil);
        CFRelease(emailMultiValue);
        
        // Adding photo
        //ABPersonSetImageData(person, (__bridge CFDataRef)self.photo, nil);
        
        // Adding person to the address book
        ABAddressBookAddRecord(addressBook, person, nil);
       }
        CFRelease(addressBook);
    if (person) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookAddRecord(addressBook, person, nil);
        ABAddressBookSave(addressBook, nil);
        //----------alert--------------------------
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [contactAddedAlert show];
        //-----------------------------------------
        CFRelease(addressBook);
        }
}

@end
