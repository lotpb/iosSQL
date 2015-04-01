//
//  NewDataDetail.m
//  MySQL
//
//  Created by Peter Balsamo on 2/10/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NewDataDetail.h"

@interface NewDataDetail ()
{
    NSMutableArray *salesArray, *prodArray, *jobArray, *adArray;
}
@end

@implementation NewDataDetail
@synthesize salesNo, salesman, active;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    // self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //   self.listTableView.tableHeaderView = view; //makes header move with tablecell
    
/*
    if ([_formController isEqual: @"Salesman"]) {
     
     PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     [query selectKeys:@[@"SalesNo"]];
     [query selectKeys:@[@"Salesman"]];
     [query orderByDescending:@"SalesNo"];
     [query whereKey:@"Active" containsString:@"Active"];
     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     salesArray = [[NSMutableArray alloc]initWithArray:objects];
     }];
    }
    
     if ([_formController isEqual: @"Jobs"]) {
         
         PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
         query21.cachePolicy = kPFCachePolicyCacheThenNetwork;
         [query21 selectKeys:@[@"JobNo"]];
         [query21 selectKeys:@[@"Description"]];
         [query21 orderByDescending:@"Description"];
         [query21 whereKey:@"Active" containsString:@"Active"];
         [query21 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         jobArray = [[NSMutableArray alloc]initWithArray:objects];
         }];
     }
    if ([_formController isEqual: @"Advertising"]) {
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Advertising"];
        query31.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query31 selectKeys:@[@"AdNo"]];
        [query31 selectKeys:@[@"Advertiser"]];
        [query31 orderByDescending:@"Advertiser"];
        [query31 whereKey:@"Active" containsString:@"Active"];
        [query31 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         adArray = [[NSMutableArray alloc]initWithArray:objects];
        }];
    }
    
    if ([_formController isEqual: @"Products"]) {
        
        PFQuery *query41 = [PFQuery queryWithClassName:@"Product"];
        query41.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query41 selectKeys:@[@"ProductNo"]];
        [query41 selectKeys:@[@"Products"]];
        [query41 orderByDescending:@"Products"];
        [query41 whereKey:@"Active" containsString:@"Active"];
        [query41 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         prodArray = [[NSMutableArray alloc]initWithArray:objects];
        }];
    } */
    
    //self.salesNo.text = nil;
    //self.active.text = nil;


   // if (![self.formStatus isEqual:@"Edit"])
   //      self.frm11 = @"Active";
   // else self.active.text = self.frm11;
    
