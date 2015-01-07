//
//  LeadDetailViewControler.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "LeadDetailViewControler.h"
#import "CustomTableViewCell.h"

@interface LeadDetailViewControler ()

@end

@implementation LeadDetailViewControler
{
    NSArray *tableData, *tableData2, *tableData3, *tableData4;
}
@synthesize leadNo, date, name, address, city, state, zip, comments, amount,active, photo, salesman, jobdescription, advertiser;

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
    self.listTableView.rowHeight = 25;
    self.listTableView2.rowHeight = 25;
    self.newsTableView.estimatedRowHeight = 2.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    
    NSString *t12, *t11, *t13, *t14, *t15, *t21, *t22, *t23, *t24, *t25, *news1, *p1;
    
#pragma mark Bar Button
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNew:)];
    NSArray *actionButtonItems = @[newItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    if ( ( ![self.name isEqual:[NSNull null]] ) && ( [self.name length] != 0 ) ) {self.name = self.name;
    } else { self.name = @""; }
    
    if ( ( ![self.address isEqual:[NSNull null]] ) && ( [self.address length] != 0 ) ) {self.address = self.address;
    } else { self.address = @"Address"; }
    
    if ( ( ![self.city isEqual:[NSNull null]] ) && ( [self.city length] != 0 ) ) {self.city = self.city;
    } else { self.city = @"City"; }
    
    if ( ( ![self.state isEqual:[NSNull null]] ) && ( [self.state length] != 0 ) ) {self.state = self.state;
    } else { self.state = @"State"; }
    
    if ( ( ![self.zip isEqual:[NSNull null]] ) && ( [self.zip length] != 0 ) ) {self.zip = self.zip;
    } else { self.zip = @"Zip"; }
    
    if ( ( ![self.amount isEqual:[NSNull null]] ) && ( [self.amount length] != 0 ) ) {self.amount = self.amount;
    } else { self.amount = @"None"; }
    
    if ( ( ![self.date isEqual:[NSNull null]] ) && ( [self.date length] != 0 ) ) {self.date = self.date;
    } else { self.date = @"None"; }
    
if ( ( ![self.tbl11 isEqual:[NSNull null]] ) && ( [self.tbl11 length] != 0 ) ) {t11 = self.tbl11;
} else { t11 = @"None"; }
    
if ( ( ![self.tbl12 isEqual:[NSNull null]] ) && ( [self.tbl12 length] != 0 ) ) {t12 = self.tbl12;
} else { t12 = @"None"; }
    
if ( ( ![self.tbl13 isEqual:[NSNull null]] ) && ( [self.tbl13 length] != 0 ) ) {t13 = self.tbl13;
} else { t13 = @"None"; }
    
if ( ( ![self.tbl14 isEqual:[NSNull null]] ) && ( [self.tbl14 length] != 0 ) ) {t14 = self.tbl14;
} else { t14 = @"None"; }
    
if ( ( ![self.tbl15 isEqual:[NSNull null]] ) && ( [self.tbl15 length] != 0 ) ) {t15 = self.tbl15;
} else { t15 = @"None"; }
    
if ( ( ![self.tbl21 isEqual:[NSNull null]] ) && ( [self.tbl21 length] != 0 ) ) {t21 = self.tbl21;
} else { t21 = @"None"; }
    
if ( ( ![self.tbl22 isEqual:[NSNull null]] ) && ( [self.tbl22 length] != 0 ) ) {t22 = self.tbl22;
} else { t22 = @"None"; }
    
if ( ( ![self.tbl23 isEqual:[NSNull null]] ) && ( [self.tbl23 length] != 0 ) ) {t23 = self.tbl23;
} else { t23 = @"None"; }
    
if ( ( ![self.tbl24 isEqual:[NSNull null]] ) && ( [self.tbl24 length] != 0 ) ) {t24 = self.tbl24;
} else { t24 = @"None"; }
    
if ( ( ![self.tbl25 isEqual:[NSNull null]] ) && ( [self.tbl25 length] != 0 ) ) {t25 = self.tbl25;
    } else { t25 = @"None"; }
    
if ( ( ![self.comments isEqual:[NSNull null]] ) && ( [self.comments length] != 0 ) ) {news1 = self.comments;
} else { news1 = @"No Comments"; }
    
if ( ( ![self.photo isEqual:[NSNull null]] ) && ( [self.photo length] != 0 ) ) {p1 = self.photo;
} else { p1 = @"None"; }
    
self.title = self.name;
self.labelNo.text = leadNo;
self.labeldate.text = date;
self.labeldatetext.text = self.l1datetext;
self.labelname.text = name;
self.labeladdress.text = address;
self.labelcity.text = [NSString stringWithFormat:@"%@ %@ %@", city, state, zip];
self.labelamount.text = amount;
self.comments = news1;
self.photo = p1;
    
///below must be on bottom from above
tableData = [NSArray arrayWithObjects:t11, t12, t13, t14, t15, nil];
    
tableData2 = [NSArray arrayWithObjects:t21, t22, t23, t24, t25, nil];
    
tableData4 = [NSArray arrayWithObjects:self.l11, self.l12, self.l13,self.l14, self.l15, nil];
    
tableData3 = [NSArray arrayWithObjects:self.l21, self.l22, self.l23, self.l24, self.l25, nil];
    
    //add Following button
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.active isEqual:@"1"] )
    {[self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
              self.following.text = @"Following";
    } else { [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
              self.following.text = @"Follow";}
    //add Switch button
    if ( [t11 isEqual:@"Sold"] ) {
             [self.mySwitch setOn:YES];
    } else { [self.mySwitch setOn:NO]; }
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
//- (void)mapButton:(id)sender{
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
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.textLabel.text = [tableData4 objectAtIndex:indexPath.row];
    myCell.textLabel.font = [UIFont systemFontOfSize:8.0];
   [myCell.textLabel setTextColor:[UIColor darkGrayColor]];
    myCell.detailTextLabel.text = [tableData objectAtIndex:indexPath.row];
    myCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:8.0];
   [myCell.detailTextLabel setTextColor:[UIColor blackColor]];
        
    return myCell;
}
    else if ([tableView isEqual:self.listTableView2]) {
    
    static NSString *CellIdentifier2 = @"NewCell2";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2]; }
        //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.textLabel.text = [tableData3 objectAtIndex:indexPath.row];
    myCell.textLabel.font = [UIFont systemFontOfSize:8.0];
   [myCell.textLabel setTextColor:[UIColor darkGrayColor]];
    myCell.detailTextLabel.text = [tableData2 objectAtIndex:indexPath.row];
    myCell.detailTextLabel.font = [UIFont boldSystemFontOfSize:8.0];
   [myCell.detailTextLabel setTextColor:[UIColor blackColor]];

        //draw red vertical line
    UIView *vertLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, myCell.frame.size.height)];
    vertLine.backgroundColor = [UIColor redColor];
    [myCell.contentView addSubview:vertLine];
        
    return myCell;
}
    else if ([tableView isEqual:self.newsTableView]) {
        
    static NSString *CellIdentifier1 = @"detailCell";
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1 forIndexPath:indexPath];
    
    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1]; }
     //need to reload table (void)viewDidAppear to get fonts to change but its annoying
    myCell.separatorInset = UIEdgeInsetsMake(0.0f, myCell.frame.size.width, 0.0f, 400.0f);
    myCell.leadtitleLabel.text = self.lnewsTitle;
    myCell.leadtitleLabel.numberOfLines = 0;
    myCell.leadtitleLabel.font = [UIFont systemFontOfSize:12.0];
   [myCell.leadtitleLabel setTextColor:[UIColor darkGrayColor]];
    myCell.leadsubtitleLabel.text = @"Yahoo Finance 2 hrs ago";
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
                                 message:@"Enter new data entry"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:ok];
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
       detailVC.mapzip = self.zip;
   }
}

@end
