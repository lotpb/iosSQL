//
//  NewData.m
//  MySQL
//
//  Created by Peter Balsamo on 1/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NewData.h"

@interface NewData () <LookupCityDelegate, LookupJobDelegate>
{
    NSMutableArray *salesArray, *callbackArray;
}

@end

@implementation NewData
@synthesize leadNo, active, date, first, last, company, address, city, state, zip, phone, aptDate, email, amount, spouse, callback, saleNo, jobNo, adNo, photo, comment;

- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   self.listTableView.dataSource = self;
 //   self.listTableView.delegate = self;
 //   self.listTableView.editing = YES;
 //   self.listTableView.allowsSelectionDuringEditing = YES;
   
    [self.listTableView reloadData];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"SalesNo"];
    [query whereKey:@"Active" containsString:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query1 selectKeys:@[@"Callback"]];
    [query1 orderByDescending:@"Callback"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callbackArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
          self.leadNo = self.leadNo;
    
    if  ( [self.frm11 isEqual:[NSNull null]] )
           self.first.text = @"";
      else self.first.text = self.frm11;
    
    if  ( [self.frm12 isEqual:[NSNull null]] )
           self.last.text = @"";
      else self.last.text = self.frm12;
    
    if ( [self.frm13 isEqual:[NSNull null]] )
          self.company.text = @"";
     else self.company.text = self.frm13;
    
    if  ( [self.frm14 isEqual:[NSNull null]] )
           self.address.text = @"";
      else self.address.text = self.frm14;
    
    if  ( [self.frm15 isEqual:[NSNull null]] )
           self.city.text = @"";
      else self.city.text = self.frm15;
    
    if  ( [self.frm16 isEqual:[NSNull null]] )
           self.state.text = @"";
      else self.state.text = self.frm16;
    
    if  ( [self.frm17 isEqual:[NSNull null]] )
           self.zip.text = @"";
      else self.zip.text = self.frm17;
    
    if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"])) {
        if (self.date.text.length == 0) {
            NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
            gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
            gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *dateString = [gmtDateFormatter stringFromDate:[NSDate date]];
            self.date.text = dateString; //frm18
            self.aptDate.text = dateString; } //frm19
    }
    
     if (self.frm20.length == 0)
         self.phone.text = @"(516)";
    else self.phone.text = self.frm20;
    
    if  ( [self.frm21 isEqual:[NSNull null]] )
           self.salesman.text = @"";
      else self.salesman.text = self.frm21;
    
    if  ( [self.frm22 isEqual:[NSNull null]] )
           self.jobName.text = @"";
      else self.jobName.text = self.frm22;
    
    if ( [self.frm23 isEqual:[NSNull null]] )
          self.adName.text = @"";
     else self.adName.text = self.frm23;
    
    if  ( [self.frm24 isEqual:[NSNull null]] )
           self.amount.text = @"";
      else self.amount.text = self.frm24;
    
    if  ( [self.frm25 isEqual:[NSNull null]] )
           self.email.text = @"";
      else self.email.text = self.frm25;
    
    if  ( [self.frm26 isEqual:[NSNull null]] )
           self.spouse.text = @"";
      else self.spouse.text = self.frm26;
    
    if ( [self.frm27 isEqual:[NSNull null]] )
          self.callback.text = @"";
     else self.callback.text = self.frm27;
    
    if  ( [self.frm28 isEqual:[NSNull null]] )
           self.comment.text = @"";
      else self.comment.text = self.frm28;
    
    if  ( [self.frm29 isEqual:[NSNull null]] )
           self.photo.text = @"";
      else self.photo.text = self.frm29;
    
    self.active = @"1"; //frm30
    
    if ([_formController isEqual: @"Customer"]) {
        self.company.placeholder = @"Contractor";
        self.adName.placeholder = @"ProductNo";
        self.callback.placeholder = @"Quan";
    } else if ([_formController isEqual: @"Vendor"]) {
        self.first.placeholder = @"Manager";
        self.last.placeholder = @"Webpage";
        self.date.placeholder = @"Profession";
        self.salesman.placeholder = @"Phone1";
        self.jobName.placeholder = @"phone2";
        self.adName.placeholder = @"phone3";
        self.amount.placeholder = @"Department";
        self.spouse.placeholder = @"Office";
        self.aptDate.placeholder = @"Assistant";
        self.callback.hidden = YES;//Field
    } else if ([_formController isEqual: @"Employee"]) {
        self.first.placeholder = @"First";
        self.last.placeholder = @"Last";
        self.date.placeholder = @"Country";
        self.aptDate.placeholder = @"Middle";
        self.salesman.placeholder = @"Work Phone";
        self.jobName.placeholder = @"Cell Phone";
        self.adName.placeholder = @"Social security";
        self.amount.placeholder = @"Department";
        self.spouse.placeholder = @"Title";
        self.callback.placeholder = @"Manager";
    }
    
    if ( ([_formController isEqual: @"Employee"]) || ([_formController isEqual: @"Vendor"]) ) {
        self.jobLookup.hidden = YES; //Button
        self.productLookup.hidden = YES; //Button
        self.saleNo.hidden = YES; //Field
        self.jobNo.hidden = YES; //Field
        self.adNo.hidden = YES; //Field
    }
    
    //add Following button
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.active isEqual:@"1"] ) {
         [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
          self.following.text = @"Following";
        } else {
         [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
          self.following.text = @"Follow";
    }
    
    self.aptDate.inputView = [self datePicker];
    self.salesman.inputView = [self customPicker:1];
    if ([_formController isEqual: @"Leads"])
        self.callback.inputView = [self customPicker:2];
    
#pragma mark Form Circle Image
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 8;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
#pragma mark BarButtons
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
    NSArray *actionButtonItems = @[saveItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[UITextView appearance] setTintColor:[UIColor grayColor]];
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title =  @"New Data";
    [self.first becomeFirstResponder];
    [self.listTableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - reload Form Data
- (void)viewDidAppear:(BOOL)animated
{
    [self loadFormData];
}

#pragma mark Load Form Data
-(void)loadFormData {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (first.text.length == 0)
        self.first.text = [prefs objectForKey:@"first"];
    if (last.text.length == 0)
        self.last.text = [prefs objectForKey:@"last"];
    if (address.text.length == 0)
        self.address.text = [prefs objectForKey:@"address"];
    if (city.text.length == 0)
        self.city.text = [prefs objectForKey:@"city"];
    if (state.text.length == 0)
        self.state.text = [prefs objectForKey:@"state"];
    if (zip.text.length == 0)
        self.zip.text = [prefs objectForKey:@"zip"];
    if (email.text.length == 0)
        self.email.text = [prefs objectForKey:@"email"];
    if (amount.text.length == 0)
        self.amount.text = [prefs objectForKey:@"amount"];
    if (spouse.text.length == 0)
        self.spouse.text = [prefs objectForKey:@"spouse"];
    if (_adName.text.length == 0)
        self.adName.text = [prefs objectForKey:@"adNo"];
    if (_salesman.text.length == 0)
        self.salesman.text = [prefs objectForKey:@"salesNo"];
    if (_jobName.text.length == 0)
        self.jobName.text = [prefs objectForKey:@"jobNo"];
    if (comment.text.length == 0)
        self.comment.text = [prefs objectForKey:@"comment"];
    if (phone.text.length == 0)
        self.phone.text = [prefs objectForKey:@"phone"];
    if (leadNo.length == 0)
        self.leadNo = [prefs objectForKey:@"leadNo"];
    if (callback.text.length == 0)
        self.callback.text = [prefs objectForKey:@"callback"];
    if (company.text.length == 0)
        self.company.text = [prefs objectForKey:@"company"];
}

#pragma mark Clear Form Data
- (IBAction)clearFormData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"address"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"state"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zip"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"amount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"spouse"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"salesNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jobNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"comment"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"leadNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adNo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"callback"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"company"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Save Form Data
- (IBAction)saveFormData
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(self.first.text.length > 0){
        NSString *firstString = self.first.text;
        [prefs setObject:firstString forKey:@"first"];}
    if(self.last.text.length > 0) {
        NSString *lastString = self.last.text;
        [prefs setObject:lastString forKey:@"last"];}
    if(self.address.text.length > 0){
        NSString *addressString = self.address.text;
        [prefs setObject:addressString forKey:@"address"];}
    if(self.city.text.length > 0){
        NSString *cityString = self.city.text;
        [prefs setObject:cityString forKey:@"city"];}
    if(self.state.text.length > 0) {
        NSString *stateString = self.state.text;
        [prefs setObject:stateString forKey:@"state"];}
    if(self.zip.text.length > 0) {
        NSString *zipString = self.zip.text;
        [prefs setObject:zipString forKey:@"zip"];}
    if(self.email.text.length > 0) {
        NSString *emailString = self.email.text;
        [prefs setObject:emailString forKey:@"email"];}
    if(self.amount.text.length > 0) {
        NSString *amountString = self.amount.text;
        [prefs setObject:amountString forKey:@"amount"];}
    if(self.spouse.text.length > 0) {
        NSString *spouseString = self.spouse.text;
        [prefs setObject:spouseString forKey:@"spouse"];}
    if(self.salesman.text.length > 0) {
        NSString *saleNoString = self.salesman.text;
        [prefs setObject:saleNoString forKey:@"salesNo"];}
    if(self.jobName.text.length > 0) {
        NSString *jobNoString = self.jobName.text;
        [prefs setObject:jobNoString forKey:@"jobNo"];}
    if(self.comment.text.length > 0) {
        NSString *commentString = self.comment.text;
        [prefs setObject:commentString forKey:@"comment"];}
    if(self.phone.text.length > 0) {
        NSString *phoneString = self.phone.text;
        [prefs setObject:phoneString forKey:@"phone"];}
    if(self.leadNo.length > 0) {
        NSString *leadNoString = self.leadNo;
        [prefs setObject:leadNoString forKey:@"leadNo"];}
    if(self.adName.text.length > 0){
        NSString *adNoString = self.adName.text;
        [prefs setObject:adNoString forKey:@"adNo"];}
    if(self.callback.text.length > 0){
        NSString *callbackString = self.callback.text;
        [prefs setObject:callbackString forKey:@"callback"];}
    if(self.company.text.length > 0){
        NSString *companyString = self.company.text;
        [prefs setObject:companyString forKey:@"company"];}
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - Button
-(IBAction)like:(id)sender{
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if([self.active isEqualToString: @"0"]) {
        self.following.text = @"Following";
        self.active = @"1";
       [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
      }else{
        self.following.text = @"Follow";
        self.active = @"0";
       [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];}
}

#pragma mark - LookupCity Data
- (void)cityFromController:(NSString *)passedData{
    self.city.text = passedData;
}

- (void)stateFromController:(NSString *)passedData{
    self.state.text = passedData;
}

- (void)zipFromController:(NSString *)passedData{
    self.zip.text = passedData;
}

- (void)jobFromController:(NSString *)passedData{
    self.jobNo.text = passedData;
}

- (void)jobNameFromController:(NSString *)passedData{
    self.jobName.text = passedData;
}

- (void)productFromController:(NSString *)passedData{
    self.adNo.text = passedData;
}

- (void)productNameFromController:(NSString *)passedData{
    self.adName.text = passedData;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"lookupCitySegue"]) {
        LookupCity *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupJobSegue"]) {
        LookupJob *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupProductSegue"]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}

#pragma mark Lookup City needed
-(IBAction)updateCity:(id)sender{
    [self performSegueWithIdentifier:@"lookupCitySegue"sender:self];
}
#pragma mark Lookup Job needed
-(IBAction)updateJob:(id)sender{
    [self performSegueWithIdentifier:@"lookupJobSegue"sender:self];
}

#pragma mark - Lookup Product needed
-(IBAction)updateProduct:(id)sender{
    [self performSegueWithIdentifier:@"lookupProductSegue"sender:self];
}

#pragma mark - View Picker
- (UIView *)customPicker:(NSUInteger)tag {
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = [UIColor orangeColor];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    picker.tag = tag;
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    //picker.Select(index, 0, true);
    //[picker selectRow:10 inComponent:0 animated:YES];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.translucent = NO;
    //toolbar.tintColor = nil;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    [picker addSubview:toolbar];
    [pickerView addSubview:picker];
    [picker reloadAllComponents];
    
    return pickerView;
}
// Picker done button not working
-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}
#pragma mark Date Picker
- (UIView *)datePicker {
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    datePicker.tag = 5;
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.timeZone = [NSTimeZone localTimeZone];
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:datePicker];
    
    return pickerView;
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.aptDate.text = [gmtDateFormatter stringFromDate:datePicker.date];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1)
        return 1;
    else if(pickerView.tag == 2)
        return 1;
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
        return salesArray.count;
    else if(pickerView.tag == 2)
        return callbackArray.count;
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    
    if (pickerView.tag == 1)
        return[[salesArray objectAtIndex:row]valueForKey:@"Salesman"];
    else if(pickerView.tag == 2)
        return[[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
    return result;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        self.saleNo.text = [[salesArray objectAtIndex:row]valueForKey:@"SalesNo"];
        self.salesman.text = [[salesArray objectAtIndex:row]valueForKey:@"Salesman"]; }
    else if(pickerView.tag == 2)
        self.callback.text = [[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 13;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of feed items (initially 0)
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    static NSString *CellIdentifier1 = @"1BasicCell";
    static NSString *CellIdentifier2 = @"2BasicCell";
    static NSString *CellIdentifier3 = @"3BasicCell";
    static NSString *CellIdentifier4 = @"4BasicCell";
    static NSString *CellIdentifier5 = @"5BasicCell";
    static NSString *CellIdentifier6 = @"6BasicCell";
    static NSString *CellIdentifier7 = @"7BasicCell";
    static NSString *CellIdentifier8 = @"8BasicCell";
    static NSString *CellIdentifier9 = @"9BasicCell";
    static NSString *CellIdentifier10 = @"10BasicCell";
    static NSString *CellIdentifier11 = @"11BasicCell";
    static NSString *CellIdentifier12 = @"12BasicCell";
    
    if (indexPath.section == 0){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Address";
        myCell.detailTextLabel.text = self.address.text;
        
        return myCell;
        
    } else if (indexPath.section == 1){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"City";
        myCell.detailTextLabel.text = self.city.text;
        
        return myCell;
    }
    if (indexPath.section == 2){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"State";
        myCell.detailTextLabel.text = self.state.text;
        
        return myCell;
        
    } else if (indexPath.section == 3){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Date";
        myCell.detailTextLabel.text = self.date.text;
        
        return myCell;
    }
    
    if (indexPath.section == 4){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Phone";
        myCell.detailTextLabel.text = self.phone.text;
        
        return myCell;
        
    } else if (indexPath.section == 5){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier5];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier5]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Salesman";
        myCell.detailTextLabel.text = self.salesman.text;
        
        return myCell;
    }
    if (indexPath.section == 6){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier6];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier6]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Job";
        myCell.detailTextLabel.text = self.jobName.text;
        
        return myCell;
        
    } else if (indexPath.section == 7){
        
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier7];
        
        if (myCell == nil) {
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier7]; }
        
        // Get references to labels of cell
        myCell.textLabel.text = @"Advertiser";
        myCell.detailTextLabel.text = self.adName.text;
        
        return myCell;
    } else if(indexPath.section == 8){
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier8];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier8]; }
    
    // Get references to labels of cell
    myCell.textLabel.text = @"Amount";
    myCell.detailTextLabel.text = self.amount.text;
    
    return myCell;
} else if (indexPath.section == 9){
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier9];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier9]; }
    
    // Get references to labels of cell
    myCell.textLabel.text = @"email";
    myCell.detailTextLabel.text = self.email.text;
    
    return myCell;
} else if(indexPath.section == 10){
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier10];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier10]; }
    
    // Get references to labels of cell
    myCell.textLabel.text = @"Spouse";
    myCell.detailTextLabel.text = self.spouse.text;
    
    return myCell;
} else if (indexPath.section == 11){
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier11];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier11]; }
    
    // Get references to labels of cell
    myCell.textLabel.text = @"Call Back";
    myCell.detailTextLabel.text = self.callback.text;
    
    return myCell;
} else if (indexPath.section == 12){
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier12];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier12]; }
    
    // Get references to labels of cell
    myCell.textLabel.text = @"Comments";
    myCell.detailTextLabel.text = self.comment.text;
    
    return myCell;
}
return nil;
}


@end
