//
//  VendorDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/28/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "VendorDetailController.h"
#import "CustomTableViewCell.h"

@interface VendorDetailController ()

@end

@implementation VendorDetailController
{
    NSArray *tableData, *tableData2, *tableData3, *tableData4;
}
@synthesize vendorNo, vendorName, address, city, state, zip, email, department, office, comments, manager, profession, assistant, phone, active, phone1, phone2, phone3, webpage;

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
    self.title = self.selectedLocation.vendorName;
    self.listTableView.rowHeight = 25;
    self.listTableView2.rowHeight = 25;
    self.newsTableView.estimatedRowHeight = 120.0;
    self.newsTableView.rowHeight = UITableViewAutomaticDimension;
    self.comments.hidden = YES;
    NSString *phoneitem = self.selectedLocation.phone;
    NSString *phoneitem1 = self.selectedLocation.phone1;
    NSString *phoneitem2 = self.selectedLocation.phone2;
    NSString *phoneitem3 = self.selectedLocation.phone3;
    NSString *emailitem = self.selectedLocation.email;
    NSString *departmentitem = self.selectedLocation.department;
    NSString *officeitem = self.selectedLocation.office;
    NSString *manageritem = self.selectedLocation.manager;
    NSString *assistantitem = self.selectedLocation.assistant;
    NSString *professionitem = self.selectedLocation.profession;
    
    if ( ( ![self.selectedLocation.address isEqual:[NSNull null]] ) && ( [self.selectedLocation.address length] != 0 ) ) {self.address.text = self.selectedLocation.address;
    } else { self.address.text = @"Address"; }
    
    if ( ( ![self.selectedLocation.city isEqual:[NSNull null]] ) && ( [self.selectedLocation.city length] != 0 ) ) {self.city.text = self.selectedLocation.city;
    } else { self.city.text = @"City"; }
    
    if ( ( ![self.selectedLocation.state isEqual:[NSNull null]] ) && ( [self.selectedLocation.state length] != 0 ) ) {self.state = self.selectedLocation.state;
    } else { self.state = @"State"; }
    
    if ( ( ![self.selectedLocation.zip isEqual:[NSNull null]] ) && ( [self.selectedLocation.zip length] != 0 ) ) {self.zip = self.selectedLocation.zip;
    } else { self.zip = @"Zip"; }

    if ( ( ![self.selectedLocation.phone isEqual:[NSNull null]] ) && ( [self.selectedLocation.phone length] != 0 ) ) {phoneitem = self.selectedLocation.phone;
    } else { phoneitem = @"No Phone"; }
 
    if ( ( ![self.selectedLocation.phone1 isEqual:[NSNull null]] ) && ( [self.selectedLocation.phone1 length] != 0 ) ) {phoneitem1 = self.selectedLocation.phone1;
    } else { phoneitem1 = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.phone2 isEqual:[NSNull null]] ) && ( [self.selectedLocation.phone2 length] != 0 ) ) {phoneitem2 = self.selectedLocation.phone2;
    } else { phoneitem2 = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.phone3 isEqual:[NSNull null]] ) && ( [self.selectedLocation.phone3 length] != 0 ) ) {phoneitem3 = self.selectedLocation.phone3;
    } else { phoneitem3 = @"No Phone"; }
    
    if ( ( ![self.selectedLocation.email isEqual:[NSNull null]] ) && ( [self.selectedLocation.email length] != 0 ) ) {emailitem = self.selectedLocation.email;
    } else { emailitem = @"No Email"; }
    
    if ( ( ![self.selectedLocation.department isEqual:[NSNull null]] ) && ( [self.selectedLocation.department length] != 0 ) ) {departmentitem = self.selectedLocation.department;
    } else { departmentitem = @"No Department"; }
    
    if ( ( ![self.selectedLocation.office isEqual:[NSNull null]] ) && ( [self.selectedLocation.office length] != 0 ) ) {officeitem = self.selectedLocation.office;
    } else { officeitem = @"No Office"; }
    
    if ( ( ![self.selectedLocation.manager isEqual:[NSNull null]] ) && ( [self.selectedLocation.manager length] != 0 ) ) {manageritem = self.selectedLocation.manager;
    } else { manageritem = @"No Manager"; }
    
    if ( ( ![self.selectedLocation.profession isEqual:[NSNull null]] ) && ( [self.selectedLocation.profession length] != 0 ) ) {professionitem = self.selectedLocation.profession;
    } else { professionitem = @"No Profession"; }
    
    if ( ( ![self.selectedLocation.assistant isEqual:[NSNull null]] ) && ( [self.selectedLocation.assistant length] != 0 ) ) {assistantitem = self.selectedLocation.assistant;
    } else { assistantitem = @"No Assistant"; }
    
    if ( ( ![self.selectedLocation.webpage isEqual:[NSNull null]] ) && ( [self.selectedLocation.webpage length] != 0 ) ) {self.webpage.text = self.selectedLocation.webpage;
    } else { self.webpage.text = @"www.none.com"; }
    
    if ( ( ![self.selectedLocation.comments isEqual:[NSNull null]] ) && ( [self.selectedLocation.comments length] != 0 ) ) {self.comments.text = self.selectedLocation.comments;
    } else { self.comments.text = @"No Comments"; }
    
    self.vendorNo.text = self.selectedLocation.vendorNo;
    self.vendorName.text = self.selectedLocation.vendorName;
    self.city.text = [NSString stringWithFormat:@"%@ %@ %@",self.city.text, self.state, self.zip];
    self.professionlabel.text = professionitem;
    
    ///below must be on bottom from above
    tableData = [NSArray arrayWithObjects:phoneitem, phoneitem1, phoneitem2, phoneitem3, assistantitem, nil];
    
    tableData2 = [NSArray arrayWithObjects:emailitem, departmentitem, officeitem, manageritem, professionitem, nil];
    
    tableData3 = [NSArray arrayWithObjects:@"Email", @"Department", @"Office", @"Manager", @"Profession", nil];
    
    tableData4 = [NSArray arrayWithObjects:@"Phone", @"Phone1", @"Phone2", @"Phone3", @"Assistant", nil];

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
} else { [self.mySwitch setOn:NO]; }
    
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
    [self performSegueWithIdentifier:@"mapVendSegue"sender:self];
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
        myCell.leadtitleLabel.text = @"Business News Peter Balsamo Appointed to United's Board of Directors";
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
    NSString * message = self.selectedLocation.vendorNo;
    NSString * message1 = self.selectedLocation.vendorName;
    NSString * message2 = self.selectedLocation.comments;
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, message2, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapVendSegue"]) {
        MapViewController *detailVC = segue.destinationViewController;
        detailVC.mapaddress = self.selectedLocation.address;
        detailVC.mapcity = self.selectedLocation.city;
        detailVC.mapstate = self.selectedLocation.state;
        detailVC.mapzip = self.selectedLocation.zip;
    }
}

@end
