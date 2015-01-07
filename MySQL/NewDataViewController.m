//
//  NewDataViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 1/1/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NewDataViewController.h"
#import "JobLocation.h"
//#import "AddData.h"

@interface NewDataViewController ()
{
   JobModel *_JobModel; NSMutableArray *_feedItemsJ;
   JobLocation *itemJ;
   NSMutableArray *salesArray, *adArray, *zipArray, *productArray;
}

@end

@implementation NewDataViewController
@synthesize active, date, first, last, company, address, city, state, zip, phone, aptDate, email, amount, spouse, callback, saleNo, jobNo, adNo, time, photo, comment;

//int tagpicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _feedItemsJ = [[NSMutableArray alloc] init];
    _JobModel = [[JobModel alloc] init];
    _JobModel.delegate = self; [_JobModel downloadItems];
   
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"SalesNo"];
    [query whereKey:@"Active" containsString:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Advertising"];
     query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query1 selectKeys:@[@"AdNo"]];
    [query1 selectKeys:@[@"Advertiser"]];
    [query1 orderByDescending:@"Advertiser"];
    [query1 whereKey:@"Active" containsString:@"Active"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Zip"];
     query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query2 selectKeys:@[@"ZipNo"]];
    [query2 selectKeys:@[@"City"]];
    [query2 selectKeys:@[@"State"]];
    [query2 selectKeys:@[@"zipCode"]];
    [query2 orderByDescending:@"City"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        zipArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
    query3.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query3 selectKeys:@[@"ProductNo"]];
    [query3 selectKeys:@[@"Products"]];
    [query3 orderByDescending:@"Products"];
    [query3 whereKey:@"Active" containsString:@"Active"];
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        productArray = [[NSMutableArray alloc]initWithArray:objects];
    }];

    if (self.date.text.length == 0) {
        NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
        gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
        gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [gmtDateFormatter stringFromDate:[NSDate date]];
        self.date.text = dateString;
        self.aptDate.text = dateString;
        self.time = dateString;
    }
    
    self.aptDate.inputView = [self datePicker];
    self.saleNo.inputView = [self customPicker:1];
    self.jobNo.inputView = [self customPicker:2];
    self.adNo.inputView = [self customPicker:3];
    self.city.inputView = [self customPicker:4];
    self.active = @"1";
    self.phone.text = @"(516)";
    //self.callback.text = @"none";
  
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 8;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[saveItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[UITextView appearance] setTintColor:[UIColor grayColor]];
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title =  @"New Data";
    [self.first becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.aptDate.text = [gmtDateFormatter stringFromDate:datePicker.date];
}

-(void)itemsDownloaded:(NSMutableArray *)items
{
    _feedItemsJ = items;
  //  NSLog(@"Incoming array: %@", items);
}
#pragma mark - PickerView
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1)
        return 1;
    else if(pickerView.tag == 2)
        return 1;
    else if(pickerView.tag == 3)
        return 1;
    else if(pickerView.tag == 4)
        return 1;
    
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
       return salesArray.count;
   else if(pickerView.tag == 2)
       return _feedItemsJ.count;
   else if(pickerView.tag == 3)
       return adArray.count;
   else if(pickerView.tag == 4)
       return zipArray.count;
    
   return 0;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = nil;
    
    if (pickerView.tag == 1)
        return[[salesArray objectAtIndex:row]valueForKey:@"Salesman"];
    else if(pickerView.tag == 2) {
        itemJ = _feedItemsJ[row];
        return itemJ.jobdescription; }
    else if(pickerView.tag == 3)
        return[[adArray objectAtIndex:row]valueForKey:@"Advertiser"];
    else if(pickerView.tag == 4)
        return[[zipArray objectAtIndex:row]valueForKey:@"City"];
    
    return result;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1)
        self.saleNo.text = [[salesArray objectAtIndex:row]valueForKey:@"SalesNo"];
    else if(pickerView.tag == 2) {
        itemJ = _feedItemsJ[row];
        self.jobNo.text = itemJ.jobNo; }
    else if(pickerView.tag == 3)
        self.adNo.text = [[adArray objectAtIndex:row]valueForKey:@"AdNo"];
    else if(pickerView.tag == 4) {
        self.city.text = [[zipArray objectAtIndex:row]valueForKey:@"City"];
        self.state.text = [[zipArray objectAtIndex:row]valueForKey:@"State"];
        self.zip.text = [[zipArray objectAtIndex:row]valueForKey:@"zipCode"];
        }
}
#pragma mark - CustomPicker

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
// not working
-(void)doneClicked:(UIBarButtonItem*)button
{
    [self.view endEditing:YES];
}

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

