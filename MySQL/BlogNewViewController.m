//
//  BlogNewViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/19/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogNewViewController.h"

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
    
    //self.view.backgroundColor = BLOGNEWBACKCOLOR;
    self.listTableView.backgroundColor = BLOGNEWBACKCOLOR;
    self.toolBar.translucent = YES;
    self.toolBar.barTintColor = [UIColor grayColor];
    self.subject.delegate = self;
    
    if (self.textcontentsubject.length == 0) {
        self.placeholderlabel.text = @"Share an idea?";
        self.placeholderlabel.textColor = [UIColor lightGrayColor];
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        dateFormatter.dateFormat = KEY_DATETIME;
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        self.msgDate = dateString;
        self.rating = @"4";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                PFUser *currentUser = [PFUser currentUser];
                if (currentUser) {
                    self.postby =  currentUser.username;}
                else
                    self.postby = [defaults objectForKey:userNameKey];
            }
            self.Update.hidden = YES; }
    } else {
        self.placeholderlabel.hidden = true;;
        self.objectId = self.textcontentobjectId;
        self.msgNo = self.textcontentmsgNo;
        self.msgDate = self.textcontentdate;
        self.subject.text = self.textcontentsubject;
        self.postby = self.textcontentpostby;
        self.rating = self.textcontentrating;
        self.Share.hidden = YES;
    }
       [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.myDatePicker.hidden = YES;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.subject setFont:CELL_FONT(IPADFONT16)];
    } else {
        [self.subject setFont:CELL_FONT(IPHONEFONT17)];
    }
    
    PFQuery *query = [PFUser query];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        [query whereKey:@"username" equalTo:self.postby];
    } else {
        //[query whereKey:@"username" equalTo:self.selectedLocation.postby];
    }
    [query setLimit:1000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [self.imageBlog setImage:[UIImage imageWithData:data]];
                } else {
                    [self.imageBlog setImage:[UIImage imageNamed:BLOGCELLIMAGE]];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    self.imageBlog.clipsToBounds = YES;
    self.imageBlog.layer.cornerRadius = BLOGIMGRADIUS;
    self.imageBlog.contentMode = UIViewContentModeScaleToFill;
    
  [[UITextView appearance] setTintColor:CURSERCOLOR];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.title = NSLocalizedString(BLOGNEWTITLE, nil);
    //[self.subject becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderlabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderlabel.hidden = ([textView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderlabel.hidden = ([textView.text length] > 0);
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
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.row == 0) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [myCell.textLabel setFont:CELL_FONT(IPADFONT16)];
        } else {
            [myCell.textLabel setFont:CELL_FONT(IPHONEFONT16)];
        }
        
    UIImageView *activeImage = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width -35, 10, 18, 22)];
    activeImage.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([self.rating isEqual:@"5"] ) {
            activeImage.image = [UIImage imageNamed:ACTIVEBUTTONYES];
            [self.Like setTitle: @"unLike" forState: UIControlStateNormal];
        } else {
            activeImage.image = [UIImage imageNamed:ACTIVEBUTTONNO];
            [self.Like setTitle: @"Like" forState: UIControlStateNormal];
        }
        
        [myCell.contentView addSubview:activeImage];
         myCell.textLabel.text = self.postby;
         myCell.detailTextLabel.text = @"";
        
    } else if (indexPath.row == 1) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [myCell.textLabel setFont:CELL_FONT(IPADFONT16)];
            [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT16)];
        } else {
            [myCell.textLabel setFont:CELL_FONT(IPHONEFONT16)];
            [myCell.detailTextLabel setFont:CELL_FONT(IPHONEFONT16)];
        }
        
        myCell.textLabel.text = self.msgDate;
        myCell.detailTextLabel.text = @"Date";
    }
    return myCell;
}

#pragma mark - Button
-(IBAction)like:(id)sender {
    
    if([self.rating isEqualToString: @"4"]) {
       [self.Like setTitle: @"UnLike" forState: UIControlStateNormal];
        self.activeImage.image = [UIImage imageNamed:ACTIVEBUTTONYES];
        self.rating = @"5";
      } else {
       [self.Like setTitle: @"Like" forState: UIControlStateNormal];
        self.activeImage.image = [UIImage imageNamed:ACTIVEBUTTONNO];
        self.rating = @"4"; }
       [self.listTableView reloadData];
}

-(void)onDatePickerValueChanged:(UIDatePicker *)myDatePicker
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    dateFormatter.dateFormat = KEY_DATETIME;
        self.msgDate = [dateFormatter stringFromDate:myDatePicker.date]; }
}

#pragma mark - Button New Database
-(IBAction)Update:(id)sender {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {  //updateBlog
        PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
        [query whereKey:@"objectId" equalTo:self.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateblog, NSError *error) {
            if (!error) {
                [updateblog setObject:self.msgDate forKey:@"MsgDate"];
                [updateblog setObject:self.msgNo forKey:@"MsgNo"];
                [updateblog setObject:self.postby forKey:@"PostBy"];
                [updateblog setObject:self.rating forKey:@"Rating"];
                [updateblog setObject:self.subject.text forKey:@"Subject"];
                [updateblog saveInBackground];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully updated the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
          [self.listTableView reloadData];
    } else {
        
        NSString *_msgNo = self.msgNo;
        NSString *_msgDate = self.msgDate;
        NSString *_subject = self.subject.text;
        NSString *_rating = self.rating;
        NSString *_postby = self.postby;
        
        NSString *rawStr = [NSString stringWithFormat:BLOGUPDATEFIELD, BLOGUPDATEFIELD1];
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:BLOGUPDATEURL];
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
    //  NSLog(@"%lu", (unsigned long)responseString.length);
    //  NSLog(@"%lu", (unsigned long)success.length);
    }
    [[self navigationController]popToRootViewControllerAnimated:YES];
}

#pragma mark - Button Update Database
-(IBAction)Share:(id)sender { //save
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) { //saveBlog
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        NSNumber *myMsgNo = [formatter numberFromString:self.msgNo];
        
        PFObject *saveblog = [PFObject objectWithClassName:@"Blog"];
        [saveblog setObject:myMsgNo ? myMsgNo : [NSNumber numberWithInteger: -1] forKey:@"MsgNo"];
        [saveblog setObject:self.msgDate forKey:@"MsgDate"];
        [saveblog setObject:self.postby forKey:@"PostBy"];
        [saveblog setObject:self.rating forKey:@"Rating"];
        [saveblog setObject:self.subject.text forKey:@"Subject"];
        
        // Set ACL permissions for added security
        PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [postACL setPublicReadAccess:YES];
        [saveblog setACL:postACL];
        
        [saveblog saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                GOBACK;
                        //[self.listTableView reloadData];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    } else {
       // [self.listTableView reloadData];
        NSString *_msgDate = self.msgDate;
        NSString *_subject = self.subject.text;
        NSString *_rating = self.rating;
        NSString *_postby = self.postby;
        
        NSString *rawStr = [NSString stringWithFormat:BLOGSAVEFIELD, BLOGSAVEFIELD1];
        
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:BLOGSAVEURL];
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
     // NSLog(@"%lu", (unsigned long)responseString.length);
    //  NSLog(@"%lu", (unsigned long)success.length);
    }
    
    //[[self navigationController]popToRootViewControllerAnimated:YES];
}

@end