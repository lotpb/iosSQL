//
//  LeadDetailViewControler.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "LeadDetailViewControler.h"

@interface LeadDetailViewControler ()

@end

@implementation LeadDetailViewControler
{
    NSMutableArray *adArray, *salesArray, *jobArray;
    NSMutableArray *tableData, *tableData2, *tableData3, *tableData4;
    NSString *t12, *t11, *t13, *t14, *t15, *t16, *t21, *t22, *t23, *t24, *t25, *t26, *news1, *p1, *p12;
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
  /*
    if ( ([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]) ) {
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
        query31.cachePolicy = kPFCachePolicyCacheThenNetwork;
         [query31 whereKey:@"SalesNo" equalTo:self.tbl22];
        [query31 selectKeys:@[@"SalesNo"]];
        [query31 selectKeys:@[@"Salesman"]];
        [query31 orderByDescending:@"Salesman"];
        [query31 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            salesArray = [[NSMutableArray alloc]initWithArray:objects];
            if (!error) {
                for (PFObject *object in objects) {
                     self.salesman = [object objectForKey:@"Salesman"];
                   // [salesArray addObject:object];
                    [self.listTableView reloadData]; }
            } else
                NSLog(@"Error: %@ %@", error, [error userInfo]);
        }];
    } */
    
        /*
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
        [query31 whereKey:@"SalesNo" equalTo:self.tbl22];
        query31.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query31 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
     salesArray = [[NSMutableArray alloc]initWithArray:objects];
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.salesman = [object objectForKey:@"Salesman"];

        }];
        
        PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
        [query21 whereKey:@"JobNo" equalTo:self.tbl23];
        query21.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            jobArray = [[NSMutableArray alloc]initWithArray:object];
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.jobdescription = [object objectForKey:@"Description"];
            
        }];
        
    if ([_formController isEqual: @"Leads"]) {
        PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
        [query11 whereKey:@"AdNo" equalTo:self.tbl24];
        query11.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            adArray = [[NSMutableArray alloc]initWithArray:object];
            if (!object)
                NSLog(@"The getFirstObject request failed.");
            else
                self.advertiser = [object objectForKey:@"Advertiser"];
                //  NSLog(@"adStr is %@",self.advertiser);
        }];
    }
} */
    self.listTableView.rowHeight = 25;
    self.listTableView2.rowHeight = 25;
    self.newsTableView.estimatedRowHeight = 2.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;

#pragma mark Bar Button
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNew:)];
    NSArray *actionButtonItems = @[newItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
 
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
    
    if ((![self.date isEqual:[NSNull null]] ) && ( [self.date length] != 0 ))
            self.date = self.date;
       else self.date = @"None";
    
    if ((![self.comments isEqual:[NSNull null]] ) && ( [self.comments length] != 0 ))
        news1 = self.comments;
    else news1 = @"No Comments";
    
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

if ( ([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]) ) {
    
    if ((![self.tbl22 isEqual:[NSNull null]] ) && ( [self.tbl22 length] != 0 ))
          t22 = self.salesman;
     else t22 = @"None";
    
    if ((![self.tbl23 isEqual:[NSNull null]] ) && ( [self.tbl23 length] != 0 ))
          t23 = self.jobdescription;
     else t23 = @"None";

    if ((![self.tbl24 isEqual:[NSNull null]] ) && ( [self.tbl24 length] != 0 ))
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
    
    if ((![self.tbl26 isEqual:[NSNull null]] ) && ( [self.tbl26 length] != 0 ))
          t26 = self.tbl26;
     else t26 = @"None";
    
self.title = self.name;
self.labelNo.text = leadNo;
self.labeldate.text = date;
self.labeldatetext.text = self.l1datetext;
self.labelname.text = name;
self.labeladdress.text = address;
self.labelcity.text = [NSString stringWithFormat:@"%@ %@ %@", city, state, zip];
self.labelamount.text = amount;
self.comments = news1;
//self.photo = p1;

    ///below must be on bottom from above
    tableData = [NSMutableArray arrayWithObjects:t11, t12, t13, t14, t15, t16, nil];
    
    tableData2 = [NSMutableArray arrayWithObjects:t21, t22, t23, t24, t25, t26, nil];
    
    tableData4 = [NSMutableArray arrayWithObjects:self.l11, self.l12, self.l13,self.l14, self.l15, self.l16, nil];
    
    tableData3 = [NSMutableArray arrayWithObjects:self.l21, self.l22, self.l23, self.l24, self.l25, self.l26, nil];
    
    //add Following button
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.active isEqual:@"1"] ) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData]; [self.listTableView2 reloadData];
    [self.newsTableView reloadData];
}

