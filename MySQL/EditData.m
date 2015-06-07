//
//  EditData.m
//  MySQL
//
//  Created by Peter Balsamo on 1/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "EditData.h"

@interface EditData ()
{
    NSMutableArray *salesArray, *callbackArray, *contractorArray, *rateArray;
}
@property (nonatomic, weak) UIStepper *defaultStepper;
@end

@implementation EditData
@synthesize custNo, leadNo, active, date, first, last, company, address, city, state, zip, phone, aptDate, email, amount, spouse, callback, saleNo, jobNo, adNo, photo, comment, rate, start, complete;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;  //fix
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.listTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
 // self.listTableView.tableHeaderView = view; //makes header move with tablecell

#pragma mark Form Circle Image
  //UIImage *profileImage = [UIImage imageNamed:@"mySQLHOME.png"];
  //self.profileImageView = [[UIImageView alloc] initWithImage:profileImage];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 8;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    
#pragma mark BarButtons
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateLeads:)];
    NSArray *actionButtonItems = @[editItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
 
    // Any tap on the view would dismiss the keyboard.
    UITapGestureRecognizer *tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.cancelsTouchesInView = NO; 
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
    [[UITextField appearance] setTintColor:CURSERCOLOR];
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    ParseConnection *parseConnection = [[ParseConnection alloc]init];
    parseConnection.delegate = (id)self;
    
    if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2])) {
         [parseConnection parseSalesPick];
    }
    if ([_formController isEqual:TNAME1]) {
        [parseConnection parseCallback];
    }
    else if ([_formController isEqual:TNAME2]) {
        [parseConnection parseRate];
        [parseConnection parseContractor];
    }
    
    [self passFieldData];
    [self parseData];
    [self activeButton];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
     self.title = [NSString stringWithFormat:@" %@ %@", @"Edit", self.formController];
    [self.first becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ParseDelegate
- (void)parseSalesmanloaded:(NSMutableArray *)salesItem {
    salesArray = salesItem;
}

- (void)parseRateloaded:(NSMutableArray *)rateItem {
    rateArray = rateItem;
}

- (void)parseContractorloaded:(NSMutableArray *)contractItem {
    contractorArray = contractItem;
}

- (void)parseCallbackloaded:(NSMutableArray *)callbackItem {
    callbackArray = callbackItem;
}

#pragma mark - Keyboard
- (void)dismissKeyboard {
    // To dismiss the keyboard, we simply ask all fields to resign its focus.
    for (int i = TEXT_FIELD_TAG_OFFSET; i < TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD; i++) {
        [[self.view viewWithTag:i] resignFirstResponder];
    }
}

#pragma mark - Button
-(IBAction)like:(id)sender {
    UIImage *buttonImage1 = [UIImage imageNamed:ACTIVEBUTTONYES];
    UIImage *buttonImage2 = [UIImage imageNamed:ACTIVEBUTTONNO];
   if ([self.active isEqual:@"1"] ) {
        self.following.text = @"Follow";
        self.active = @"0";
       [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
      } else {
        self.following.text = @"Following";
        self.active = @"1";
       [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal]; }
}

-(void)activeButton {
    UIImage *buttonImage1 = [UIImage imageNamed:ACTIVEBUTTONYES];
    UIImage *buttonImage2 = [UIImage imageNamed:ACTIVEBUTTONNO];
    if ( [self.frm30 isEqual:@"1"] ) { //active
        [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
        self.following.text = @"Following";
        self.active = @"1";}
    else { [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
        self.following.text = @"Follow";
        self.active = @"0";
    }
}

#pragma mark - DatePicker
- (UIView *)datePicker:(NSUInteger)tag {
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = DATEPKCOLOR;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    datePicker.tag = tag;
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
    if (datePicker.tag == 0)
        self.date.text = [formatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 4)
        self.aptDate.text = [formatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 14)
        self.start.text = [formatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 15)
        self.complete.text = [formatter stringFromDate:datePicker.date]; }
}

#pragma mark - ViewPicker
- (UIView *)customPicker:(NSUInteger)tag {
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    pickerView.backgroundColor = PICKCOLOR;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    toolbar.barStyle = PICKTOOLSTYLE;
    toolbar.translucent = PICKTOOLTRANS;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClicked)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [toolbar setItems:barItems animated:YES];
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    picker.tag = tag;
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = SHOWIND;
    //[self.pickerView selectRow:3 inComponent:0 animated:NO];
   // [picker selectRow:3 inComponent:0 animated:YES];
    [pickerView addSubview:picker];
    [pickerView addSubview:toolbar];
    
    [picker reloadAllComponents];
    return pickerView;
}

-(void)doneClicked {
    [self.view endEditing:YES];
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 6)
        return 1;
    else if(pickerView.tag == 12)
        return 1;
    else if(pickerView.tag == 3)
        return 1;
    else if(pickerView.tag == 24)
        return 1;
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 6)
        return salesArray.count;
    else if(pickerView.tag == 12)
        return callbackArray.count;
     else if(pickerView.tag == 3)
        return contractorArray.count;
     else if(pickerView.tag == 24)
         return rateArray.count;
    return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    if (pickerView.tag == 6)
        return[[salesArray objectAtIndex:row]valueForKey:@"Salesman"];
    else if(pickerView.tag == 12)
        return[[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
    else if(pickerView.tag == 3)
        return[[contractorArray objectAtIndex:row]valueForKey:@"Contractor"];
    else if(pickerView.tag == 24)
        return[[rateArray objectAtIndex:row]valueForKey:@"rating"];
    return result;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 6) {
        self.saleNo = [[salesArray objectAtIndex:row]valueForKey:@"SalesNo"];
        self.salesman.text = [[salesArray objectAtIndex:row]valueForKey:@"Salesman"]; }
    else if(pickerView.tag == 12)
        self.callback.text = [[callbackArray objectAtIndex:row]valueForKey:@"Callback"];
    else if(pickerView.tag == 3)
        self.company.text = [[contractorArray objectAtIndex:row]valueForKey:@"Contractor"];
    else if(pickerView.tag == 24)
        self.aptDate.text = [[rateArray objectAtIndex:row]valueForKey:@"rating"];
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 1;
} 

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of feed items (initially 0)
    if ([_formController isEqual:TNAME2])
    return 16;
    else
    return 14;
}

