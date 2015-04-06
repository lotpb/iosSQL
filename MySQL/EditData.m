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
    //self.automaticallyAdjustsScrollViewInsets = NO; //fix
    //self.listTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
 //   self.listTableView.tableHeaderView = view; //makes header move with tablecell
    
    if ([_formController isEqual: @"Leads"]) {
        [self parseAd];
        [self parseCallback];
        
    } else if ([_formController isEqual: @"Customer"]) {
        [self parseProduct];
        [self parseContractor];
        [self parseRate];
    }
    
    if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"])) {
        [self parseSalesman];
        [self parseJob];
        //ParseConnection *parseConnection = [[ParseConnection alloc]init];
        //[parseConnection parseSalesman];
       // [parseConnection parseJob:(self.frm22)];
     
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
       [self.first setFont:CELL_FONT(CELL_FONTSIZE)];
       [self.last setFont:CELL_FONT(CELL_FONTSIZE)];
       [self.company setFont:CELL_FONT(CELL_FONTSIZE)];
        self.leadNo = self.leadNo;
    
     if ([self.frm11 isEqual:[NSNull null]])
          self.first.text = @"";
     else self.first.text = self.frm11;
    
     if ([self.frm12 isEqual:[NSNull null]])
          self.last.text = @"";
     else self.last.text = self.frm12;
    
    if ([self.frm13 isEqual:[NSNull null]])
         self.company.text = @"";
    else self.company.text = self.frm13;
    
    if ([self.frm29 isEqual:[NSNull null]])
         self.photo.text = @"";
    else self.photo.text = self.frm29;
    
    if ([_formController isEqual: @"Leads"])
        self.company.hidden = YES;
    
    if ([_formController isEqual: @"Customer"]) {
        self.company.placeholder = @"Contractor";
        self.company.inputView = [self customPicker:3];
        
    } else if ([_formController isEqual: @"Vendor"]) {
        self.first.placeholder = @"Manager";
        self.last.placeholder = @"Webpage";
        self.callback.hidden = YES;//Field
        
    } else if ([_formController isEqual: @"Employee"]) {
        self.first.placeholder = @"First";
        self.last.placeholder = @"Last";
    }
    
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
    if ( [self.frm30 isEqual:@"1"] ) { //active
         [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal];
          self.following.text = @"Following";
          self.active = @"1";}
    else { [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
            self.following.text = @"Follow";
            self.active = @"0";
         }
 
#pragma mark Form Circle Image
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

- (void)dismissKeyboard {
    // To dismiss the keyboard, we simply ask all fields to resign its focus.
    for (int i = TEXT_FIELD_TAG_OFFSET; i < TEXT_FIELD_TAG_OFFSET + NUM_TEXT_FIELD; i++) {
        [[self.view viewWithTag:i] resignFirstResponder];
    }
}

#pragma mark - Button
-(IBAction)like:(id)sender {
    UIImage *buttonImage1 = [UIImage imageNamed:@"iosStar.png"];
    UIImage *buttonImage2 = [UIImage imageNamed:@"iosStarNA.png"];
   if ([self.active isEqual:@"1"] ) {
        self.following.text = @"Follow";
        self.active = @"0";
       [self.activebutton setImage:buttonImage2 forState:UIControlStateNormal];
      } else {
        self.following.text = @"Following";
        self.active = @"1";
       [self.activebutton setImage:buttonImage1 forState:UIControlStateNormal]; }
}

#pragma mark - DatePicker
- (UIView *)datePicker:(NSUInteger)tag{
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 175)];
    pickerView.backgroundColor = [UIColor lightGrayColor];
    
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
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
    gmtDateFormatter.dateFormat = KEY_DATESQLFORMAT;
    if (datePicker.tag == 0)
        self.date.text = [gmtDateFormatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 4)
        self.aptDate.text = [gmtDateFormatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 14)
        self.start.text = [gmtDateFormatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 15)
        self.complete.text = [gmtDateFormatter stringFromDate:datePicker.date];
}

