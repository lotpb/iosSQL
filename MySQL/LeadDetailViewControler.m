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
@synthesize name, leadNo, address, date, city, state, zip, salesman, comments, amount, phone, email, aptdate, jobNo, first, spouse, active, callback, adNo, time, photo;

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
    self.title = self.selectedLocation.name;
    self.listTableView.rowHeight = 25;
    self.listTableView2.rowHeight = 25;
   // self.newsTableView.rowHeight = 120;
    self.newsTableView.estimatedRowHeight = 120.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.comments.hidden = YES; self.email.hidden = YES;
    self.first.hidden = YES; self.spouse.hidden = YES;

#pragma mark Bar Button
   // UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(mapButton:)];
    NSArray *actionButtonItems = @[mapItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
self.leadNo.text = self.selectedLocation.leadNo;
self.date.text = self.selectedLocation.date;
self.name.text = self.selectedLocation.name;
self.address.text = self.selectedLocation.address;
self.city.text = [NSString stringWithFormat:@"%@ %@ %@",self.selectedLocation.city,self.selectedLocation.state, self.selectedLocation.zip];
self.amount.text = self.selectedLocation.amount;
self.callback.text = self.selectedLocation.callback;
    
/*
UIImage *buttonImage3 = [UIImage imageNamed:@"IMG_1133.jpg"];
if ( ( [self.selectedLocation.photo isEqual:[NSNull null]] ) && ( [self.selectedLocation.photo length] != 0 ) ) {
    [self.photoImage setImage:buttonImage3];
} else { [self.photoImage setImage:nil]; } */
    
if ( ( ![self.selectedLocation.first isEqual:[NSNull null]] ) && ( [self.selectedLocation.first length] != 0 ) ) {self.first.text = self.selectedLocation.first;
} else { self.first.text = @"No Name"; }
    
if ( ( ![self.selectedLocation.spouse isEqual:[NSNull null]] ) && ( [self.selectedLocation.spouse length] != 0 ) ) {self.spouse.text = self.selectedLocation.spouse;
} else { self.spouse.text = @"No Spouse"; }
    
if ( ( ![self.selectedLocation.email isEqual:[NSNull null]] ) && ( [self.selectedLocation.email length] != 0 ) ) {self.email.text = self.selectedLocation.email;
} else { self.email.text = @"No Email"; }
    
if ( ( ![self.selectedLocation.comments isEqual:[NSNull null]] ) && ( [self.selectedLocation.comments length] != 0 ) ) {self.comments.text = self.selectedLocation.comments;
} else { self.comments.text = @"No Comments"; }
    
if ( ( ![self.selectedLocation.time isEqual:[NSNull null]] ) && ( [self.selectedLocation.time length] != 0 ) ) {self.time.text = self.selectedLocation.time;
} else { self.time.text = @"No Time"; }
    
///below must be on bottom from above
tableData = [NSArray arrayWithObjects:self.selectedLocation.callback,self.selectedLocation.phone, self.first.text, self.spouse.text, self.email.text, nil];
    
tableData2 = [NSArray arrayWithObjects:self.selectedLocation.aptdate, self.selectedLocation.salesman, self.selectedLocation.jobNo, self.selectedLocation.adNo,self.selectedLocation.time, nil];
    
tableData3 = [NSArray arrayWithObjects:@"Apt Date", @"Salesman", @"Description", @"Advertise", @"Time", nil];
    
tableData4 = [NSArray arrayWithObjects:@"Call Back",@"Phone", @"First", @"Spouse", @"Email", nil];
    
    //add Following button
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.selectedLocation.active isEqual:@"1"] )
    {[self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
      self.following.text = @"Following";
    } else { [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
      self.following.text = @"Follow";}
    //add callback label
    if ( [self.selectedLocation.callback isEqual:@"Sold"] )
    {[self.mySwitch setOn:YES];
    } else { [self.mySwitch setOn:NO]; }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData]; [self.listTableView2 reloadData]; [self.newsTableView reloadData];
}

- (void) viewDidLayoutSubviews { //added to fix the left side margin
    [super viewDidLayoutSubviews];
    self.listTableView2.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - Buttons
- (void)mapButton:(id)sender{
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
    myCell.leadtitleLabel.text = @"Customer News Peter Balsamo Appointed to United's Board of Directors";
    myCell.leadtitleLabel.font = [UIFont systemFontOfSize:12.0];
   [myCell.leadtitleLabel setTextColor:[UIColor darkGrayColor]];
    myCell.leadsubtitleLabel.text = @"Yahoo Finance 2 hrs ago";
    myCell.leadsubtitleLabel.font = [UIFont systemFontOfSize:8.0];
   [myCell.leadsubtitleLabel setTextColor:[UIColor grayColor]];
    myCell.leadreadmore.text = @"Read more";
    myCell.leadreadmore.font = [UIFont systemFontOfSize:8.0];
    myCell.leadnews.text = self.comments.text;
    myCell.leadnews.font = [UIFont boldSystemFontOfSize:8.0];
   [myCell.leadnews setTextColor:[UIColor darkGrayColor]];
    //Social buttons - code below
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,85, 20, 20)];
    [faceBtn setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:faceBtn];
        
    UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40,85, 20, 20)];
    [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:twitBtn];
        
    UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(70,85, 20, 20)];
    [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
    [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:tumblrBtn];
        
    UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,85, 20, 20)];
    [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
    [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:yourBtn];
        
    //add dark line - code below
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, .7)];
    separatorLineView.backgroundColor = [UIColor grayColor];// you can also put image here
    [myCell.contentView addSubview:separatorLineView];

return myCell;
    } else {
      NSLog(@"I have no idea what's going on...");
      return nil;
    }
}

#pragma mark - Airdrop
- (void)share:(id)sender{
    NSString * message = self.selectedLocation.date;
    NSString * message1 = self.selectedLocation.name;
    NSString * message2 = self.selectedLocation.comments;
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
       detailVC.mapaddress = self.selectedLocation.address;
       detailVC.mapcity = self.selectedLocation.city;
       detailVC.mapstate = self.selectedLocation.state;
       detailVC.mapzip = self.selectedLocation.zip;
   }
}

@end
