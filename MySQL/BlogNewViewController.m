//
//  BlogNewViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/19/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogNewViewController.h"
#import "Constants.h"

@interface BlogNewViewController ()

@end

@implementation BlogNewViewController
@synthesize msgNo, msgDate, subject, rating, postby;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* const userNameKey = KEY_USER;
    
    if (self.textcontentsubject.length == 0) {
        NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
        gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
        gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *dateString = [gmtDateFormatter stringFromDate:[NSDate date]];
        self.msgDate = dateString;
        self.rating = @"4";
        self.postby = [defaults objectForKey:userNameKey];
        self.Reply.hidden = YES;
      } else {
        self.msgNo = self.textcontentmsgNo;
        self.msgDate = self.textcontentdate;
        self.subject.text = self.textcontentsubject;
        self.postby = self.textcontentpostby;
        self.rating = self.textcontentrating;
        self.Share.hidden = YES;
      }
       [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.myDatePicker.hidden = YES;
    
  [[UITextView appearance] setTintColor:[UIColor grayColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title =  @"Share an idea";
    [self.subject becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   // Return the number of sections.
    return 1;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of feed items (initially 0)
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

 //   UITextField *textframe = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 175, 30)];
 //   UIFont *textFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    
     if (indexPath.row == 0){

       myCell.textLabel.text = self.postby;
       myCell.detailTextLabel.text = self.rating;
         
     } else if (indexPath.row == 1){
         
         myCell.textLabel.text = self.msgDate;
         myCell.detailTextLabel.text = @"Date";

   /*      self.msgDate = textframe;
        [self.msgDate setFont:textFont];
         self.msgDate.tag = 8;
         self.msgDate.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.msgDate setClearButtonMode:UITextFieldViewModeWhileEditing];
         if (self.msgDate.text.length == 0) {
             NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
             gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
             gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
             NSString *dateString = [gmtDateFormatter stringFromDate:[NSDate date]];
             self.msgDate.text = dateString; }
         
         [myCell.contentView addSubview:self.msgDate];
             self.msgDate.inputView = [self datePicker:8]; */
}
return myCell;
//return nil;
}

#pragma mark - Button
-(IBAction)like:(id)sender{
    if([self.rating isEqualToString: @"4"]) {
       [self.Like setTitle: @"UnLike" forState: UIControlStateNormal];
        self.rating = @"5";
      } else {
       [self.Like setTitle: @"Like" forState: UIControlStateNormal];
        self.rating = @"4"; }
       [self.listTableView reloadData];
}
/*
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
} */

-(void)onDatePickerValueChanged:(UIDatePicker *)myDatePicker
{
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone localTimeZone];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    self.msgDate = [gmtDateFormatter stringFromDate:myDatePicker.date];
}

#pragma mark - Button New Database
-(IBAction)Reply:(id)sender{
    // [self displayActivityIndicator];
    NSString *_msgNo = self.msgNo;
    NSString *_msgDate = self.msgDate;
    NSString *_subject = self.subject.text;
    NSString *_rating = self.rating;
    NSString *_postby = self.postby;
    
    NSString *rawStr = [NSString stringWithFormat:@"_msgNo=%@&&_msgDate=%@&_subject=%@&_rating=%@&_postby=%@&",
                        _msgNo, _msgDate, _subject, _rating, _postby];
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/updateBlog.php"];
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
    
   [[self navigationController]popToRootViewControllerAnimated:YES];
}

#pragma mark - Button Update Database
-(IBAction)Share:(id)sender {
 
    [self.listTableView reloadData];
    NSString *_msgDate = self.msgDate;
    NSString *_subject = self.subject.text;
    NSString *_rating = self.rating;
    NSString *_postby = self.postby;
    
    NSString *rawStr = [NSString stringWithFormat:@"_msgDate=%@&&_subject=%@&_rating=%@&_postby=%@&",_msgDate, _subject, _rating, _postby];
    
    NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:@"http://localhost:8888/saveBlog.php"];
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
    
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

@end