//Comment Field Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = ROW_HEIGHT;
    switch ([indexPath row])
    {
        case 13:
        {
            result = 100;
            break;
        }
    }
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, 175, 30)];
    UITextView *textviewframe = [[UITextView alloc] initWithFrame:CGRectMake(130, 7, 225, 95)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        
        self.date = textframe;
        //self.date.borderStyle = TEXTBDSTYLE;
        //self.date.layer.borderColor = TEXTBDCOLOR;
        //self.date.layer.borderWidth = TEXTBDWIDTH;
        //self.date.layer.cornerRadius = TEXTBDRADIUS;
       [self.date setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm18 isEqual:[NSNull null]])
             self.date.text = @"";
        else self.date.text = self.frm18;
             self.date.tag = 0;
             self.date.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.date setClearButtonMode:UITextFieldViewModeWhileEditing];

        if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]))
            self.date.inputView = [self datePicker:0];
            myCell.textLabel.text = @"Date";
        
        if ([_formController isEqual:TNAME3]) {
            self.date.placeholder = @"Profession";
            myCell.textLabel.text = @"Profession"; }
        
        else if ([_formController isEqual:TNAME4]) {
            self.date.placeholder = @"Title";
            myCell.textLabel.text = @"Title"; }
        
        else self.date.placeholder = @"Date";
           [myCell.contentView addSubview:self.date];

    } else if (indexPath.row == 1) {
        
        self.address = textframe;
       [self.address setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm14 isEqual:[NSNull null]])
             self.address.text = @"";
        else self.address.text = self.frm14;
             self.address.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.address setClearButtonMode:UITextFieldViewModeWhileEditing];
             self.address.placeholder = @"Address";
         myCell.textLabel.text = @"Address";
        [myCell.contentView addSubview:self.address];
        
    } else if (indexPath.row == 2) {
       
        self.city = textframe;
       [self.city setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm15 isEqual:[NSNull null]])
             self.city.text = @"";
        else self.city.text = self.frm15;
        self.city.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.city setClearButtonMode:UITextFieldViewModeWhileEditing];
         myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
         self.city.placeholder = @"City";
         myCell.textLabel.text = @"City";
        [myCell.contentView addSubview:self.city];
        
    } else if (indexPath.row == 3) {
        
        self.state = textframe;
       [self.state setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm16 isEqual:[NSNull null]])
             self.state.text = @"";
        else self.state.text = self.frm16;
             self.state.adjustsFontSizeToFitWidth = YES;
             self.state.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.state setClearButtonMode:UITextFieldViewModeWhileEditing];
             self.state.placeholder = @"State";
         myCell.textLabel.text = @"State";
        [myCell.contentView addSubview:self.state];
        
        UITextField *aptframe = [[UITextField alloc] initWithFrame:CGRectMake(220, 7, 80, 30)];
        self.zip = aptframe;
       [self.zip setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm17 isEqual:[NSNull null]])
             self.zip.text = @"";
        else self.zip.text = self.frm17;
             self.zip.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.zip setClearButtonMode:UITextFieldViewModeWhileEditing];
             self.zip.placeholder = @"Zip";
        [myCell.contentView addSubview:self.zip];
        
    } else if (indexPath.row == 4) {
        
        self.aptDate = textframe;
        if ([self.frm19 isEqual:[NSNull null]])
             self.aptDate.text = @"";
        else self.aptDate.text = self.frm19;
            [self.aptDate setFont:CELL_FONT(CELL_FONTSIZE)];
             self.aptDate.tag = 4;
             self.aptDate.placeholder = @"Apt Date";
             self.aptDate.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.aptDate setClearButtonMode:UITextFieldViewModeWhileEditing];
        myCell.textLabel.text = @"Apt Date";
        
        if ([_formController isEqual:TNAME1])
            self.aptDate.inputView = [self datePicker:4];
        
        else if ([_formController isEqual:TNAME2]) {
            self.aptDate.placeholder = @"Rate";
            self.aptDate.tag = 24;
            self.aptDate.inputView = [self customPicker:24];
            myCell.textLabel.text = @"Rate"; }
        
        else if ([_formController isEqual:TNAME3]) {
            self.aptDate.placeholder = @"Assistant";
            myCell.textLabel.text = @"Assistant"; }
        
        else if ([_formController isEqual:TNAME4]) {
            self.aptDate.placeholder = @"Middle";
            myCell.textLabel.text = @"Middle"; }
        
           [myCell.contentView addSubview:self.aptDate];
        
    } else if (indexPath.row == 5) {
        
         self.phone = textframe;
        [self.phone setFont:CELL_FONT(CELL_FONTSIZE)];
         self.phone.placeholder = @"Phone";
         self.phone.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.phone setClearButtonMode:UITextFieldViewModeWhileEditing];
        if (self.frm20.length == 0)
            self.phone.text = @"(516)";
       else self.phone.text = self.frm20;
         myCell.textLabel.text = @"Phone";
        [myCell.contentView addSubview:self.phone];
        
    } else if (indexPath.row == 6) {
        
         self.salesman = textframe;
        [self.salesman setFont:CELL_FONT(CELL_FONTSIZE)];
         self.salesman.tag = 6;
         self.salesman.adjustsFontSizeToFitWidth = YES;
         self.salesman.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.salesman setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if ([self.frm21 isEqual:[NSNull null]])
             self.salesman.text = @"";
        else self.salesman.text = self.frm21;
             self.salesman.placeholder = @"Salesman";
             myCell.textLabel.text = @"Salesman";
            [myCell.contentView addSubview:self.salesman];
             self.salesman.inputView = [self customPicker:6];

        if ([_formController isEqual:TNAME3]) {
            self.salesman.placeholder = @"Phone 1";
            myCell.textLabel.text = @"Phone 1"; }
        
        else if ([_formController isEqual:TNAME4]) {
            self.salesman.placeholder = @"Work Phone";
            myCell.textLabel.text = @"Work Phone"; }
        
    } else if (indexPath.row == 7) {
         self.jobName = textframe;
        [self.jobName setFont:CELL_FONT(CELL_FONTSIZE)];
         self.jobName.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.jobName setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm22 isEqual:[NSNull null]])
             self.jobName.text = @"";
        else self.jobName.text = self.frm22;
        
        if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        if ([_formController isEqual:TNAME3]) {
            self.jobName.placeholder = @"Phone 2";
            myCell.textLabel.text = @"Phone 2"; }
        
        else if ([_formController isEqual:TNAME4]) {
            self.jobName.placeholder = @"Cell Phone";
            myCell.textLabel.text = @"Cell Phone";
          } else {
            self.jobName.placeholder = @"Job";
            myCell.textLabel.text = @"Job"; }
      
        [myCell.contentView addSubview:self.jobName];
        
    } else if (indexPath.row == 8) {
        self.adName = textframe;
        [self.adName setFont:CELL_FONT(CELL_FONTSIZE)];
        self.adName.placeholder = @"Advertiser";
        self.adName.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.adName setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm23 isEqual:[NSNull null]])
            self.adName.text = @"";
        else self.adName.text = self.frm23;
        
        if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        if ([_formController isEqual:TNAME3]) {
            self.adName.placeholder = @"Phone 3";
            myCell.textLabel.text = @"phone 3"; }
        
        else if ([_formController isEqual:TNAME4]) {
            self.adName.placeholder = @"Social Security";
            myCell.textLabel.text = @"Social Security"; }
        
        else if ([_formController isEqual:TNAME2]) {
            self.adName.placeholder = @"Product";
            myCell.textLabel.text = @"Product"; }
        else myCell.textLabel.text = @"Advertiser";
        
        [myCell.contentView addSubview:self.adName];
        
    } else if(indexPath.row == 9) {
    
         self.amount = textframe;
        [self.amount setFont:CELL_FONT(CELL_FONTSIZE)];
         self.amount.placeholder = @"Amount";
         self.amount.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.amount setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm24 isEqual:[NSNull null]])
             self.amount.text = @"";
        else self.amount.text = self.frm24;
            myCell.textLabel.text = @"Amount";
        
        if (([_formController isEqual:TNAME3]) || ([_formController isEqual:TNAME4])) {
             self.amount.placeholder = @"Department";
             myCell.textLabel.text = @"Department"; }

        [myCell.contentView addSubview:self.amount];
        
    } else if (indexPath.row == 10) {
        
         self.email = textframe;
        [self.email setFont:CELL_FONT(CELL_FONTSIZE)];
         self.email.placeholder = @"Email";
        if ([self.frm25 isEqual:[NSNull null]])
             self.email.text = @"";
        else self.email.text = self.frm25;
         self.email.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.email setClearButtonMode:UITextFieldViewModeWhileEditing];
         self.email.keyboardType = UIKeyboardTypeEmailAddress;
         self.email.returnKeyType = UIReturnKeyNext;
         myCell.textLabel.text = @"Email";
        [myCell.contentView addSubview:self.email];
        
    } else if(indexPath.row == 11) {
         self.spouse = textframe;
        [self.spouse setFont:CELL_FONT(CELL_FONTSIZE)];
         self.spouse.placeholder = @"Spouse";
         self.spouse.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.spouse setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm26 isEqual:[NSNull null]])
             self.spouse.text = @"";
        else self.spouse.text = self.frm26;
        
        if ([_formController isEqual:TNAME3]) {
            self.spouse.placeholder = @"Office";
            myCell.textLabel.text = @"Office"; }
        
        else if ([_formController isEqual:TNAME4]) {
             self.spouse.placeholder = @"Country";
             myCell.textLabel.text = @"Country"; }
             else myCell.textLabel.text = @"Spouse";

        [myCell.contentView addSubview:self.spouse];
        
    } else if (indexPath.row == 12) {
         self.callback = textframe;
        [self.callback setFont:CELL_FONT(CELL_FONTSIZE)];
         self.callback.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.callback setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm27 isEqual:[NSNull null]])
             self.callback.text = @"";
        else self.callback.text = self.frm27;
        
    if ([_formController isEqual:TNAME2]) {
        self.callback.placeholder = @"Quan";
        myCell.textLabel.text = @"# Windows";
        [self.callback setClearButtonMode:UITextFieldViewModeNever];
        
        UIStepper *stepper = [[UIStepper alloc] init];
        stepper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [stepper setTintColor:[UIColor grayColor]];
        stepper.value = [self.callback.text doubleValue];
        stepper.stepValue = 1;
        UIView *wrapper = [[UIView alloc] initWithFrame:stepper.frame];
        [wrapper addSubview:stepper];
        myCell.accessoryView = stepper;
        [stepper addTarget:self action:@selector(changestep:) forControlEvents:UIControlEventValueChanged];
    }
        
    else if ([_formController isEqual:TNAME3]) {
        self.callback.placeholder = @"";
        myCell.textLabel.text = @""; }
        
    else if ([_formController isEqual:TNAME4]) {
        self.callback.placeholder = @"Manager";
        myCell.textLabel.text = @"Manager"; }
        
    else if ([_formController isEqual:TNAME1]) {
        self.callback.placeholder = @"Call Back";
        myCell.textLabel.text = @"Call Back";
        self.callback.inputView = [self customPicker:12]; }
        [myCell.contentView addSubview:self.callback];
        
    } else if (indexPath.row == 13) {
         self.comment = textviewframe;
        [self.comment setFont:CELL_FONT(CELL_FONTSIZE)];
         self.comment.autocorrectionType = UITextAutocorrectionTypeNo;
        if ([self.frm28 isEqual:[NSNull null]])
             self.comment.text = @"";
        else self.comment.text = self.frm28;
         myCell.textLabel.text = @"Comments";
        [myCell.contentView addSubview:self.comment];
        
    } else if(indexPath.row == 14) {
         self.start = textframe;
        [self.start setFont:CELL_FONT(CELL_FONTSIZE)];
         self.start.tag = 14;
         self.start.placeholder = @"Start Date";
         self.start.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.start setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm31 isEqual:[NSNull null]])
             self.start.text = @"";
        else self.start.text = self.frm31;
      //  if ([_formController isEqual: @"Customer"])
             self.start.inputView = [self datePicker:14];
         myCell.textLabel.text = @"Start Date";
        [myCell.contentView addSubview:self.start];
 
    } else if(indexPath.row == 15) {
         self.complete = textframe;
        [self.complete setFont:CELL_FONT(CELL_FONTSIZE)];
         self.complete.tag = 15;
         self.complete.placeholder = @"Completion Date";
         self.complete.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.complete setClearButtonMode:UITextFieldViewModeWhileEditing];
        if ([self.frm32 isEqual:[NSNull null]])
             self.complete.text = @"";
        else self.complete.text = self.frm32;
      //  if ([_formController isEqual: @"Customer"])
             self.complete.inputView = [self datePicker:15];
         myCell.textLabel.text = @"Completion Date";
        [myCell.contentView addSubview:self.complete];
      // myCell.clipsToBounds = YES;
    }
    
   /*
    self.date.delegate = self; self.address.delegate = self;
    self.city.delegate = self; self.state.delegate = self;
    self.aptDate.delegate = self; self.phone.delegate = self;
    self.salesman.delegate = self; self.jobName.delegate = self;
    self.adName.delegate = self; self.amount.delegate = self;
    self.email.delegate = self; self.spouse.delegate = self;
    self.callback.delegate = self; self.start.delegate = self;
    self.complete.delegate = self;
    //  self.comment.delegate = self; */
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        [self performSegueWithIdentifier:EDITLOOKCITYSEGUE sender:self];
    if (indexPath.row == 6)
        [self performSegueWithIdentifier:EDITLOOKSALESEGUE sender:self];
    if (indexPath.row == 7)
        [self performSegueWithIdentifier:EDITLOOKJOBSEGUE sender:self];
    if (indexPath.row == 8)
        [self performSegueWithIdentifier:EDITLOOKPRODSEGUE sender:self];
}