#pragma mark - New Leads
-(void)share:(id)sender {
    
 // NSString *_leadNo = self.leadNo;
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
    NSString *_salesNo = self.saleNo.text;
    NSString *_jobNo = self.jobNo.text;
    NSString *_adNo = self.adNo.text;
    NSString *_comments = self.comment.text;
    NSString *_time = self.time;
    NSString *_photo = self.photo.text;
    
    NSString *rawStr = [NSString stringWithFormat:@"_date=%@&&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_aptdate=%@&_email=%@&_first=%@&_spouse=%@&_callback=%@&_salesNo=%@&_jobNo=%@&_adNo=%@&_active=%@&_time=%@&_photo=%@&", _date, _name, _address, _city, _state, _zip, _comments, _amount, _phone, _aptdate, _email, _first, _spouse, _callback, _salesNo, _jobNo, _adNo, _active, _time, _photo];
    
    NSLog(@"rawStr is %@",rawStr);
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveLeads.php"];
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
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
    
   [self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
    
   // [self performSegueWithIdentifier:@"homeReturnSegue"sender:self];

}

#pragma mark - New Customer
-(void)shareCust:(id)sender {
    
    // NSString *_leadNo = self.leadNo;
    NSString *_active = self.active;
    NSString *_date = self.date.text;
    NSString *_first = self.first.text;
    NSString *_leadNo = self.last.text;
    NSString *_address = self.address.text;
    NSString *_city = self.city.text;
    NSString *_state = self.state.text;
    NSString *_zip = self.zip.text;
    NSString *_phone = self.phone.text;
    NSString *_start = self.aptDate.text;
    NSString *_email = self.email.text;
    NSString *_amount = self.amount.text;
    NSString *_spouse = self.spouse.text;
    NSString *_rate = self.callback.text;
    NSString *_salesNo = self.saleNo.text;
    NSString *_jobNo = self.jobNo.text;
    NSString *_productNo = self.adNo.text;
    NSString *_comments = self.comment.text;
    NSString *_time = self.time;
    NSString *_photo = self.photo.text;
    NSString *_contractor = self.company.text;
    //completion,photo1,photo2,quan
    NSString *rawStr = [NSString stringWithFormat:@"_date=%@&&_leadNo=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_start=%@&_email=%@&_first=%@&_spouse=%@&_rate=%@&_salesNo=%@&_jobNo=%@&_productNo=%@&_active=%@&_time=%@&_photo=%@&_contractor=%@&", _date, _leadNo, _address, _city, _state, _zip, _comments, _amount, _phone, _start, _email, _first, _spouse, _rate, _salesNo, _jobNo, _productNo, _active, _time, _photo,_contractor];
    
    NSLog(@"rawStr is %@",rawStr);
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveCustomer.php"];
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
    
    NSLog(@"%lu", (unsigned long)responseString.length);
    NSLog(@"%lu", (unsigned long)success.length);
    
    [self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
    
    // [self performSegueWithIdentifier:@"homeReturnSegue"sender:self];
    
}

#pragma mark - UITextViewDelegate
/*
 (void)checkIfComplete{
 BOOL complete = YES;
 for(int i = 0; i < self.mandatoryFields.count; i++){
 UITextField *tempTextField = self.mandatoryFields[i];
 
 if(tempTextField.text.length == 0){
 complete = NO;
 break;
 }
 }
 
 self.btnSave.enabled = complete;
 } */

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // First check whether the replacement string's numeric...
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bool isNumeric = [string isEqualToString:filtered];
    
    // Then if the replacement string's numeric, or if it's
    // a backspace, or if it's a decimal point and the text
    // field doesn't already contain a decimal point,
    // reformat the new complete number using
    // NSNumberFormatterDecimalStyle
    if (isNumeric ||
        [string isEqualToString:@""] ||
        ([string isEqualToString:@"."] &&
         [textField.text rangeOfString:@"."].location == NSNotFound)) {
            
            // Create the decimal style formatter
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:10];
            
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            NSString *combinedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSString *numberWithoutCommas = [combinedText stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSNumber *number = [formatter numberFromString:numberWithoutCommas];
            
            NSString *formattedString = [formatter stringFromNumber:number];
            
            // If the last entry was a decimal at the end of the
            // re-add it here because the formatter will naturally
            // remove it.
            if ([string isEqualToString:@"."] &&
                range.location == textField.text.length) {
                formattedString = [formattedString stringByAppendingString:@"."];
            }
            
            textField.text = formattedString;
            
        }
    
    // Return no, because either the replacement string is not
    // valid or it is and the textfield has already been updated
    // accordingly
    return NO;
}

@end
