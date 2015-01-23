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
    
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    
    if ([_formController isEqual: @"Leads"]) {
        
        PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
        query11.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query11 whereKey:@"AdNo" equalTo:self.frm23];
        [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                self.adName.text = [object objectForKey:@"Advertiser"];
            }
        }];
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
         query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query1 selectKeys:@[@"Callback"]];
        [query1 orderByDescending:@"Callback"];
        [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            callbackArray = [[NSMutableArray alloc]initWithArray:objects];
        }];
        
    } else if ([_formController isEqual: @"Customer"]) {
        
        PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
         query3.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query3 whereKey:@"ProductNo" containsString:self.frm23];
        [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                self.adName.text = [object objectForKey:@"Products"];
            }
        }];
    }
    
    if ( ([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]) ) {
        
        PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
        query21.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query21 whereKey:@"JobNo" equalTo:self.frm22];
        [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                self.jobName.text = [object objectForKey:@"Description"];
            }
        }];
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
        query31.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query31 whereKey:@"SalesNo" equalTo:self.frm21];
        [query31 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else {
                self.salesman.text = [object objectForKey:@"Salesman"];
            }
        }];
        
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
          self.active = @"1"; //frm30
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
    
    if  ( [self.frm29 isEqual:[NSNull null]] )
           self.photo.text = @"";
      else self.photo.text = self.frm29;
    
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
   // [self.listTableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button