#pragma mark - TableView Header/Footer
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:
(NSInteger)section {
    NSString *headerTitle;
    if (section == 0)
        headerTitle = HEADERTITLE;
  
    return headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section {
    NSString *footerTitle;
    if (section == 0)
        footerTitle = FOOTERTITLE;
 
    return footerTitle;
}

#pragma mark - Stepper
- (void) changestep:(UIStepper *)sender {
    double va = [sender value];
    [self.callback setText:[NSString stringWithFormat:@"%d", (int)va]];
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

- (void)salesFromController:(NSString *)passedData{
    self.saleNo = passedData;
}

- (void)salesNameFromController:(NSString *)passedData{
    self.salesman.text = passedData;
}

#pragma mark - FieldData
- (void)passFieldData {
    [self.first setFont:CELL_FONT(CELL_FONTSIZE)];
    [self.last setFont:CELL_FONT(CELL_FONTSIZE)];
    [self.company setFont:CELL_FONT(CELL_FONTSIZE)];
    self.leadNo = self.leadNo;
    
    if ([self.frm11 isEqual:[NSNull null]])
        self.first.text = @"";
    else self.first.text = self.frm11;
    
    if ([self.frm12 isEqual:[NSNull null]])
        self.last.text = @"";
        else {
        self.last.text = self.frm12;
        self.last.borderStyle = TEXTBDSTYLE;
        self.last.layer.borderColor = TEXTBDCOLOR;
        self.last.layer.borderWidth = TEXTBDWIDTH;
        self.last.layer.cornerRadius = TEXTBDRADIUS;}
    
    if ([self.frm13 isEqual:[NSNull null]])
        self.company.text = @"";
    else self.company.text = self.frm13;
    
    if ([self.frm29 isEqual:[NSNull null]])
        self.photo.text = @"";
    else self.photo.text = self.frm29;
    
    if ([_formController isEqual:TNAME1])
        self.company.hidden = YES;
    
    if ([_formController isEqual:TNAME2]) {
        self.company.placeholder = @"Contractor";
        self.company.inputView = [self customPicker:3];
      } else if ([_formController isEqual:TNAME3]) {
        self.first.placeholder = @"Manager";
        self.last.placeholder = @"Webpage";
        self.callback.hidden = YES;//Field
      } else if ([_formController isEqual:TNAME4]) {
        self.first.placeholder = @"First";
        self.last.placeholder = @"Last";
    }
}
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
#pragma mark - Parse
- (void)parseData {
    if ([_formController isEqual:TNAME1]) {
        
        PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
        query11.cachePolicy = kPFCACHEPOLICY;
        [query11 whereKey:@"AdNo" equalTo:self.frm23];
        [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else
                self.adName.text = [object objectForKey:@"Advertiser"];
        }];
        
    } else if ([_formController isEqual:TNAME2]) {
        
        PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
        query3.cachePolicy = kPFCACHEPOLICY;
        [query3 whereKey:@"ProductNo" containsString:self.frm23];
        [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else
                self.adName.text = [object objectForKey:@"Products"];
        }];
    }
    
    if (([_formController isEqual:TNAME1]) || ([_formController isEqual:TNAME2])) {
        
        PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
        query21.cachePolicy = kPFCACHEPOLICY;
        [query21 whereKey:@"JobNo" equalTo:self.frm22];
        [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else
                self.jobName.text = [object objectForKey:@"Description"];
        }];
        
        PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
        query31.cachePolicy = kPFCachePolicyCacheElseNetwork;
        [query31 whereKey:@"SalesNo" equalTo:self.frm21];
        [query31 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"The getFirstObject request failed.");
            } else
                self.salesman.text = [object objectForKey:@"Salesman"];
        }];
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:EDITLOOKCITYSEGUE]) {
        LookupCity *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:EDITLOOKSALESEGUE]) {
        LookupSalesman *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:EDITLOOKJOBSEGUE]) {
        LookupJob *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:EDITLOOKPRODSEGUE]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}

