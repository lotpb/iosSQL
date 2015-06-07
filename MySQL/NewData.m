//
//  NewData.m
//  MySQL
//
//  Created by Peter Balsamo on 1/1/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NewData.h"

@interface NewData ()
{
   NSMutableArray *salesArray, *callbackArray, *contractorArray;
}
@end

@implementation NewData
@synthesize leadNo, active, date, first, last, company, address, city, state, zip, phone, aptDate, email, amount, spouse, callback, saleNo, jobNo, adNo, photo, comment, rate, start, complete;

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    
    /*
     if ([_formController isEqual:TNAME2]) { //need to add contractor to form
     [parseConnection parseContractor];
     
     PFQuery *query13 = [PFQuery queryWithClassName:@"Contractor"];
     query13.cachePolicy = kPFCACHEPOLICY;
     [query13 selectKeys:@[@"Contractor"]];
     [query13 orderByDescending:@"Contractor"];
     [query13 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     contractorArray = [[NSMutableArray alloc]initWithArray:objects];
     }];
     } */
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    ParseConnection *parseConnection = [[ParseConnection alloc]init];
    parseConnection.delegate = (id)self;
   
    if ([_formController isEqual:TNAME1]) {
        [parseConnection parseCallback];
       }

    if ( ([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]) ) {
         [parseConnection parseSalesman];
       }
    
    [self passFieldData];
    
    //add Following button
    UIImage *buttonImage1 = [UIImage imageNamed:ACTIVEBUTTONYES];
    UIImage *buttonImage2 = [UIImage imageNamed:ACTIVEBUTTONNO];
    if ( [self.active.text isEqual:@"1"] ) {
         [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
          self.following.text = @"Following";
        } else {
         [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
          self.following.text = @"Follow"; }

#pragma mark Form Circle Image
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 8;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    
#pragma mark BarButtons
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[saveItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
    [[UITextField appearance] setTintColor:CURSERCOLOR];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
  // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
     self.title = [NSString stringWithFormat:@" %@ %@", @"New", self.formController];
     if ( ([_formController isEqual:TNAME3]) || ([_formController isEqual:TNAME4]) )
          [self.company becomeFirstResponder];
     else [self.first becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - reload Form Data
- (void)viewDidAppear:(BOOL)animated
{   [super viewDidAppear:animated];
    [self loadFormData];
}

#pragma mark - ParseDelegate
- (void)parseSalesmanloaded:(NSMutableArray *)salesItem {
    salesArray = salesItem;
}

- (void)parseContractorloaded:(NSMutableArray *)contractItem {
    contractorArray = contractItem;
}

- (void)parseCallbackloaded:(NSMutableArray *)callbackItem {
    callbackArray = callbackItem;
}

#pragma mark - LoadFieldData
- (void)passFieldData {
    self.saleNo.hidden = YES; //Field
    self.jobNo.hidden = YES; //Field
    self.adNo.hidden = YES; //Field
    self.active.hidden = YES; //Field
    
    if ([self.frm31 isEqual:[NSNull null]])
        self.leadNo = @"";
    else self.leadNo = self.frm31;
    
    if ([_formController isEqual:TNAME2]) {
        self.jobNo.text = self.jobNoDetail;
        self.saleNo.text = self.saleNoDetail; }
    
    if ([self.frm11 isEqual:[NSNull null]])
        self.first.text = @"";
    else self.first.text = self.frm11;
    
    if ([self.frm12 isEqual:[NSNull null]])
        self.last.text = @"";
    else self.last.text = self.frm12;
    
    if ([self.frm13 isEqual:[NSNull null]])
        self.company.text = @"";
    else self.company.text = self.frm13;
    
    if ([self.frm14 isEqual:[NSNull null]])
        self.address.text = @"";
    else self.address.text = self.frm14;
    
    if ([self.frm15 isEqual:[NSNull null]])
        self.city.text = @"";
    else self.city.text = self.frm15;
    
    if ([self.frm16 isEqual:[NSNull null]])
        self.state.text = @"";
    else self.state.text = self.frm16;
    
    if ([self.frm17 isEqual:[NSNull null]])
        self.zip.text = @"";
    else self.zip.text = self.frm17;
    
    if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2])) {
        self.company.hidden = YES;
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone localTimeZone];
            formatter.dateFormat = KEY_DATESQLFORMAT;
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        if ([_formController isEqual:TNAME1]) {
            self.date.text = dateString; //frm18
            self.aptDate.text = dateString; } //frm19
            else self.date.text = dateString; }//no date on customer aptdate
    }
    
    if (self.frm20.length == 0)
        self.phone.text = @"(516)";
    else self.phone.text = self.frm20;
    
    if ([self.frm21 isEqual:[NSNull null]])
        self.salesman.text = @"";
    else self.salesman.text = self.frm21;
    
    if ([self.frm22 isEqual:[NSNull null]])
        self.jobName.text = @"";
    else self.jobName.text = self.frm22;
    
    if ([self.frm23 isEqual:[NSNull null]])
        self.adName.text = @"";
    else self.adName.text = self.frm23;
    
    if ([self.frm24 isEqual:[NSNull null]])
        self.amount.text = @"";
    else self.amount.text = self.frm24;
    
    if ([self.frm25 isEqual:[NSNull null]])
        self.email.text = @"";
    else self.email.text = self.frm25;
    
    if ([self.frm26 isEqual:[NSNull null]])
        self.spouse.text = @"";
    else self.spouse.text = self.frm26;
    
    if ([self.frm27 isEqual:[NSNull null]])
        self.callback.text = @"";
    else self.callback.text = self.frm27;
    
    if ([self.frm28 isEqual:[NSNull null]])
        self.comment.text = @"";
    else self.comment.text = self.frm28;
    
    if ([self.frm29 isEqual:[NSNull null]])
        self.photo.text = @"";
    else self.photo.text = self.frm29;
    
    self.active.text = @"1"; //frm30
    
    if ([_formController isEqual:TNAME1]) {
        self.callback.inputView = [self customPicker:2];
        self.aptDate.inputView = [self datePicker];}
    
    if ([_formController isEqual:TNAME2]) {
        self.company.placeholder = @"Contractor";
        self.aptDate.placeholder = @"Rate";
        self.adName.placeholder = @"ProductNo";
        self.callback.placeholder = @"# Windows";
        
    } else if ([_formController isEqual:TNAME3]) {
        self.first.placeholder = @"Profession";
        self.last.placeholder = @"Webpage";
        self.date.placeholder = @"Manager";
        self.salesman.placeholder = @"Phone1";
        self.jobName.placeholder = @"phone2";
        self.adName.placeholder = @"phone3";
        self.amount.placeholder = @"Department";
        self.spouse.placeholder = @"Office";
        self.aptDate.placeholder = @"Assistant";
        self.callback.hidden = YES;//Field
        
    } else if ([_formController isEqual:TNAME4]) {
        self.company.placeholder = @"Subcontractor";
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
    
    if ( ([_formController isEqual:TNAME4]) || ([_formController isEqual:TNAME3]) ) {
        self.jobLookup.hidden = YES; //Button
        self.productLookup.hidden = YES; //Button
        self.saleNo.hidden = YES; //Field
        self.jobNo.hidden = YES; //Field
        self.adNo.hidden = YES; //Field
    } else self.salesman.inputView = [self customPicker:1];
}