- (void) viewDidLayoutSubviews { //added to fix the left side margin
    [super viewDidLayoutSubviews];
    self.listTableView.layoutMargins = UIEdgeInsetsZero;
    self.listTableView2.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - map Buttons
- (IBAction)mapButton:(UIButton *)sender{
    [self performSegueWithIdentifier:@"mapdetailSegue"sender:self];
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

#pragma mark TableView Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.listTableView]) {
    
    static NSString *CellIdentifier = @"NewCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.textLabel.text = [tableData4 objectAtIndex:indexPath.row];
    myCell.textLabel.font = [UIFont fontWithName:KEY_TABLEFONT size:8];//[UIFont systemFontOfSize:8.0];
   [myCell.textLabel setTextColor:[UIColor darkGrayColor]];
    myCell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
    myCell.detailTextLabel.font = [UIFont fontWithName:KEY_TITLEFONT size:8];//[UIFont boldSystemFontOfSize:8.0];
   [myCell.detailTextLabel setTextColor:[UIColor blackColor]];
        
    return myCell;
}
    else if ([tableView isEqual:self.listTableView2]) {
    
    static NSString *CellIdentifier2 = @"NewCell2";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.textLabel.text = [tableData3 objectAtIndex:indexPath.row];
    myCell.textLabel.font = [UIFont fontWithName:KEY_TABLEFONT size:8];//[UIFont systemFontOfSize:8.0];
   [myCell.textLabel setTextColor:[UIColor darkGrayColor]];
    myCell.detailTextLabel.text = [tableData2 objectAtIndex:indexPath.row];
    myCell.detailTextLabel.font = [UIFont fontWithName:KEY_TITLEFONT size:8];//[UIFont boldSystemFontOfSize:8.0];
   [myCell.detailTextLabel setTextColor:[UIColor blackColor]];

        //draw red vertical line
    UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, myCell.frame.size.height)];
    vertLine.backgroundColor = [UIColor redColor];
    [myCell.contentView addSubview:vertLine];
        
    return myCell;
}
    else if ([tableView isEqual:self.newsTableView]) {
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy-MM-dd"];
        dateFormater.timeZone = [NSTimeZone localTimeZone];
        NSDate *creationDate = [dateFormater dateFromString:self.date];
        NSDate *datetime1 = creationDate;
        NSDate *datetime2 = [NSDate date];
        double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
        NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
        
    static NSString *CellIdentifier1 = @"detailCell";
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
     //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.separatorInset = UIEdgeInsetsMake(0.0f, myCell.frame.size.width, 0.0f, 400.0f);
    myCell.leadtitleLabel.text = self.lnewsTitle;
    myCell.leadtitleLabel.numberOfLines = 0;
    myCell.leadtitleLabel.font = [UIFont systemFontOfSize:12.0];
   [myCell.leadtitleLabel setTextColor:[UIColor darkGrayColor]];
        
    myCell.leadsubtitleLabel.text = [NSString stringWithFormat:@"%@, %@",@"United News", resultDateDiff];
    myCell.leadsubtitleLabel.font = [UIFont systemFontOfSize:8.0];
   [myCell.leadsubtitleLabel setTextColor:[UIColor grayColor]];
        
    myCell.leadreadmore.text = @"Read more";
    myCell.leadreadmore.font = [UIFont systemFontOfSize:8.0];
        
    myCell.leadnews.text = comments;
    myCell.leadnews.numberOfLines = 0;
    myCell.leadnews.font = [UIFont boldSystemFontOfSize:8.0];
   [myCell.leadnews setTextColor:[UIColor darkGrayColor]];
        
    //Social buttons - code below
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(12,85, 20, 20)];
    [faceBtn setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:faceBtn];
        
    UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(42,85, 20, 20)];
    [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:twitBtn];
        
    UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(72,85, 20, 20)];
    [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
    [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:tumblrBtn];
        
    UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(102,85, 20, 20)];
    [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
    [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:yourBtn];
        
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
    
    UIAlertAction* new = [UIAlertAction
                         actionWithTitle:@"New Customer"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
    [self performSegueWithIdentifier:@"newcustSegue" sender:self];
                             [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    UIAlertAction* edit = [UIAlertAction
                         actionWithTitle:@"Edit"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
    [self performSegueWithIdentifier:@"editFormSegue" sender:self];
                             [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                            [view dismissViewControllerAnimated:YES completion:nil];
                            }];
    
    [view addAction:new];
    [view addAction:edit];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - social Buttons
- (void)share:(id)sender{
    NSString * message = self.date;
    NSString * message1 = self.name;
    NSString * message2 = self.comments;
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, message2, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([segue.identifier isEqualToString:@"mapdetailSegue"]) {
    MapViewController *detailVC = segue.destinationViewController;
       detailVC.mapaddress = self.address;
       detailVC.mapcity = self.city;
       detailVC.mapstate = self.state;
       detailVC.mapzip = self.zip; }
   
    if ([segue.identifier isEqualToString:@"newcustSegue"]) { //new Cust from Lead
        NewData *detailVC = segue.destinationViewController;
        if ([_formController isEqual: @"Leads"]) {
            detailVC.formController = @"Customer";
            //  detailVC.custNo = self.custNo;
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
            detailVC.frm21 = self.tbl22; //salesNo
            detailVC.frm22 = self.tbl23; //jobNo
            detailVC.frm23 = nil; //adNo
            detailVC.frm24 = self.amount;
            detailVC.frm25 = self.tbl15; //email
            detailVC.frm26 = self.tbl14; //spouse
            detailVC.frm27 = nil; //callback
            detailVC.frm28 = self.comments;
            detailVC.frm29 = self.photo;
            detailVC.frm30 = self.active;
            detailVC.saleNoDetail = self.tbl22;
            detailVC.jobNoDetail = self.tbl23;
            //detailVC.adNo.text = nil;
        }
    }
    
    if ([segue.identifier isEqualToString:@"editFormSegue"]) { //edit Lead
        EditData *detailVC = segue.destinationViewController;
        if ([_formController isEqual: @"Leads"]) {
            detailVC.formController = @"Leads";
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
            
        } else if ([_formController  isEqual: @"Customer"]) {
            detailVC.formController = @"Customer";
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
            //   detailVC.frm33 = self.photo1;
            //   detailVC.frm34 = self.photo2;
            
        } else if ([_formController  isEqual: @"Vendor"]) {
            detailVC.formController = @"Vendor";
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
            
        } else if ([_formController  isEqual: @"Employee"]) {
            detailVC.formController = @"Employee";
            detailVC.leadNo = self.leadNo; //employeeNo
            detailVC.frm11 = self.salesman; //first
            detailVC.frm12 = self.custNo; //lastname
            detailVC.frm13 = self.advertiser; //company
            detailVC.frm14 = self.address;
            detailVC.frm15 = self.city;
            detailVC.frm16 = self.state;
            detailVC.frm17 = self.zip;
            detailVC.frm18 = self.tbl25; //country
            detailVC.frm19 = self.tbl15;  //middle
            detailVC.frm20 = self.tbl11; //homephone
            detailVC.frm21 = self.tbl12; //workphone
            detailVC.frm22 = self.tbl13; //cellphone
            detailVC.frm23 = self.tbl14; //social
            detailVC.frm24 = self.tbl22; //department
            detailVC.frm25 = self.tbl21; //email
            detailVC.frm26 = self.tbl23; //title
            detailVC.frm27 = self.tbl24; //manager
            detailVC.frm28 = self.comments;
            detailVC.frm29 = nil; //assistant
            detailVC.frm30 = self.active;
        }
    }
}

@end

