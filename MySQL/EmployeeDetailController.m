//
//  EmployeeDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "EmployeeDetailController.h"
#import "CustomTableViewCell.h"

@interface EmployeeDetailController ()

@end

@implementation EmployeeDetailController
{
    NSArray *tableData, *tableData2, *tableData3, *tableData4;
}
@synthesize employeeNo, first, middle, lastname, city, street, state, zip, phone, homephone, workphone, cellphone, email, company, social, country, titleEmploy, manager, comments, active;

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
    self.newsTableView.estimatedRowHeight = 120.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
   // self.comments.hidden = YES;
    
    NSString *firstItem, *middleItem, *lastnameItem, *streetItem, *cityItem, *stateItem, *ziptItem, *homephoneItem, *workphoneItem, *cellItem, *emailItem, *departmentItem, *countryItem, *managerItem, *socialItem, *titleItem, *companyItem, *commentsItem;

  //  if  ( [self.selectedLocation.first isEqual:[NSNull null]] )  {
  //      firstItem = @""; }
    
    if ( ( ![self.selectedLocation.first isEqual:[NSNull null]] ) && ( [self.selectedLocation.first length] != 0 ) ) {firstItem = self.selectedLocation.first;
    } else { firstItem = @""; }
    
    if ( ( ![self.selectedLocation.middle isEqual:[NSNull null]] ) && ( [self.selectedLocation.middle length] != 0 ) ) {middleItem = self.selectedLocation.middle;
    } else { middleItem = @""; }
    
    if ( ( ![self.selectedLocation.lastname isEqual:[NSNull null]] ) && ( [self.selectedLocation.lastname length] != 0 ) ) {lastnameItem = self.selectedLocation.lastname;
    } else { lastnameItem = @""; }
    
    if ( ( ![self.selectedLocation.company isEqual:[NSNull null]] ) && ( [self.selectedLocation.company length] != 0 ) ) {companyItem = self.selectedLocation.company;
    } else { companyItem = @""; }
   
    if ( ( ![self.selectedLocation.street isEqual:[NSNull null]] ) && ( [self.selectedLocation.street length] != 0 ) ) {streetItem = self.selectedLocation.street;
    } else { streetItem = @"Address"; }
    
    if ( ( ![self.selectedLocation.city isEqual:[NSNull null]] ) && ( [self.selectedLocation.city length] != 0 ) ) {cityItem = self.selectedLocation.city;
    } else { cityItem = @"City"; }
    
    if ( ( ![self.selectedLocation.state isEqual:[NSNull null]] ) && ( [self.selectedLocation.state length] != 0 ) ) {stateItem = self.selectedLocation.state;
    } else { stateItem = @"State"; }
    
    if ( ( ![self.selectedLocation.zip isEqual:[NSNull null]] ) && ( [self.selectedLocation.zip length] != 0 ) ) {ziptItem = self.selectedLocation.zip;
    } else { ziptItem = @"Zip"; }
    
    if ( ( ![self.selectedLocation.homephone isEqual:[NSNull null]] ) && ( [self.selectedLocation.homephone length] != 0 ) ) {homephoneItem = self.selectedLocation.homephone;
    } else { homephoneItem = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.workphone isEqual:[NSNull null]] ) && ( [self.selectedLocation.workphone length] != 0 ) ) {workphoneItem = self.selectedLocation.workphone;
    } else { workphoneItem = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.cellphone isEqual:[NSNull null]] ) && ( [self.selectedLocation.cellphone length] != 0 ) ) {cellItem = self.selectedLocation.cellphone;
    } else { cellItem = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.titleEmploy isEqual:[NSNull null]] ) && ( [self.selectedLocation.titleEmploy length] != 0 ) ) {titleItem = self.selectedLocation.titleEmploy;
    } else { titleItem = @"None"; }
    
    if ( ( ![self.selectedLocation.email isEqual:[NSNull null]] ) && ( [self.selectedLocation.email length] != 0 ) ) {emailItem = self.selectedLocation.email;
    } else { emailItem = @"No Email"; }
    
    if ( ( ![self.selectedLocation.department isEqual:[NSNull null]] ) && ( [self.selectedLocation.department length] != 0 ) ) {departmentItem = self.selectedLocation.department;
    } else { departmentItem = @"None"; }
  
    if ( ( ![self.selectedLocation.manager isEqual:[NSNull null]] ) && ( [self.selectedLocation.manager length] != 0 ) ) {managerItem = self.selectedLocation.manager;
    } else { managerItem = @"None"; }
    
    if ( ( ![self.selectedLocation.social isEqual:[NSNull null]] ) && ( [self.selectedLocation.social length] != 0 ) ) {socialItem = self.selectedLocation.social;
    } else { socialItem = @"None"; }
   
    if ( ( ![self.selectedLocation.country isEqual:[NSNull null]] ) && ( [self.selectedLocation.country length] != 0 ) ) {countryItem = self.selectedLocation.country;
    } else { countryItem = @"None"; }
    
    if ( ( ![self.selectedLocation.comments isEqual:[NSNull null]] ) && ( [self.selectedLocation.comments length] != 0 ) ) {commentsItem = self.selectedLocation.comments;
    } else { commentsItem = @"No Comments"; }
    
    self.title = [NSString stringWithFormat:@"%@ %@ %@",firstItem,lastnameItem, companyItem];
    self.employeeNo.text = self.selectedLocation.employeeNo;
    self.lastnametext.text = [NSString stringWithFormat:@"%@ %@ %@",firstItem,lastnameItem, companyItem];
    self.streettext.text = streetItem;
    self.citytext.text = [NSString stringWithFormat:@"%@ %@ %@",cityItem, stateItem, ziptItem];
    self.titlelabel.text = titleItem;
    self.emaillabel.text = emailItem;
    self.comments = commentsItem;
    
    ///below must be on bottom from above
   tableData = [NSArray arrayWithObjects:homephoneItem, workphoneItem, cellItem, socialItem, emailItem, nil];
    
    tableData2 = [NSArray arrayWithObjects:emailItem, departmentItem, titleItem, managerItem, countryItem, nil];
    
    tableData3 = [NSArray arrayWithObjects:@"Email", @"Department", @"Title", @"manager", @"Country", nil];
    
    tableData4 = [NSArray arrayWithObjects:@"Home Phone", @"Work Phone", @"Cell Phone", @"Social security", @"Email", nil];
    