#pragma mark - ViewPicker
- (UIView *)customPicker:(NSUInteger)tag {
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    pickerView.backgroundColor = [UIColor orangeColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    toolbar.translucent = NO;
    
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
    picker.showsSelectionIndicator = YES;
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
    if ([_formController isEqual:@"Customer"])
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
    static NSString *CellIdentifier = @"BasicCell";
    UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(130, 7, 175, 30)];
    UITextView *textviewframe = [[UITextView alloc] initWithFrame:CGRectMake(130, 7, 225, 95)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        
        self.date = textframe;
       [self.date setFont:CELL_FONT(CELL_FONTSIZE)];
        if ([self.frm18 isEqual:[NSNull null]])
             self.date.text = @"";
        else self.date.text = self.frm18;
             self.date.tag = 0;
             self.date.autocorrectionType = UITextAutocorrectionTypeNo;
            [self.date setClearButtonMode:UITextFieldViewModeWhileEditing];

        if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]))
            self.date.inputView = [self datePicker:0];
            myCell.textLabel.text = @"Date";
        
        if ([_formController isEqual: @"Vendor"]) {
            self.date.placeholder = @"Profession";
            myCell.textLabel.text = @"Profession"; }
        
        else if ([_formController isEqual: @"Employee"]) {
            self.date.placeholder = @"Country";
            myCell.textLabel.text = @"Country"; }
        
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
        
        if ([_formController isEqual: @"Leads"])
            self.aptDate.inputView = [self datePicker:4];
        
        else if ([_formController isEqual: @"Customer"]) {
            self.aptDate.placeholder = @"Rate";
            self.aptDate.tag = 24;
            self.aptDate.inputView = [self customPicker:24];
            myCell.textLabel.text = @"Rate"; }
        
        else if ([_formController isEqual: @"Vendor"]) {
            self.aptDate.placeholder = @"Assistant";
            myCell.textLabel.text = @"Assistant"; }
        
        else if ([_formController isEqual: @"Employee"]) {
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
        
        if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if ([self.frm21 isEqual:[NSNull null]])
             self.salesman.text = @"";
        else self.salesman.text = self.frm21;
             self.salesman.placeholder = @"Salesman";
             myCell.textLabel.text = @"Salesman";
            [myCell.contentView addSubview:self.salesman];
             self.salesman.inputView = [self customPicker:6];

        if ([_formController isEqual: @"Vendor"]) {
            self.salesman.placeholder = @"Phone 1";
            myCell.textLabel.text = @"Phone 1"; }
        
        else if ([_formController isEqual: @"Employee"]) {
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
        
        if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        if ([_formController isEqual: @"Vendor"]) {
            self.jobName.placeholder = @"Phone 2";
            myCell.textLabel.text = @"Phone 2"; }
        
        else if ([_formController isEqual: @"Employee"]) {
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
        
        if (([_formController isEqual: @"Leads"]) || ([_formController isEqual: @"Customer"]))
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
        if ([_formController isEqual: @"Vendor"]) {
             self.adName.placeholder = @"Phone 3";
             myCell.textLabel.text = @"phone 3"; }
        
        else if ([_formController isEqual: @"Employee"]) {
             self.adName.placeholder = @"Social Security";
             myCell.textLabel.text = @"Social Security"; }
        
        else if ([_formController isEqual: @"Customer"]) {
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
        
        if (([_formController isEqual: @"Vendor"]) || ([_formController isEqual: @"Employee"])) {
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
        
        if ([_formController isEqual: @"Vendor"]) {
            self.spouse.placeholder = @"Office";
            myCell.textLabel.text = @"Office"; }
        
        else if ([_formController isEqual: @"Employee"]) {
             self.spouse.placeholder = @"Title";
             myCell.textLabel.text = @"Title"; }
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
        
        if ([_formController isEqual: @"Customer"]) {
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
        
        else if ([_formController isEqual: @"Vendor"]) {
            self.callback.placeholder = @"";
            myCell.textLabel.text = @""; }
        
        else if ([_formController isEqual: @"Employee"]) {
            self.callback.placeholder = @"Manager";
            myCell.textLabel.text = @"Manager"; }
        
        else if ([_formController isEqual: @"Leads"]) {
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
        [self performSegueWithIdentifier:@"lookupcitySegue"sender:self];
    if (indexPath.row == 6)
        [self performSegueWithIdentifier:@"lookupsalesmanSegue"sender:self];
    if (indexPath.row == 7)
        [self performSegueWithIdentifier:@"lookupjobSegue"sender:self];
    if (indexPath.row == 8)
        [self performSegueWithIdentifier:@"lookupproductSegue"sender:self];
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
/*
 - (void)scrollViewToScreenTop:(UITextField *)textField {
 // The super view of a text field is the contentView of a cell.
 // The super vie of the contentView is the cell itself.
 UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
 [self.listTableView scrollToRowAtIndexPath:[self.listTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
 } */

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

#pragma mark - Parse

- (void)parseSalesman {
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

- (void)parseJob {
    PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
    query21.cachePolicy = kPFCACHEPOLICY;
    [query21 whereKey:@"JobNo" equalTo:self.frm22];
    [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.jobName.text = [object objectForKey:@"Description"];
    }];
}

- (void)parseProduct {
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

- (void)parseAd {
    PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
    query11.cachePolicy = kPFCACHEPOLICY;
    [query11 whereKey:@"AdNo" equalTo:self.frm23];
    [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.adName.text = [object objectForKey:@"Advertiser"];
    }];
}

- (void)parseRate {
    PFQuery *query14 = [PFQuery queryWithClassName:@"Rate"];
    query14.cachePolicy = kPFCACHEPOLICY;
    [query14 selectKeys:@[@"rating"]];
    [query14 orderByDescending:@"rating"];
    [query14 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        rateArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

- (void)parseContractor {
    PFQuery *query13 = [PFQuery queryWithClassName:@"Contractor"];
    query13.cachePolicy = kPFCACHEPOLICY;
    [query13 selectKeys:@[@"Contractor"]];
    [query13 orderByDescending:@"Contractor"];
    [query13 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        contractorArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

- (void)parseCallback {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
    query1.cachePolicy = kPFCACHEPOLICY;
    [query1 selectKeys:@[@"Callback"]];
    [query1 orderByDescending:@"Callback"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callbackArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"lookupcitySegue"]) {
        LookupCity *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupsalesmanSegue"]) {
        LookupSalesman *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupjobSegue"]) {
        LookupJob *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
    if ([[segue identifier] isEqualToString:@"lookupproductSegue"]) {
        LookupProduct *addViewControler = [segue destinationViewController];
        [addViewControler setDelegate:(id)self];
        addViewControler.formController = self.formController;
    }
}

#pragma mark - EditData
-(void)updateLeads:(id)sender {
    if ([_formController isEqual: @"Leads"]) {
        NSString *_leadNo = self.leadNo;
        NSString *_active = self.active;
        /*
         NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
         gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
         gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
         NSString *dateString = [gmtDateFormatter stringFromDate:self.date.text];
         // self.date.text = dateString; */
        
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
        
        NSString *rawStr = [NSString stringWithFormat:@"_leadNo=%@&&_date=%@&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_aptdate=%@&_email=%@&_first=%@&_spouse=%@&_callback=%@&_salesNo=%@&_jobNo=%@&_adNo=%@&_active=%@&_photo=%@&", _leadNo, _date, _name, _address, _city, _state, _zip, _comments, _amount, _phone, _aptdate, _email, _first, _spouse, _callback, _salesNo, _jobNo, _adNo, _active, _photo];
        
      //  NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/updateLeads.php"];
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
    else if ([_formController isEqual: @"Customer"]) {
        //NSString *_date = self.date.text;
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
        
        NSString *rawStr = [NSString stringWithFormat:@"_custNo=%@&&_leadNo=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_quan=%@&_email=%@&_first=%@&_spouse=%@&_rate=%@&_photo=%@&_photo1=%@&_photo2=%@&_salesNo=%@&_jobNo=%@&_start=%@&_complete=%@&_productNo=%@&_contractor=%@&_active=%@&", _custNo, _leadNo, _address, _city, _state, _zip, _comments, _amount, _phone, _quan, _email,_first, _spouse, _rate, _photo, _photo1, _photo2,_salesNo, _jobNo, _start, _complete, _productNo, _contractor, _active];
        
        //NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/updateCustomer.php"];
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
    else if ([_formController isEqual: @"Vendor"]) {
        
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
        
        NSString *rawStr = [NSString stringWithFormat:@"_vendorNo=%@&&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_phone=%@&_phone1=%@&_phone2=%@&_phone3=%@&_email=%@&_webpage=%@&_department=%@&_office=%@&_manager=%@&_profession=%@&_assistant=%@&_comments=%@&_active=%@&_phonecmbo=%@&_phonecmbo1=%@&_phonecmbo2=%@&_phonecmbo3=%@&", _vendorNo, _name, _address, _city, _state, _zip, _phone, _phone1, _phone2, _phone3, _email, _webpage, _department, _office, _manager, _profession, _assistant, _comments, _active, _phonecmbo, _phonecmbo1, _phonecmbo2, _phonecmbo3];
        
        //  NSLog(@"rawStr is %@",rawStr);
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/updateVendor.php"];
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
    else if ([_formController isEqual: @"Employee"]) {
        
        NSString *_employeeNo = self.leadNo;
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
        NSString *_active = self.active;
        NSString *_employtitle = self.spouse.text;
        //  NSString *_time = self.time;
        
        NSString *rawStr = [NSString stringWithFormat:@"_employeeNo=%@&&_company=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_homephone=%@&_workphone=%@&_cellphone=%@&_country=%@&_email=%@&_last=%@&_department=%@&_middle=%@&_first=%@&_manager=%@&_social=%@&_comments=%@&_active=%@&_employtitle=%@&", _employeeNo, _company, _address, _city, _state, _zip, _homephone, _workphone, _cellphone, _country, _email, _last, _department, _middle, _first, _manager, _social, _comments, _active, _employtitle];
        
        //NSLog(@"rawStr is %@",rawStr);
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/updateEmployee.php"];
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
    
    [[self navigationController]popToRootViewControllerAnimated:YES];
}


@end