#pragma mark - Load Form Data
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
    UIImage *buttonImage1 = [UIImage imageNamed:ACTIVEBUTTONYES];
    UIImage *buttonImage2 = [UIImage imageNamed:ACTIVEBUTTONNO];
    if([self.active.text isEqualToString: @"0"]) {
        self.following.text = @"Following";
        self.active.text = @"1";
       [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
       }else{
        self.following.text = @"Follow";
        self.active.text = @"0";
       [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];}
}

#pragma mark - LookupData
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

#pragma mark Lookup City needed
-(IBAction)updateCity:(id)sender{
    [self performSegueWithIdentifier:LOOKCITYSEGUE sender:self];
}

#pragma mark Lookup Job needed
-(IBAction)updateJob:(id)sender{
    [self performSegueWithIdentifier:LOOKJOBSEGUE sender:self];
}

#pragma mark Lookup Product needed
-(IBAction)updateProduct:(id)sender{
    [self performSegueWithIdentifier:LOOKPRODSEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:LOOKCITYSEGUE]) {
        LookupCity *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:LOOKJOBSEGUE]) {
        LookupJob *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:LOOKPRODSEGUE]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}

#pragma mark - Date Picker
- (UIView *)datePicker {
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = DATEPKCOLOR;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    datePicker.tag = 5;
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.timeZone = [NSTimeZone localTimeZone];
    [datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:datePicker];
    
    return pickerView;
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = KEY_DATESQLFORMAT;
    self.aptDate.text = [formatter stringFromDate:datePicker.date]; }
}