-(IBAction)like:(id)sender{
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if([self.active isEqualToString: @"0"]) {
        self.following.text = @"Following";
        self.active = @"1";
       [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
      } else {
        self.following.text = @"Follow";
        self.active = @"0";
       [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];}
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
- (UIView *)datePicker:(NSUInteger)tag{
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    datePicker.tag = tag;
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
    self.date.text = [gmtDateFormatter stringFromDate:datePicker.date];
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
        self.saleNo = [[salesArray objectAtIndex:row]valueForKey:@"SalesNo"];
        self.salesman.text = [[salesArray objectAtIndex:row]valueForKey:@"Salesman"]; }
    else if(pickerView.tag == 2)
        self.callback.text = [[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 1;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of feed items (initially 0)
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
    /*
    if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"])) {
        if ((self.date.text.length == 0) && (self.aptDate.text.length == 0)){
            NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
            gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
            gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSString *dateString = [gmtDateFormatter stringFromDate:[NSDate date]];
            self.date.text = dateString;
            self.aptDate.text = dateString;}
    } */
    
    UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, 225, 30)];
    UITextView *textviewframe = [[UITextView alloc] initWithFrame:CGRectMake(130, 7, 225, 30)];
    
    if (indexPath.row == 0){
        myCell.textLabel.text = @"Date";
        self.date = textframe;
        [self.date setFont:textFont];
        self.date.placeholder = @"Date";
        self.date.tag = 8;
        self.date.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.date setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm18 isEqual:[NSNull null]] )
            self.date.text = @"";
        else self.date.text = self.frm18;
        [myCell.contentView addSubview:self.date];
        self.date.inputView = [self datePicker:8];
        
    } else if (indexPath.row == 1){
        myCell.textLabel.text = @"Address";
        self.address = textframe;
        [self.address setFont:textFont];
        self.address.placeholder = @"Address";
        self.address.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.address setClearButtonMode:UITextFieldViewModeWhileEditing];
        if  ( [self.frm14 isEqual:[NSNull null]] )
            self.address.text = @"";
        else self.address.text = self.frm14;
        [myCell.contentView addSubview:self.address];
        
    } else if (indexPath.row == 2){
        myCell.textLabel.text = @"City";
        self.city = textframe;
        [self.city setFont:textFont];
        self.city.placeholder = @"City";
        self.city.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.city setClearButtonMode:UITextFieldViewModeWhileEditing];
        myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if  ( [self.frm15 isEqual:[NSNull null]] )
            self.city.text = @"";
        else self.city.text = self.frm15;
        [myCell.contentView addSubview:self.city];
        
    } else if (indexPath.row == 3){
        myCell.textLabel.text = @"State";
        self.state = textframe;
        [self.state setFont:textFont];
        self.state.placeholder = @"State";
        self.state.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.state setClearButtonMode:UITextFieldViewModeWhileEditing];
        if  ( [self.frm16 isEqual:[NSNull null]] )
            self.state.text = @"";
        else self.state.text = self.frm16;
        [myCell.contentView addSubview:self.state];
        
        UITextField *aptframe = [[UITextField alloc] initWithFrame:CGRectMake(220, 7, 150, 30)];
        //  myCell.textLabel.text = @"Apt Date";
        self.zip = aptframe;
        [self.zip setFont:textFont];
        self.zip.placeholder = @"Apt Date";
        self.zip.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.zip setClearButtonMode:UITextFieldViewModeWhileEditing];
        if  ( [self.frm17 isEqual:[NSNull null]] )
            self.zip.text = @"";
        else self.zip.text = self.frm17;
        [myCell.contentView addSubview:self.zip];
        
    } else if (indexPath.row == 4){
        
        myCell.textLabel.text = @"Apt Date";
        self.aptDate = textframe;
        [self.aptDate setFont:textFont];
        self.aptDate.placeholder = @"Apt Date";
        self.aptDate.tag = 5;
        self.aptDate.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.aptDate setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm19 isEqual:[NSNull null]] )
            self.aptDate.text = @"";
        else self.aptDate.text = self.frm19;
        [myCell.contentView addSubview:self.aptDate];
        self.aptDate.inputView = [self datePicker:5];
        
    } else if (indexPath.row == 5){
        myCell.textLabel.text = @"Phone";
        self.phone = textframe;
        [self.phone setFont:textFont];
        self.phone.placeholder = @"Phone";
        self.phone.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.phone setClearButtonMode:UITextFieldViewModeWhileEditing];
        if (self.frm20.length == 0)
            self.phone.text = @"(516)";
        else self.phone.text = self.frm20;
        [myCell.contentView addSubview:self.phone];
        
    } else if (indexPath.row == 6){
        myCell.textLabel.text = @"Salesman";
        self.salesman = textframe;
        [self.salesman setFont:textFont];
        self.salesman.tag = 1;
        self.salesman.placeholder = @"Salesman";
        self.salesman.inputView = [self customPicker:1];
        self.salesman.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.salesman setClearButtonMode:UITextFieldViewModeWhileEditing];
        myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if ( [self.frm21 isEqual:[NSNull null]] )
            self.salesman.text = @"";
        else self.salesman.text = self.frm21;
        [myCell.contentView addSubview:self.salesman];
        
    } else if (indexPath.row == 7){
        myCell.textLabel.text = @"Jobs";
        self.jobName = textframe;
        [self.jobName setFont:textFont];
        self.jobName.placeholder = @"Jobs";
        self.jobName.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.jobName setClearButtonMode:UITextFieldViewModeWhileEditing];
        myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if ( [self.frm22 isEqual:[NSNull null]] )
            self.jobName.text = @"";
        else self.jobName.text = self.frm22;
        [myCell.contentView addSubview:self.jobName];
        
    } else if (indexPath.row == 8){
        myCell.textLabel.text = @"Advertiser";
        self.adName = textframe;
        [self.adName setFont:textFont];
        self.adName.placeholder = @"Advertiser";
        self.adName.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.adName setClearButtonMode:UITextFieldViewModeWhileEditing];
        myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if ( [self.frm23 isEqual:[NSNull null]] )
            self.adName.text = @"";
        else self.adName.text = self.frm23;
        [myCell.contentView addSubview:self.adName];
        
    } else if(indexPath.row == 8){
        myCell.textLabel.text = @"Amount";
        self.amount = textframe;
        [self.amount setFont:textFont];
        self.amount.placeholder = @"Amount";
        self.amount.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.amount setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm24 isEqual:[NSNull null]] )
            self.amount.text = @"";
        else self.amount.text = self.frm24;
        [myCell.contentView addSubview:self.amount];
        
    } else if (indexPath.row == 9){
        myCell.textLabel.text = @"Email";
        self.email = textframe;
        [self.email setFont:textFont];
        self.email.placeholder = @"Email";
        self.email.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.email setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm25 isEqual:[NSNull null]] )
            self.email.text = @"";
        else self.email.text = self.frm25;
        [myCell.contentView addSubview:self.email];
        
    } else if(indexPath.row == 10){
        myCell.textLabel.text = @"Spouse";
        self.spouse = textframe;
        [self.spouse setFont:textFont];
        self.spouse.placeholder = @"Spouse";
        self.spouse.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.spouse setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm26 isEqual:[NSNull null]] )
            self.spouse.text = @"";
        else self.spouse.text = self.frm26;
        [myCell.contentView addSubview:self.spouse];
        
    } else if (indexPath.row == 11){
        myCell.textLabel.text = @"Call Back";
        self.callback = textframe;
        [self.callback setFont:textFont];
        self.callback.placeholder = @"Call Back";
        self.callback.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.callback setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ( [self.frm27 isEqual:[NSNull null]] )
            self.callback.text = @"";
        else self.callback.text = self.frm27;
        if ([_formController isEqual: @"Leads"])
            self.callback.inputView = [self customPicker:2];
        [myCell.contentView addSubview:self.callback];
        
    } else if (indexPath.row == 12){
        myCell.textLabel.text = @"Comments";
        self.comment = textviewframe;
        [self.comment setFont:textFont];
        //[self.comment sizeToFit];
        //[self.comment layoutIfNeeded];
        self.comment.autocorrectionType = UITextAutocorrectionTypeNo;
        if ( [self.frm28 isEqual:[NSNull null]] )
            self.comment.text = @"";
        else self.comment.text = self.frm28;
        myCell.textLabel.numberOfLines = 0;
        [myCell.contentView addSubview:self.comment];
        
    }
    self.date.delegate = self;
    self.address.delegate = self;
    self.city.delegate = self;
    self.state.delegate = self;
    self.aptDate.delegate = self;
    self.phone.delegate = self;
    self.salesman.delegate = self;
    self.jobName.delegate = self;
    self.adName.delegate = self;
    self.amount.delegate = self;
    self.email.delegate = self;
    self.spouse.delegate = self;
    self.callback.delegate = self;
  //  self.comment.delegate = self;
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        [self performSegueWithIdentifier:@"lookupcitySegue"sender:self];
    if (indexPath.row == 7)
        [self performSegueWithIdentifier:@"lookupjobSegue"sender:self];
    if (indexPath.row == 8)
        [self performSegueWithIdentifier:@"lookupproductSegue"sender:self];

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
    self.jobNo = passedData;
}

- (void)jobNameFromController:(NSString *)passedData{
    self.jobName.text = passedData;
}

- (void)productFromController:(NSString *)passedData{
    self.adNo = passedData;
}

- (void)productNameFromController:(NSString *)passedData{
    self.adName.text = passedData;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"lookupcitySegue"]) {
        LookupCity *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupjobSegue"]) {
        LookupJob *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupproductSegue"]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}


@end
