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
     self.edgesForExtendedLayout = UIRectEdgeNone; //fi
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    // self.listTableView.tableHeaderView = view; //makes header move with tablecell

#pragma mark BarButtons
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateData:)];
    NSArray *actionButtonItems = @[editItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
    [[UITextField appearance] setTintColor:CURSERCOLOR];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
     [self.salesman becomeFirstResponder];
    if ([self.formStatus isEqual:@"New"]) {
        self.frm11 = @"Active";
        self.frm12 = @"";
        self.frm13 = @"";
        self.title = [NSString stringWithFormat:@" %@ %@", @"New", self.formController];
      } else
        self.title = [NSString stringWithFormat:@" %@ %@", @"Edit", self.formController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeSwitch:(id)sender {
    
    if([sender isOn]) {
        self.frm11 = @"Active";
       // NSLog(@"Switch is ON");
    } else {
        self.frm11 = @"";
       // NSLog(@"Switch is OFF");
    }
       [self.listTableView reloadData];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_formStatus isEqual:@"New"])
    return 2;
    else
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, 175, 30)];
    UIImageView *activeImage = [[UIImageView alloc]initWithFrame:CGRectMake(130, 10, 18, 22)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [theSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        if ([self.frm11 isEqual:@"Active"]) {
             [theSwitch setOn:YES];
              self.active = self.frm11;
              activeImage.image = [UIImage imageNamed:ACTIVEBUTTONYES];
              myCell.textLabel.text = @"Active";
            } else {
             [theSwitch setOn:NO];
              self.active = @"";
              activeImage.image = [UIImage imageNamed:ACTIVEBUTTONNO];
              myCell.textLabel.text = @"Inactive";
            }
        
         activeImage.contentMode = UIViewContentModeScaleAspectFit;
        [myCell addSubview:theSwitch];
         myCell.accessoryView = theSwitch;
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
        
         if ([_formController isEqual:TNAME8]) {
             self.salesman.placeholder = @"Salesman";
             myCell.textLabel.text = @"Salesman"; }
        
        else if ([_formController isEqual:TNAME6]) {
            self.salesman.placeholder = @"Product";
            myCell.textLabel.text = @"Product";}
        
        else if ([_formController isEqual:TNAME5]) {
            self.salesman.placeholder = @"Advertiser";
            myCell.textLabel.text = @"Advertiser";}
        
        else if ([_formController isEqual:TNAME7]) {
            self.salesman.placeholder = @"Description";
            myCell.textLabel.text = @"Description";}
        
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
        
        if ([_formController isEqual:TNAME8]) {
         self.salesNo.placeholder = @"SalesNo";
            myCell.textLabel.text = @"SalesNo"; }
        
        else if ([_formController isEqual:TNAME6]) {
            self.salesNo.placeholder = @"ProductNo";
            myCell.textLabel.text = @"ProductNo";}
        
        else if ([_formController isEqual:TNAME5]) {
            self.salesNo.placeholder = @"AdNo";
            myCell.textLabel.text = @"AdNo";}
        
        else if ([_formController isEqual:TNAME7]) {
            self.salesNo.placeholder = @"JobNo";
            myCell.textLabel.text = @"JobNo";}
        
        [myCell.contentView addSubview:self.salesNo];
    }

    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}
//-----------------Makes Form Scroll to Bottom--------------------------------
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
#pragma mark - TableView Header/Footer
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section{
    NSString *headerTitle;
    if (section == 0)
        headerTitle = HEADERTITLE;
    
    return headerTitle;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section{
    NSString *footerTitle;
    if (section == 0)
        footerTitle = FOOTERTITLE;

    return footerTitle;
}
//---------------------------------------------------

#pragma mark - Parse Data
- (void)parseData {
    /*
     if ([_formController isEqual: @"Salesman"]) {
     
     PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
     query.cachePolicy = kPFCACHEPOLICY;
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
     query21.cachePolicy = kPFCACHEPOLICY;
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
     query31.cachePolicy = kPFCACHEPOLICY;
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
     query41.cachePolicy = kPFCACHEPOLICY;
     [query41 selectKeys:@[@"ProductNo"]];
     [query41 selectKeys:@[@"Products"]];
     [query41 orderByDescending:@"Products"];
     [query41 whereKey:@"Active" containsString:@"Active"];
     [query41 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     prodArray = [[NSMutableArray alloc]initWithArray:objects];
     }];
     } */
}

#pragma mark - New Data
-(void)updateData:(id)sender {
    
    if ([_formStatus isEqual:@"New"]) {
        
    if ([_formController isEqual:TNAME8]) {
        
        NSString *_salesman = self.salesman.text;
        NSString *_active = self.active; //@"Active";
        
        NSString *rawStr = [NSString stringWithFormat:SAVESALEFIELD, SAVESALEFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:SAVESALEURL];
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
    else if ([_formController isEqual:TNAME7]) {
        
        NSString *_description = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:SAVEJOBFIELD, SAVEJOBFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:SAVEJOBURL];
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
    else if ([_formController isEqual:TNAME6]) {
        
        NSString *_product = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:SAVEPRODFIELD, SAVEPRODFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:SAVEPRODURL];
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
    else if ([_formController isEqual:TNAME5]) {
        
        NSString *_advertiser = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:SAVEADFIELD, SAVEADFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:SAVEADURL];
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
        
} else if ([_formStatus isEqual:@"Edit"]) {
    
    if ([_formController isEqual:TNAME8]) {
        
        NSString *_salesNo = self.salesNo.text;
        NSString *_salesman = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:EDITSALEFIELD, EDITSALEFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:EDITSALEURL];
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
    else if ([_formController isEqual:TNAME7]) {
        
        NSString *_jobNo = self.salesNo.text;
        NSString *_description = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:EDITJOBFIELD, EDITJOBFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:EDITJOBURL];
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
    else if ([_formController isEqual:TNAME6]) {
        
        NSString *_productNo = self.salesNo.text;
        NSString *_products = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:EDITPRODFIELD, EDITPRODFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:EDITPRODURL];
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
    else if ([_formController isEqual:TNAME5]) {
        
        NSString *_adNo = self.salesNo.text;
        NSString *_advertiser = self.salesman.text;
        NSString *_active = self.active;
        
        NSString *rawStr = [NSString stringWithFormat:EDITADFIELD, EDITADFIELD1];
        NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:EDITADURL];
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
}
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

@end
