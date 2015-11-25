//
//  NewData.m
//  MySQL
//
//  Created by Peter Balsamo on 1/1/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NewData.h"
NSString* const kareacodeKeyKey = @"areacodeKey";
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
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    ParseConnection *parseConnection = [[ParseConnection alloc]init];
    parseConnection.delegate = (id)self;
   
    if ([_formController isEqual:TNAME1]) {
        [parseConnection parseCallbackPick];
       }

    if ( ([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]) ) {
         [parseConnection parseSalesPick];
       }
    
    if ([_formController isEqual:TNAME4]) {
        //[parseConnection parseContractorPick];
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
            self.following.text = @"Follow";}
    
    //self.following.textColor = BLUECOLOR;

#pragma mark Form Circle Image
    /*
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 8;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
     */
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = 30.f;
    self.profileImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.profileImageView.layer.borderWidth = 0.5f;
 
#pragma mark Buttons
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[saveItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [self.cityLookup setBackgroundColor:BLUECOLOR];
    [self.cityLookup setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [[self.cityLookup titleLabel] setFont:DETAILFONT(IPHONEFONT18)];
    CALayer *btnLayer1 = [self.cityLookup layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:9.0f];
    
    [self.jobLookup setBackgroundColor:BLUECOLOR];
    [self.jobLookup setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [[self.jobLookup titleLabel] setFont:DETAILFONT(IPHONEFONT18)];
    CALayer *btnLayer2 = [self.jobLookup layer];
    [btnLayer2 setMasksToBounds:YES];
    [btnLayer2 setCornerRadius:9.0f];
    
    [self.productLookup setBackgroundColor:BLUECOLOR];
    [self.productLookup setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [[self.productLookup titleLabel] setFont:DETAILFONT(IPHONEFONT18)];
    CALayer *btnLayer3 = [self.productLookup layer];
    [btnLayer3 setMasksToBounds:YES];
    [btnLayer3 setCornerRadius:9.0f];
    
    [self.salesLookup setBackgroundColor:BLUECOLOR];
    [self.salesLookup setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [[self.salesLookup titleLabel] setFont:DETAILFONT(IPHONEFONT18)];
    CALayer *btnLayer4 = [self.salesLookup layer];
    [btnLayer4 setMasksToBounds:YES];
    [btnLayer4 setCornerRadius:9.0f];
    
    [self.clearbutton setBackgroundColor:BLUECOLOR];
    [self.clearbutton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [[self.clearbutton titleLabel] setFont:DETAILFONT(IPHONEFONT14)];
    CALayer *btnLayer5 = [self.clearbutton layer];
    [btnLayer5 setMasksToBounds:YES];
    [btnLayer5 setCornerRadius:7.0f];
    
    self.comment.layer.cornerRadius = 8.0;
    self.comment.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
    self.comment.layer.borderWidth = 1.2;
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
    [[UITextField appearance] setTintColor:CURSERCOLOR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
     self.title = [NSString stringWithFormat:@" %@ %@", @"New", self.formController];
    /*
     if ( ([_formController isEqual:TNAME3]) || ([_formController isEqual:TNAME4]) )
          [self.company becomeFirstResponder];
     else [self.first becomeFirstResponder]; */
    
    //[self.view endEditing:YES]; //dismiss the keyboard
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - reload Form Data
- (void)viewDidAppear:(BOOL)animated
{   [super viewDidAppear:animated];
    [self loadFormData];
    
    //animate label
    self.following.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.5 animations:^{
        self.following.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - textfield
-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - Parse PickView
- (void)parseSalesPickloaded:(NSMutableArray *)salesItem {
    salesArray = salesItem;
}

- (void)parseContractorPickloaded:(NSMutableArray *)contractItem {
    //contractorArray = contractItem;
}

- (void)parseCallbackPickloaded:(NSMutableArray *)callbackItem {
    callbackArray = callbackItem;
}

#pragma mark - Load Field Data
- (void)passFieldData {
    self.saleNo.hidden = YES; //Field
    self.jobNo.hidden = YES; //Field
    self.adNo.hidden = YES; //Field
    self.active.hidden = YES; //Field
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.first setFont:CELL_FONT(IPADFONT20)];
        [self.last setFont:CELL_FONT(IPADFONT20)];
        [self.company setFont:CELL_FONT(IPADFONT20)];
        [self.date setFont:CELL_FONT(IPADFONT20)];
        [self.address setFont:CELL_FONT(IPADFONT20)];
        [self.city setFont:CELL_FONT(IPADFONT20)];
        [self.state setFont:CELL_FONT(IPADFONT20)];
        [self.zip setFont:CELL_FONT(IPADFONT20)];
        [self.aptDate setFont:CELL_FONT(IPADFONT20)];
        [self.phone setFont:CELL_FONT(IPADFONT20)];
        [self.salesman setFont:CELL_FONT(IPADFONT20)];
        [self.jobName setFont:CELL_FONT(IPADFONT20)];
        [self.adName setFont:CELL_FONT(IPADFONT20)];
        [self.amount setFont:CELL_FONT(IPADFONT20)];
        [self.email setFont:CELL_FONT(IPADFONT20)];
        [self.spouse setFont:CELL_FONT(IPADFONT20)];
        [self.callback setFont:CELL_FONT(IPADFONT20)];
        [self.comment setFont:CELL_FONT(IPADFONT20)];
        [self.start setFont:CELL_FONT(IPADFONT20)];
        [self.complete setFont:CELL_FONT(IPADFONT20)];
    } else {
        [self.first setFont:CELL_FONT(IPHONEFONT20)];
        [self.last setFont:CELL_FONT(IPHONEFONT20)];
        [self.company setFont:CELL_FONT(IPHONEFONT20)];
        [self.date setFont:CELL_FONT(IPHONEFONT20)];
        [self.address setFont:CELL_FONT(IPHONEFONT20)];
        [self.city setFont:CELL_FONT(IPHONEFONT20)];
        [self.state setFont:CELL_FONT(IPHONEFONT20)];
        [self.zip setFont:CELL_FONT(IPHONEFONT20)];
        [self.aptDate setFont:CELL_FONT(IPHONEFONT20)];
        [self.phone setFont:CELL_FONT(IPHONEFONT20)];
        [self.salesman setFont:CELL_FONT(IPHONEFONT20)];
        [self.jobName setFont:CELL_FONT(IPHONEFONT20)];
        [self.adName setFont:CELL_FONT(IPHONEFONT20)];
        [self.amount setFont:CELL_FONT(IPHONEFONT20)];
        [self.email setFont:CELL_FONT(IPHONEFONT20)];
        [self.spouse setFont:CELL_FONT(IPHONEFONT20)];
        [self.callback setFont:CELL_FONT(IPHONEFONT20)];
        [self.comment setFont:CELL_FONT(IPHONEFONT20)];
        [self.start setFont:CELL_FONT(IPHONEFONT20)];
        [self.complete setFont:CELL_FONT(IPHONEFONT20)];
    }
    
    if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2])) {
        self.amount.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([_formController isEqual:TNAME2]) {
        self.callback.keyboardType = UIKeyboardTypeDecimalPad;
    }
    if ([_formController isEqual:TNAME3]) {
        self.last.keyboardType = UIKeyboardTypeURL;
        self.salesman.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.jobName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.adName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    if ([_formController isEqual:TNAME4]) {
        self.salesman.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.jobName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.adName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
    self.email.keyboardType = UIKeyboardTypeEmailAddress;
    self.phone.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
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
    
    if (self.frm20.length == 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            self.phone.text = [standardDefaults objectForKey:kareacodeKeyKey];
        } else {
            self.phone.text = @"";
        }
    } else self.phone.text = self.frm20;
    
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
        //self.callback.frame = CGRectMake(30, 500, 100, 25);
        /*
        UIStepper *stepper = [[UIStepper alloc] init];
        stepper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [stepper setTintColor:[UIColor grayColor]];
        stepper.value = [self.callback.text doubleValue];
        stepper.stepValue = 1;
        UIView *wrapper = [[UIView alloc] initWithFrame:stepper.frame];
        [wrapper addSubview:stepper];
         [self.company addSubview:wrapper];
     //   myCell.accessoryView = stepper;
        [stepper addTarget:self action:@selector(changestep:) forControlEvents:UIControlEventValueChanged]; */
        
    } else if ([_formController isEqual:TNAME3]) {
        self.company.placeholder = @"Company Name";
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
        self.adName.placeholder = @"Social Security";
        self.amount.placeholder = @"Department";
        self.spouse.placeholder = @"Title";
        self.callback.placeholder = @"Manager";
        if (self.frm25.length == 0)//field Country
            self.date.text = @"US";
       else self.date.text = self.frm25;
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

#pragma mark - Lookup Data
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

- (void)salesFromController:(NSString *)passedData{
    self.saleNo.text = passedData;
}

- (void)salesNameFromController:(NSString *)passedData{
    self.salesman.text = passedData;
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

#pragma mark Lookup Salesman needed
-(IBAction)updateSalesman:(id)sender{
    [self performSegueWithIdentifier:LOOKSALESEGUE sender:self];
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
    if ([[segue identifier] isEqualToString:LOOKSALESEGUE]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}

#pragma mark - Date Picker
- (UIView *)datePicker {
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = DATEPKCOLOR;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175)];
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

#pragma mark - PickerView
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
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
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
    //else if(pickerView.tag == 3)
        //return 1;
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
        return salesArray.count;
    else if(pickerView.tag == 2)
        return callbackArray.count;
    //else if(pickerView.tag == 3)
        //return contractorArray.count;
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
    //else if(pickerView.tag == 3)
        //return[[contractorArray objectAtIndex:row]valueForKey:@"Contractor"];
    return result;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        self.saleNo.text = [[salesArray objectAtIndex:row]valueForKey:@"SalesNo"];
        self.salesman.text = [[salesArray objectAtIndex:row]valueForKey:@"Salesman"]; }
    else if(pickerView.tag == 2)
        self.callback.text = [[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
    //else if(pickerView.tag == 3)
        //self.company.text = [[callbackArray objectAtIndex:row]valueForKey:@"Contractor"];
}

#pragma mark - New Data
-(void)share:(id)sender {
    
    if (([self.last.text isEqualToString:@""]) || ([self.address.text isEqualToString:@""]))
    {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                         message:@"Please fill in the details."
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        
        if ([_formController isEqual:TNAME1]) {
            /*
             *******************************************************************************************
             Parse.com
             *******************************************************************************************
             */
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveLead
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSNumber *myLeadNo = [formatter numberFromString:self.leadNo];
                NSNumber *myAmount = [formatter numberFromString:self.amount.text];
                NSNumber *myActive = [formatter numberFromString:self.active.text];
                NSNumber *myZip = [formatter numberFromString:self.zip.text];
                NSNumber *mySalesNo = [formatter numberFromString:self.saleNo.text];
                NSNumber *myJobNo = [formatter numberFromString:self.jobNo.text];
                NSNumber *myAdNo = [formatter numberFromString:self.adNo.text];
                
                PFObject *savelead = [PFObject objectWithClassName:@"Leads"];
                [savelead setObject:myLeadNo ? myLeadNo : [NSNumber numberWithInteger: -1] forKey:@"LeadNo"];
                [savelead setObject:myActive ? myActive : [NSNumber numberWithInteger: 0] forKey:@"Active"];
                [savelead setObject:self.date.text ? self.date.text : [NSNull null] forKey:@"Date"];
                [savelead setObject:self.first.text ? self.first.text : [NSNull null] forKey:@"First"];
                [savelead setObject:self.last.text ? self.last.text : [NSNull null] forKey:@"LastName"];
                [savelead setObject:self.address.text ? self.address.text : [NSNull null] forKey:@"Address"];
                [savelead setObject:self.city.text ? self.city.text : [NSNull null] forKey:@"City"];
                [savelead setObject:self.state.text ? self.state.text : [NSNull null] forKey:@"State"];
                [savelead setObject:myZip ? myZip : [NSNumber numberWithInteger: -1] forKey:@"Zip"];
                [savelead setObject:self.phone.text ? self.phone.text : [NSNull null] forKey:@"Phone"];
                [savelead setObject:self.aptDate.text ? self.aptDate.text : [NSNull null] forKey:@"AptDate"];
                [savelead setObject:self.email.text ? self.email.text : [NSNull null] forKey:@"Email"];
                [savelead setObject:myAmount ? myAmount : [NSNumber numberWithInteger: 0]forKey:@"Amount"];
                [savelead setObject:self.spouse.text ? self.spouse.text : [NSNull null] forKey:@"Spouse"];
                [savelead setObject:self.callback.text ? self.callback.text : [NSNull null] forKey:@"CallBack"];
                [savelead setObject:mySalesNo ? mySalesNo : [NSNumber numberWithInteger: -1] forKey:@"SalesNo"];
                [savelead setObject:myJobNo ? myJobNo : [NSNumber numberWithInteger: -1] forKey:@"JobNo"];
                [savelead setObject:myAdNo ? myAdNo : [NSNumber numberWithInteger: -1] forKey:@"AdNo"];
                [savelead setObject:self.comment.text ? self.comment.text : [NSNull null] forKey:@"Coments"];
                [savelead setObject:self.photo.text ? self.photo.text : [NSNull null] forKey:@"Photo"];
                
                // Set ACL permissions for added security
                PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [postACL setPublicReadAccess:YES];
                [savelead setACL:postACL];
                
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 GOBACK;
                                                 return;
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Upload Failure" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
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
                //NSString *_time = self.time;
                
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
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSNumber *myLeadNo = [formatter numberFromString:self.leadNo];
                NSNumber *myCustNo = [formatter numberFromString:self.custNo];
                NSNumber *myAmount = [formatter numberFromString:self.amount.text];
                NSNumber *myActive = [formatter numberFromString:self.active.text];
                NSNumber *myZip = [formatter numberFromString:self.zip.text];
                NSNumber *mySalesNo = [formatter numberFromString:self.saleNo.text];
                NSNumber *myJobNo = [formatter numberFromString:self.jobNo.text];
                NSNumber *myAdNo = [formatter numberFromString:self.adNo.text];
                NSNumber *myQuan = [formatter numberFromString:self.callback.text];
                
                PFObject *savelead = [PFObject objectWithClassName:@"Customer"];
                [savelead setObject:myActive ? myActive : [NSNumber numberWithInteger: 0] forKey:@"Active"];
                [savelead setObject:self.first.text ? self.first.text : [NSNull null] forKey:@"First"];
                [savelead setObject:myCustNo ? myCustNo : [NSNumber numberWithInteger: -1] forKey:@"CustNo"];
                [savelead setObject:myLeadNo ? myLeadNo : [NSNumber numberWithInteger: -1] forKey:@"LeadNo"];
                [savelead setObject:self.last.text ? self.last.text : [NSNull null] forKey:@"LastName"];
                [savelead setObject:self.company.text ? self.company.text : [NSNull null] forKey:@"Contractor"];
                [savelead setObject:self.address.text ? self.address.text : [NSNull null] forKey:@"Address"];
                [savelead setObject:self.city.text ? self.city.text : [NSNull null] forKey:@"City"];
                [savelead setObject:self.state.text ? self.state.text : [NSNull null] forKey:@"State"];
                [savelead setObject:myZip ? myZip : [NSNumber numberWithInteger: -1] forKey:@"Zip"];
                [savelead setObject:self.date.text ? self.date.text : [NSNull null] forKey:@"Date"];
                [savelead setObject:self.aptDate ? self.aptDate.text : [NSNull null] forKey:@"Rate"];
                [savelead setObject:self.phone.text ? self.phone.text : [NSNull null] forKey:@"Phone"];
                [savelead setObject:mySalesNo ? mySalesNo : [NSNumber numberWithInteger: -1] forKey:@"SalesNo"];
                [savelead setObject:myJobNo ? myJobNo : [NSNumber numberWithInteger: -1] forKey:@"JobNo"];
                [savelead setObject:myAdNo ? myAdNo : [NSNumber numberWithInteger: -1] forKey:@"ProductNo"];
                [savelead setObject:myAmount ? myAmount : [NSNumber numberWithInteger: 0] forKey:@"Amount"];
                [savelead setObject:self.email.text ? self.email.text : [NSNull null] forKey:@"Email"];
                [savelead setObject:self.spouse.text ? self.spouse.text : [NSNull null] forKey:@"Spouse"];
                [savelead setObject:myQuan ? myQuan : [NSNumber numberWithInteger: 0] forKey:@"Quan"];
                [savelead setObject:self.start.text ? self.start.text : [NSNull null] forKey:@"Start"];
                [savelead setObject:self.complete.text ? self.complete.text : [NSNull null] forKey:@"Complete"];
                [savelead setObject:self.comment.text ? self.comment.text : [NSNull null] forKey:@"Comment"];
                [savelead setObject:self.photo.text ? self.photo.text : [NSNull null] forKey:@"Photo"];
                
                // Set ACL permissions for added security
                PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [postACL setPublicReadAccess:YES];
                [savelead setACL:postACL];
                
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 GOBACK;
                                                 return;
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Failure" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
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
                //NSString *_time = self.time;
                
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
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSNumber *myLeadNo = [formatter numberFromString:self.leadNo];
                NSNumber *myActive = [formatter numberFromString:self.active.text];
                
                PFObject *savelead = [PFObject objectWithClassName:@"Vendors"];
                //NSLog(@"rawStr is %@",savelead);
                [savelead setObject:myLeadNo ? myLeadNo : [NSNumber numberWithInteger: -1] forKey:@"VendorNo"];
                [savelead setObject:self.company.text ? self.company.text : [NSNull null] forKey:@"Vendor"];
                [savelead setObject:self.address.text ? self.address.text : [NSNull null] forKey:@"Address"];
                [savelead setObject:self.city.text ? self.city.text : [NSNull null] forKey:@"City"];
                [savelead setObject:self.state.text ? self.start.text : [NSNull null] forKey:@"State"];
                [savelead setObject:self.zip.text ? self.zip.text : [NSNull null] forKey:@"Zip"];
                [savelead setObject:self.phone.text ? self.phone.text : [NSNull null] forKey:@"Phone"];
                [savelead setObject:self.salesman.text ? self.salesman.text : [NSNull null] forKey:@"Phone1"];
                [savelead setObject:self.jobName.text ? self.jobName.text : [NSNull null] forKey:@"Phone2"];
                [savelead setObject:self.adName.text ? self.adName.text : [NSNull null] forKey:@"Phone3"];
                
                //[savelead setObject:[NSNull null] forKey:@"PhoneCmbo"];
                //[savelead setObject:[NSNull null] forKey:@"PhoneCmbo1"];
                //[savelead setObject:[NSNull null] forKey:@"PhoneCmbo2"];
                //[savelead setObject:[NSNull null] forKey:@"PhoneCmbo3"];
                
                [savelead setObject:self.email.text ? self.email.text : [NSNull null] forKey:@"Email"];
                [savelead setObject:self.last.text ? self.last.text : [NSNull null] forKey:@"WebPage"];
                [savelead setObject:self.amount.text ? self.amount.text : [NSNull null] forKey:@"Department"];
                [savelead setObject:self.spouse.text ? self.spouse.text : [NSNull null] forKey:@"Office"];
                [savelead setObject:self.date.text ? self.date.text : [NSNull null] forKey:@"Manager"];
                [savelead setObject:self.first.text ? self.first.text : [NSNull null] forKey:@"Profession"];
                [savelead setObject:self.aptDate.text ? self.aptDate.text : [NSNull null] forKey:@"Assistant"];
                [savelead setObject:self.comment.text ? self.comment.text : [NSNull null] forKey:@"Comments"];
                [savelead setObject:myActive ? myActive : [NSNumber numberWithInteger: 0] forKey:@"Active"];
                
                // Set ACL permissions for added security
                PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [postACL setPublicReadAccess:YES];
                [savelead setACL:postACL];
                
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Upload Failure" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
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
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
                NSNumber *myLeadNo = [formatter numberFromString:self.leadNo];
                NSNumber *myActive = [formatter numberFromString:self.active.text];
                
                PFObject *savelead = [PFObject objectWithClassName:@"Employee"];
                [savelead setObject:myLeadNo ? myLeadNo : [NSNumber numberWithInteger: -1] forKey:@"EmployeeNo"];
                [savelead setObject:self.company.text ? self.company.text : [NSNull null] forKey:@"Company"];
                [savelead setObject:self.address.text ? self.address.text : [NSNull null] forKey:@"Address"];
                [savelead setObject:self.city.text ? self.city.text : [NSNull null] forKey:@"City"];
                [savelead setObject:self.state.text ? self.state.text : [NSNull null] forKey:@"State"];
                [savelead setObject:self.zip.text ? self.zip.text : [NSNull null] forKey:@"Zip"];
                [savelead setObject:self.phone.text ? self.phone.text : [NSNull null] forKey:@"HomePhone"];
                [savelead setObject:self.salesman.text ? self.salesman.text : [NSNull null] forKey:@"WorkPhone"];
                [savelead setObject:self.jobName.text ? self.jobName.text : [NSNull null] forKey:@"CellPhone"];
                [savelead setObject:self.date.text ? self.date.text : [NSNull null] forKey:@"Country"];
                [savelead setObject:self.email.text ? self.email.text : [NSNull null] forKey:@"Email"];
                [savelead setObject:self.last.text ? self.last.text : [NSNull null] forKey:@"Last"];
                [savelead setObject:self.amount.text ? self.amount.text : [NSNull null] forKey:@"Department"];
                [savelead setObject:self.aptDate.text ? self.aptDate.text : [NSNull null] forKey:@"Middle"];
                [savelead setObject:self.first.text ? self.first.text : [NSNull null] forKey:@"First"];
                [savelead setObject:self.callback.text ? self.callback.text : [NSNull null] forKey:@"Manager"];
                [savelead setObject:self.adName.text ? self.adName.text : [NSNull null] forKey:@"SS"];
                [savelead setObject:self.comment.text ? self.comment.text : [NSNull null] forKey:@"Comments"];
                [savelead setObject:myActive ? myActive : [NSNumber numberWithInteger: 0] forKey:@"Active"];
                [savelead setObject:self.spouse.text ? self.spouse.text : [NSNull null] forKey:@"Title"];
                
                // Set ACL permissions for added security
                PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
                [postACL setPublicReadAccess:YES];
                [savelead setACL:postACL];
                
                [savelead saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Failure" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
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
                //NSString *_time = self.time;
                
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