#pragma mark - View Picker
- (UIView *)customPicker:(NSUInteger)tag {
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    pickerView.backgroundColor = PICKCOLOR;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    toolbar.barStyle = PICKTOOLSTYLE;
    toolbar.translucent = PICKTOOLTRANS;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    picker.tag = tag;
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = SHOWIND;
    //[picker selectRow:10 inComponent:0 animated:YES];
    [pickerView addSubview:picker];
    [pickerView addSubview:toolbar];
    
    [picker reloadAllComponents];
    return pickerView;
}

-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
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

#pragma mark - New Data
-(void)share:(id)sender {
    if (([self.last.text isEqualToString:@""]) || ([self.address.text isEqualToString:@""]))
    {
        UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:@"Error!!"
                                                             message:@"Please fill in the details." delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
        [ErrorAlert show];
        //  [ErrorAlert release];
    } else {
        
        if ([_formController isEqual:TNAME1]) {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveLead
                
                PFObject *savelead = [PFObject objectWithClassName:@"Leads"];
                // [savelead setObject:self.leadNo forKey:@"LeadNo"];
                //  [savelead setObject:self.active.text forKey:@"Active"];
                [savelead setObject:self.date.text forKey:@"Date"];
                [savelead setObject:self.first.text forKey:@"First"];
                [savelead setObject:self.last.text forKey:@"LastName"];
                [savelead setObject:self.address.text forKey:@"Address"];
                [savelead setObject:self.city.text forKey:@"City"];
                [savelead setObject:self.state.text forKey:@"State"];
                //   [savelead setObject:self.zip.text forKey:@"Zip"];
                [savelead setObject:self.phone.text forKey:@"Phone"];
                [savelead setObject:self.aptDate.text forKey:@"AptDate"];
                [savelead setObject:self.email.text forKey:@"Email"];
                // [savelead setObject:self.amount.text forKey:@"Amount"];
                [savelead setObject:self.spouse.text forKey:@"Spouse"];
                [savelead setObject:self.callback.text forKey:@"CallBack"];
                // [savelead setObject:self.saleNo.text forKey:@"SalesNo"];
                // [savelead setObject:self.jobNo.text forKey:@"JobNo"];
                // [savelead setObject:self.adNo.text forKey:@"AdNo"];
                [savelead setObject:self.comment.text forKey:@"Coments"];
                [savelead setObject:self.photo.text forKey:@"Photo"];
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            } else {
                // NSString *_leadNo = self.leadNo;
                NSString *_active = self.active.text;
                NSString *_date = self.date.text;
                NSString *_first = self.first.text;
                NSString *_name = self.last.text;
                NSString *_address = self.address.text;
                NSString *_city = self.city.text;
                NSString *_state = self.state.text;
                NSString *_zip = self.zip.text;
                NSString *_phone = self.phone.text;
                NSString *_aptdate = self.aptDate.text;
                NSString *_email = self.email.text;
                NSString *_amount = self.amount.text;
                NSString *_spouse = self.spouse.text;
                NSString *_callback = self.callback.text;
                NSString *_salesNo = self.saleNo.text;
                NSString *_jobNo = self.jobNo.text;
                NSString *_adNo = self.adNo.text;
                NSString *_comments = self.comment.text;
                NSString *_photo = self.photo.text;
                //  NSString *_time = self.time;
                
                NSString *rawStr = [NSString stringWithFormat:SAVELEADFIELD, SAVELEADFIELD1];
                //NSLog(@"rawStr is %@",rawStr);
                NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:SAVELEADURL];
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
                //NSLog(@"%lu", (unsigned long)responseString.length);
                //NSLog(@"%lu", (unsigned long)success.length);
            }
        }
        else if ([_formController isEqual:TNAME2]) {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveCustomer
                
                PFObject *savelead = [PFObject objectWithClassName:@"Customer"];
                //[savelead setObject:self.leadNo forKey:@"LeadNo"];
                //[savelead setObject:self.active.text forKey:@"Active"];
                [savelead setObject:self.first.text forKey:@"First"];
                [savelead setObject:self.leadNo forKey:@"LeadNo"];
                [savelead setObject:self.company.text forKey:@"Contractor"];
                [savelead setObject:self.address.text forKey:@"Address"];
                [savelead setObject:self.city.text forKey:@"City"];
                [savelead setObject:self.state.text forKey:@"State"];
                //[savelead setObject:self.zip.text forKey:@"Zip"];
                [savelead setObject:self.date.text forKey:@"Date"];
                [savelead setObject:self.aptDate forKey:@"Rate"];
                [savelead setObject:self.phone.text forKey:@"Phone"];
                //[savelead setObject:self.saleNo.text forKey:@"SalesNo"];
                //[savelead setObject:self.jobNo.text forKey:@"JobNo"];
                //[savelead setObject:self.adNo.text forKey:@"ProductNo"];
                //[savelead setObject:self.amount.text forKey:@"Amount"];
                [savelead setObject:self.email.text forKey:@"Email"];
                [savelead setObject:self.spouse.text forKey:@"Spouse"];
                //[savelead setObject:self.callback.text forKey:@"Quan"];
                [savelead setObject:self.start.text forKey:@"Start"];
                [savelead setObject:self.complete.text forKey:@"Complete"];
                [savelead setObject:self.comment.text forKey:@"Comment"];
                [savelead setObject:self.photo.text forKey:@"Photo"];
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            } else {
                NSString *_active = self.active.text;
                NSString *_first = self.first.text;
                NSString *_leadNo = self.leadNo;
                NSString *_contractor = self.company.text;
                NSString *_address = self.address.text;
                NSString *_city = self.city.text;
                NSString *_state = self.state.text;
                NSString *_zip = self.zip.text;
                NSString *_date = self.date.text;
                NSString *_rate = self.aptDate.text;
                NSString *_phone = self.phone.text;
                NSString *_salesNo = self.saleNo.text;
                NSString *_jobNo = self.jobNo.text;
                NSString *_productNo = self.adNo.text;
                NSString *_amount = self.amount.text;
                NSString *_email = self.email.text;
                NSString *_spouse = self.spouse.text;
                NSString *_quan = self.callback.text;
                NSString *_start = self.start.text;
                NSString *_complete = self.complete.text;
                NSString *_comments = self.comment.text;
                NSString *_photo = self.photo.text;
                NSString *_photo1 = nil;
                NSString *_photo2 = nil;
                // NSString *_time = self.time;
                
                NSString *rawStr = [NSString stringWithFormat:SAVECUSTFIELD, SAVECUSTFIELD1];
                
                NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:SAVECUSTOMERURL];
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
        else if ([_formController isEqual:TNAME3]) {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveVendor
                
                PFObject *savelead = [PFObject objectWithClassName:@"Vendors"];
               // [savelead setObject:self.leadNo forKey:@"VendorNo"];
                [savelead setObject:self.complete.text forKey:@"Vendor"];
                [savelead setObject:self.address.text forKey:@"Address"];
                [savelead setObject:self.city forKey:@"City"];
                [savelead setObject:self.state.text forKey:@"State"];
                [savelead setObject:self.zip.text forKey:@"Zip"];
                [savelead setObject:self.phone.text forKey:@"Phone"];
                [savelead setObject:self.salesman.text forKey:@"Phone1"];
                [savelead setObject:self.jobName.text forKey:@"Phone2"];
                [savelead setObject:self.adName.text forKey:@"Phone3"];
                [savelead setObject:self.email forKey:@"Email"];
                [savelead setObject:self.last.text forKey:@"WebPage"];
                [savelead setObject:self.amount.text forKey:@"Department"];
                [savelead setObject:self.spouse.text forKey:@"Office"];
                [savelead setObject:self.date.text forKey:@"Manager"];
                [savelead setObject:self.first.text forKey:@"Profession"];
                [savelead setObject:self.aptDate.text forKey:@"Assistant"];
                [savelead setObject:self.comment.text forKey:@"Comments"];
                //[savelead setObject:self.active.text forKey:@"Active"];
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            } else {
                //NSString *_vendorNo = self.leadNo;
                NSString *_name = self.company.text;
                NSString *_address = self.address.text;
                NSString *_city = self.city.text;
                NSString *_state = self.state.text;
                NSString *_zip = self.zip.text;
                NSString *_phone = self.phone.text;
                NSString *_phone1 = self.salesman.text;
                NSString *_phone2 = self.jobName.text;
                NSString *_phone3 = self.adName.text;
                NSString *_email = self.email.text;
                NSString *_webpage = self.last.text;
                NSString *_department = self.amount.text;
                NSString *_office = self.spouse.text;
                NSString *_manager = self.date.text;
                NSString *_profession = self.first.text;
                NSString *_assistant = self.aptDate.text;
                NSString *_comments = self.comment.text;
                NSString *_active = self.active.text;
                NSString *_phonecmbo = nil;
                NSString *_phonecmbo1 = nil;
                NSString *_phonecmbo2 = nil;
                NSString *_phonecmbo3 = nil;
                //NSString *_time = self.time;
                
                NSString *rawStr = [NSString stringWithFormat:SAVEVENDORFIELD, SAVEVENDORFIELD1];
                
                NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:SAVEVENDORURL];
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
        else if ([_formController isEqual:TNAME4]) {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveEmployee
                
                PFObject *savelead = [PFObject objectWithClassName:@"Employee"];
                //[savelead setObject:self.leadNo forKey:@"EmployeeNo"];
                [savelead setObject:self.company.text forKey:@"Company"];
                [savelead setObject:self.address.text forKey:@"Address"];
                [savelead setObject:self.city.text forKey:@"City"];
                [savelead setObject:self.state.text forKey:@"State"];
                [savelead setObject:self.zip.text forKey:@"Zip"];
                [savelead setObject:self.phone.text forKey:@"HomePhone"];
                [savelead setObject:self.salesman.text forKey:@"WorkPhone"];
                [savelead setObject:self.jobName.text forKey:@"CellPhone"];
                [savelead setObject:self.date.text forKey:@"Country"];
                [savelead setObject:self.email.text forKey:@"Email"];
                [savelead setObject:self.last.text forKey:@"Last"];
                [savelead setObject:self.amount.text forKey:@"Department"];
                [savelead setObject:self.aptDate.text forKey:@"Middle"];
                [savelead setObject:self.first.text forKey:@"First"];
                [savelead setObject:self.callback.text forKey:@"Manager"];
                [savelead setObject:self.adName.text forKey:@"SS"];
                [savelead setObject:self.comment.text forKey:@"Comments"];
                //[savelead setObject:self.active.text forKey:@"Active"];
                [savelead setObject:self.spouse.text forKey:@"Title"];
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }];
            } else {
                //  NSString *_employeeNo = self.leadNo;
                NSString *_company = self.company.text;
                NSString *_address = self.address.text;
                NSString *_city = self.city.text;
                NSString *_state = self.state.text;
                NSString *_zip = self.zip.text;
                NSString *_homephone = self.phone.text;
                NSString *_workphone = self.salesman.text;
                NSString *_cellphone = self.jobName.text;
                NSString *_country = self.date.text;
                NSString *_email = self.email.text;
                NSString *_last = self.last.text;
                NSString *_department = self.amount.text;
                NSString *_middle = self.aptDate.text;
                NSString *_first = self.first.text;
                NSString *_manager = self.callback.text;
                NSString *_social = self.adName.text;
                NSString *_comments = self.comment.text;
                NSString *_active = self.active.text;
                NSString *_employtitle = self.spouse.text;
                //  NSString *_time = self.time;
                
                NSString *rawStr = [NSString stringWithFormat:SAVEEMPLOYEEFIELD, SAVEEMPLOYEEFIELD1];
                
                NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:SAVEEMPLOYEEURL];
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
        [self clearFormData];
    }
}

@end