#pragma mark - EditData
-(void)updateLeads:(id)sender {
    if ([_formController isEqual:TNAME1]) { //leads
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //updateParseLead
            [self.listTableView reloadData];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
            [query whereKey:@"objectId" equalTo:self.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateData, NSError *error) {
                if (!error) {
                    // [updateData setObject:self.leadNo forKey:@"LeadNo"];
                    // [updateData setObject:self.active forKey:@"Active"];//
                    [updateData setObject:self.date.text forKey:@"Date"];
                    [updateData setObject:self.first.text forKey:@"First"];
                    [updateData setObject:self.last.text forKey:@"LastName"];
                    [updateData setObject:self.address.text forKey:@"Address"];
                    [updateData setObject:self.city.text forKey:@"City"];
                    [updateData setObject:self.state.text forKey:@"State"];
                    // [updateData setObject:self.zip.text forKey:@"Zip"];
                    [updateData setObject:self.phone.text forKey:@"Phone"];
                    [updateData setObject:self.aptDate.text forKey:@"AptDate"];
                    [updateData setObject:self.email.text forKey:@"Email"];
                    // [updateData setObject:self.amount.text forKey:@"Amount"];//
                    [updateData setObject:self.spouse.text forKey:@"Spouse"];
                    [updateData setObject:self.callback.text forKey:@"CallBack"];
                    // [updateData setObject:self.saleNo forKey:@"SalesNo"];
                    // [updateData setObject:self.jobNo forKey:@"JobNo"];
                    // [updateData setObject:self.adNo forKey:@"AdNo"];
                    [updateData setObject:self.comment.text forKey:@"Coments"];
                    [updateData setObject:self.photo.text forKey:@"Photo"];
                    [updateData saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully updated the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } else {
            NSString *_leadNo = self.leadNo;
            NSString *_active = self.active;
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
            NSString *_salesNo = self.saleNo;
            NSString *_jobNo = self.jobNo;
            NSString *_adNo = self.adNo;
            NSString *_comments = self.comment.text;
            NSString *_photo = self.photo.text;
            // NSString *_time = self.time;
            
            NSString *rawStr = [NSString stringWithFormat:UPDATELEADFIELD, UPDATELEADFIELD1];
            //  NSLog(@"rawStr is %@",rawStr);
            NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:UPDATELEADURL];
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
    else if ([_formController isEqual:TNAME2]) { //customer
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //updateParseCust
            [self.listTableView reloadData];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
            [query whereKey:@"objectId" equalTo:self.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateData, NSError *error) {
                if (!error) {
                    [updateData setObject:self.date.text forKey:@"Date"];
                    [updateData setObject:self.custNo forKey:@"CustNo"];//
                    [updateData setObject:self.leadNo forKey:@"LeadNo"];
                    [updateData setObject:self.address.text forKey:@"Address"];
                    [updateData setObject:self.city.text forKey:@"City"];
                    [updateData setObject:self.state.text forKey:@"State"];
                    [updateData setObject:self.zip.text forKey:@"Zip"];
                    [updateData setObject:self.comment.text forKey:@"Comments"];
                    [updateData setObject:self.amount.text forKey:@"Amount"];
                    [updateData setObject:self.phone.text forKey:@"Phone"];
                    [updateData setObject:self.callback.text forKey:@"Quan"];//
                    [updateData setObject:self.email.text forKey:@"Email"];
                    [updateData setObject:self.first.text forKey:@"First"];
                    [updateData setObject:self.spouse.text forKey:@"Spouse"];
                    [updateData setObject:self.aptDate forKey:@"Rate"];
                    [updateData setObject:self.photo forKey:@"Photo"];
                    [updateData setObject:self.saleNo forKey:@"SalesNo"];
                    [updateData setObject:self.jobNo forKey:@"JobNo"];
                    [updateData setObject:self.start.text forKey:@"Start"];
                    [updateData setObject:self.complete.text forKey:@"Completion"];
                    [updateData setObject:self.adNo forKey:@"ProductNo"];
                    [updateData setObject:self.company.text forKey:@"Contractor"];
                    [updateData setObject:self.active forKey:@"Active"];
                    [updateData saveInBackground];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully updated the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } else {
            NSString *_date = self.date.text;
            NSString *_custNo = self.custNo;
            NSString *_leadNo = self.leadNo;
            NSString *_address = self.address.text;
            NSString *_city = self.city.text;
            NSString *_state = self.state.text;
            NSString *_zip = self.zip.text;
            NSString *_comments = self.comment.text;
            NSString *_amount = self.amount.text;
            NSString *_phone = self.phone.text;
            NSString *_quan = self.callback.text;
            NSString *_email = self.email.text;
            NSString *_first = self.first.text;
            NSString *_spouse = self.spouse.text;
            NSString *_rate = self.aptDate.text;
            NSString *_photo = self.photo.text;
            NSString *_photo1 = nil;
            NSString *_photo2 = nil;
            NSString *_salesNo = self.saleNo;
            NSString *_jobNo = self.jobNo;
            NSString *_start = self.start.text;
            NSString *_complete = self.complete.text;
            NSString *_productNo = self.adNo;
            NSString *_contractor = self.company.text;
            NSString *_active = self.active;
            //  NSString *_time = self.time;
            
            NSString *rawStr = [NSString stringWithFormat:UPDATECUSTFIELD, UPDATECUSTFIELD1];
            
            NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:UPDATECUSTURL];
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
    else if ([_formController isEqual:TNAME3]) {//vendor
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //updateParseVendor
            [self.listTableView reloadData];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
            [query whereKey:@"objectId" equalTo:self.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateData, NSError *error) {
                if (!error) {
                    [updateData setObject:self.leadNo forKey:@"VendorNo"];
                    [updateData setObject:self.company.text forKey:@"Vendor"];//
                    [updateData setObject:self.address.text forKey:@"Address"];
                    [updateData setObject:self.city.text forKey:@"City"];
                    [updateData setObject:self.state.text forKey:@"State"];
                    [updateData setObject:self.zip.text forKey:@"Zip"];
                    [updateData setObject:self.phone.text forKey:@"Phone"];
                    [updateData setObject:self.salesman.text forKey:@"Phone1"];
                    [updateData setObject:self.jobName.text forKey:@"Phone2"];
                    [updateData setObject:self.adName.text forKey:@"Phone3"];
                    [updateData setObject:self.email.text forKey:@"Email"];
                    [updateData setObject:self.last.text forKey:@"WebPage"];
                    [updateData setObject:self.amount.text forKey:@"Department"];//
                    [updateData setObject:self.spouse.text forKey:@"Office"];
                    [updateData setObject:self.first.text forKey:@"Manager"];
                    [updateData setObject:self.date.text forKey:@"Profession"];
                    [updateData setObject:self.aptDate.text forKey:@"Assistant"];
                    [updateData setObject:self.comment.text forKey:@"Comments"];
                    [updateData setObject:self.active forKey:@"Active"];
                    [updateData saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully updated the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } else {
            NSString *_vendorNo = self.leadNo;
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
            NSString *_manager = self.first.text;
            NSString *_profession = self.date.text;
            NSString *_assistant = self.aptDate.text;
            NSString *_comments = self.comment.text;
            NSString *_active = self.active;
            NSString *_phonecmbo = nil;
            NSString *_phonecmbo1 = nil;
            NSString *_phonecmbo2 = nil;
            NSString *_phonecmbo3 = nil;
            //  NSString *_time = self.time;
            
            NSString *rawStr = [NSString stringWithFormat:UPDATEVENDORFIELD, UPDATEVENDORFIELD1];
            
            NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:UPDATEVENDORURL];
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
    else if ([_formController isEqual:TNAME4]) { //employee
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //updateParseEmployee
            [self.listTableView reloadData];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Employee"];
            [query whereKey:@"objectId" equalTo:self.objectId];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateData, NSError *error) {
                if (!error) {
                    [updateData setObject:self.leadNo forKey:@"EmployeeNo"];
                    [updateData setObject:self.company.text forKey:@"Company"];//
                    [updateData setObject:self.address.text forKey:@"Address"];
                    [updateData setObject:self.city.text forKey:@"City"];
                    [updateData setObject:self.state.text forKey:@"State"];
                    [updateData setObject:self.zip.text forKey:@"Zip"];
                    [updateData setObject:self.phone.text forKey:@"HomePhone"];
                    [updateData setObject:self.salesman.text forKey:@"WorkPhone"];
                    [updateData setObject:self.jobName.text forKey:@"CellPhone"];
                    [updateData setObject:self.spouse.text forKey:@"Country"];
                    [updateData setObject:self.email.text forKey:@"Email"];
                    [updateData setObject:self.last.text forKey:@"Last"];
                    [updateData setObject:self.amount.text forKey:@"Department"];//
                    [updateData setObject:self.aptDate.text forKey:@"Middle"];
                    [updateData setObject:self.first.text forKey:@"First"];
                    [updateData setObject:self.callback forKey:@"Manager"];
                    [updateData setObject:self.adName forKey:@"SS"];
                    [updateData setObject:self.comment forKey:@"Comments"];
                    [updateData setObject:self.active forKey:@"Active"];
                    [updateData setObject:self.date.text forKey:@"Title"];
                    [updateData saveInBackground];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully updated the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } else {
            NSString *_employeeNo = self.leadNo;
            NSString *_company = self.company.text;
            NSString *_address = self.address.text;
            NSString *_city = self.city.text;
            NSString *_state = self.state.text;
            NSString *_zip = self.zip.text;
            NSString *_homephone = self.phone.text;
            NSString *_workphone = self.salesman.text;
            NSString *_cellphone = self.jobName.text;
            NSString *_country = self.spouse.text;
            NSString *_email = self.email.text;
            NSString *_last = self.last.text;
            NSString *_department = self.amount.text;
            NSString *_middle = self.aptDate.text;
            NSString *_first = self.first.text;
            NSString *_manager = self.callback.text;
            NSString *_social = self.adName.text;
            NSString *_comments = self.comment.text;
            NSString *_active = self.active;
            NSString *_employtitle = self.date.text;
            //  NSString *_time = self.time;
            
            NSString *rawStr = [NSString stringWithFormat:UPDATEEMPLOYEEFIELD, UPDATEEMPLOYEEFIELD1];
            
            NSURL *url = [NSURL URLWithString:UPDATEEMPLOYEEURL];
            NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
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