#pragma mark  Bar Button
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(mapButton:)];
    NSArray *actionButtonItems = @[mapItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark  Following Button
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.selectedLocation.active isEqual:@"1"] )
    {[self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
        self.following.text = @"Following";
    } else { [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
        self.following.text = @"Follow";}
    
#pragma mark  Active Switch
    if ( [self.selectedLocation.active isEqual:@"1"] )
    {[self.mySwitch setOn:YES];
    } else { [self.mySwitch setOn:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData]; [self.listTableView2 reloadData]; [self.newsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) viewDidLayoutSubviews { //added to fix the left side margin
    [super viewDidLayoutSubviews];
    self.listTableView2.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - Buttons
- (void)mapButton:(id)sender{
    [self performSegueWithIdentifier:@"mapEmploySegue"sender:self];
}

#pragma mark - TableView two table cell
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
#pragma mark TableView Delegate two table cell
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
        myCell.employtitleLabel.text = @"Employee News Peter Balsamo Appointed to United's Board of Directors";
        myCell.employtitleLabel.font = [UIFont systemFontOfSize:12.0];
        [myCell.employtitleLabel setTextColor:[UIColor darkGrayColor]];
        myCell.employsubtitleLabel.text = @"Yahoo Finance 2 hrs ago";
        myCell.employsubtitleLabel.font = [UIFont systemFontOfSize:8.0];
        [myCell.employsubtitleLabel setTextColor:[UIColor grayColor]];
        myCell.employreadmore.text = @"Read more";
        myCell.employreadmore.font = [UIFont systemFontOfSize:8.0];
        myCell.employnews.text = self.comments;
        myCell.employnews.font = [UIFont boldSystemFontOfSize:8.0];
        [myCell.employnews setTextColor:[UIColor darkGrayColor]];
        
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
    NSString * message = self.selectedLocation.employeeNo;
    NSString * message1 = self.selectedLocation.lastname;
    NSString * message2 = self.selectedLocation.comments;
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, message2, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapEmploySegue"]) {
        MapViewController *detailVC = segue.destinationViewController;
        detailVC.mapaddress = self.selectedLocation.street;
        detailVC.mapcity = self.selectedLocation.city;
        detailVC.mapstate = self.selectedLocation.state;
        detailVC.mapzip = self.selectedLocation.zip;
    }
}

@end