#pragma mark BarButtons
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
    NSArray *actionButtonItems = @[editItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
    [[UITextField appearance] setTintColor:CURSERCOLOR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title = [NSString stringWithFormat:@" %@ %@", @"Edit", self.formController];
    [self.salesman becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Button
-(IBAction)like:(id)sender{
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ([self.active isEqual:@"1"] ) {
        self.following.text = @"Follow";
     //   self.active = @"0";
        [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
    } else {
        self.following.text = @"Following";
    //    self.active = @"1";
        [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal]; }
} */


#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 1;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, 175, 30)];
    UIImageView *activeImage = [[UIImageView alloc]initWithFrame:CGRectMake(130, 10, 18, 22)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        if ( [self.frm11 isEqual:@"Active"] )
             [theSwitch setOn:YES];
        else [theSwitch setOn:NO];
        [myCell addSubview:theSwitch];
         myCell.accessoryView = theSwitch;
 
        if ([self.frm11 isEqual:@"Active"] ) {
            self.active.text = self.frm11;
            activeImage.image = [UIImage imageNamed:@"iosStar.png"];
            myCell.textLabel.text = @"Active";
          } else {
            self.active.text = @"";
            activeImage.image = [UIImage imageNamed:@"iosStarNA.png"];
            myCell.textLabel.text = @"Inactive"; }
      /*
        if (![self.formStatus isEqual:@"Edit"] ) {
            self.active.text = @"Active";
            activeImage.image = [UIImage imageNamed:@"iosStar.png"];
            myCell.textLabel.text = @"Active";
        }  */

         activeImage.contentMode = UIViewContentModeScaleAspectFit;
        [myCell.contentView addSubview:activeImage];
        
    } else if (indexPath.row == 1){
        
         self.salesman = textframe;
        [self.salesman setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm13 isEqual:[NSNull null]])
             self.salesman.text = @"";
        else self.salesman.text = self.frm13;
         self.salesman.tag = 0;
         self.salesman.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.salesman setClearButtonMode:UITextFieldViewModeWhileEditing];
        
         if ([_formController isEqual: @"Salesman"]) {
         self.salesman.placeholder = @"Salesman";
             myCell.textLabel.text = @"Salesman"; }
        
        else if ([_formController isEqual: @"Products"]) {
            self.salesman.placeholder = @"Product";
            myCell.textLabel.text = @"Product";}
        
        else if ([_formController isEqual: @"Advertising"]) {
            self.salesman.placeholder = @"Advertiser";
            myCell.textLabel.text = @"Advertiser";}
        
        else if ([_formController isEqual: @"Jobs"]) {
            self.salesman.placeholder = @"Description";
            myCell.textLabel.text = @"Description";}
        // myCell.accessoryView = self.salesman;
        [myCell.contentView addSubview:self.salesman];
        
    } else if (indexPath.row == 2){
        
         self.salesNo = textframe;
        [self.salesNo setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm12 isEqual:[NSNull null]])
             self.salesNo.text = @"";
        else self.salesNo.text = self.frm12;
             self.salesNo.tag = 0;
             self.salesNo.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.salesNo setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        if ([_formController isEqual: @"Salesman"]) {
         self.salesNo.placeholder = @"SalesNo";
            myCell.textLabel.text = @"SalesNo"; }
        
        else if ([_formController isEqual: @"Products"]) {
            self.salesNo.placeholder = @"ProductNo";
            myCell.textLabel.text = @"ProductNo";}
        
        else if ([_formController isEqual: @"Advertising"]) {
            self.salesNo.placeholder = @"AdNo";
            myCell.textLabel.text = @"AdNo";}
        
        else if ([_formController isEqual: @"Jobs"]) {
            self.salesNo.placeholder = @"JobNo";
            myCell.textLabel.text = @"JobNo";}
        
        [myCell.contentView addSubview:self.salesNo];
    }

    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
//-------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

        // Scroll the table to the bottom if the table view's current offset is beyond the maximum
        // allowable offset sot that it does not leave too much white space at the bottom.
        NSInteger numRows = [self tableView:tableView numberOfRowsInSection:2];
        CGFloat maxOffset = numRows * ROW_HEIGHT - self.view.frame.size.height + 36.0f;
        
        if (self.listTableView.contentOffset.y > maxOffset) {
            [self.listTableView setContentOffset:CGPointMake(0.0f, maxOffset) animated:YES];
        }
}
//---------------------------------------------------

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section{
    NSString *headerTitle;
    if (section == 0) {
        headerTitle = @"Info";
    } else {
        headerTitle = @"Section 2 Header";
    }
    return headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section{
    NSString *footerTitle;
    if (section == 0) {
        footerTitle = @"MySQL! :)";
    } else {
        footerTitle = @"Section 2 Footer";
    }
    return footerTitle;
}

#pragma mark - Edit Data
-(void)updateLeads:(id)sender {
    if ([_formController isEqual: @"Salesman"]) {
        
     // NSString *_salesNo = self.salesNo.text;
        NSString *_salesman = self.salesman.text;
        NSString *_active = self.active.text;
        
        NSString *rawStr = [NSString stringWithFormat:@"_salesman=%@&&_active=%@&", _salesman, _active];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveSalesman.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
        NSLog(@"%@", responseString);
        NSString *success = @"success";
        [success dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([_formController isEqual: @"Jobs"]) {
        
        // NSString *_jobNo = self.jobNo.text;
        NSString *_description = self.salesman.text;
        NSString *_active = self.active.text;
        
        NSString *rawStr = [NSString stringWithFormat:@"_description=%@&&_active=%@&", _description, _active];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveJob.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
        NSLog(@"%@", responseString);
        NSString *success = @"success";
        [success dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([_formController isEqual: @"Products"]) {
        
        // NSString *_productNo = self.salesNo.text;
        NSString *_product = self.salesman.text;
        NSString *_active = self.active.text;
        
        NSString *rawStr = [NSString stringWithFormat:@"_product=%@&&_active=%@&", _product, _active];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveProduct.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
        NSLog(@"%@", responseString);
        NSString *success = @"success";
        [success dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([_formController isEqual: @"Advertising"]) {
        
        // NSString *_adNo = self.salesNo.text;
        NSString *_advertiser = self.salesman.text;
        NSString *_active = self.active.text;
        
        NSString *rawStr = [NSString stringWithFormat:@"_advertiser=%@&&_active=%@&", _advertiser, _active];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveAdvertising.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:data];
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
        NSLog(@"%@", responseString);
        NSString *success = @"success";
        [success dataUsingEncoding:NSUTF8StringEncoding];
    }
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

@end
