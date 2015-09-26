//
//  BlogEditDetailView.m
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogEditDetailView.h"

@interface BlogEditDetailView ()

- (IBAction)sendNotification:(UIButton *)sender;
@end

@implementation BlogEditDetailView
{
UIBarButtonItem *trashItem, *shareItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(BLOGEDITTITLE, nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.view.backgroundColor = BLOGBACKCOLOR;
    //self.toolBar.backgroundColor = [UIColor lightGrayColor];
    
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDeleteConfirmation:)];
    NSArray *actionButtonItems = @[shareItem, trashItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButton
- (void)share:(id)sender {
    NSString *message, *message1, *message2;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        message = self.msgDate;
        message1 = self.postby;
        message2 = self.subject;
    } else {
        message = self.selectedLocation.msgDate;
        message1 = self.selectedLocation.postby;
        message2 = self.selectedLocation.subject;
    }
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, message2, image];
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        avc.popoverPresentationController.barButtonItem = shareItem;
        avc.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - ActionSheet
-(void)showDeleteConfirmation:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:DELMESSAGE1
                                 message:DELMESSAGE2
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                                 
                                 PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
                                 [query whereKey:@"objectId" equalTo:self.objectId];
                                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                     if (!error) {
                                         for (PFObject *object in objects) {
                                             [object deleteInBackground];
                                             UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Delete Complete"
                                                                                                              message:@"Successfully updated the data"
                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                        handler:^(UIAlertAction * action)
                                                                  {
                                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                                      GOBACK;
                                                                      return;
                                                                  }];
                                             [alert addAction:ok];
                                             [self presentViewController:alert animated:YES completion:nil];
                                         }
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
                             } else {
                                 /*
                                 NSURL *url = [NSURL URLWithString:BLOGDELETEURL];
                                 NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                                 NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                                 
                                 NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                                 request.HTTPMethod = @"POST";
                                 
                                 //BlogLocation *item;
                                 //item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = _selectedLocation.msgNo;
                                 NSString *_msgNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:BLOGDELETENO, BLOGDELETENO1];
                                 NSError *error = nil;
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 [request setHTTPBody:data];
                                 
                                 if (!error) {
                                     NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                                                fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                                                    // Handle response here
                                                                                                }];
                                     
                                     [uploadTask resume];
                                 }
                                 
                                 NSString *success = @"success";
                                 [success dataUsingEncoding:NSUTF8StringEncoding]; */
                             }
                             
                             //[_feedItems removeObjectAtIndex:indexPath.row];
                             //[tableView deleteRowsAtIndexPaths:@[indexPath]
                             [view dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:ok];
    [view addAction:cancel];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.popoverPresentationController.barButtonItem = trashItem;
        view.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of feed items (initially 0)
    return 1;
}

#pragma mark - TableView Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.titleLabel setFont:CELL_BOLDFONT(IPADFONT20)];
        [myCell.subtitleLabel setFont:CELL_FONT(IPADFONT20)];
        [myCell.msgDateLabel setFont:CELL_FONT(IPADFONT16)];
    } else {
        [myCell.titleLabel setFont:CELL_BOLDFONT(IPHONEFONT18)];
        [myCell.subtitleLabel setFont:CELL_FONT(IPHONEFONT18)];
        [myCell.msgDateLabel setFont:CELL_FONT(IPHONEFONT12)];
    }
    
    myCell.accessoryType = UITableViewCellAccessoryNone;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    
    PFQuery *query = [PFUser query];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        [query whereKey:@"username" equalTo:self.postby];
    } else {
        [query whereKey:@"username" equalTo:self.selectedLocation.postby];
    }
    [query setLimit:1000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [myCell.blogImageView setImage:[UIImage imageWithData:data]];
                } else {
                    [myCell.blogImageView setImage:[UIImage imageNamed:BLOGCELLIMAGE]];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    myCell.blogImageView.clipsToBounds = YES;
    myCell.blogImageView.layer.cornerRadius = BLOGIMGRADIUS;
    myCell.blog2ImageView.contentMode = UIViewContentModeScaleToFill;
    
  //UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 10, 145, 30, 11)];

    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        NSString *dateStr = self.msgDate;
        static NSDateFormatter *DateFormatter = nil;
        if (DateFormatter == nil) {
            NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
            [DateFormatter setDateFormat:KEY_DATETIME];
            NSDate *date = [DateFormatter dateFromString:dateStr];
            [DateFormatter setDateFormat:BLOG_FORMAT];
            dateStr = [DateFormatter stringFromDate:date];
        }
        myCell.titleLabel.text = self.postby;
        myCell.subtitleLabel.text = self.subject;
        myCell.msgDateLabel.text = dateStr;
    } else {
        myCell.titleLabel.text = self.selectedLocation.postby;
        myCell.subtitleLabel.text = self.selectedLocation.subject;
        myCell.msgDateLabel.text = self.selectedLocation.msgDate;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        NSString *stringCount = [NSString stringWithFormat:@"%@  %@",@"Liked",  self.liked];
        if ([self.rating isEqual:@"5"]) {
            [self.Like setTitle:stringCount forState: UIControlStateNormal];
            [self.Like setBackgroundColor:LIKECOLORBACK];
            [self.Like setTitleColor:LIKECOLORTEXT forState:UIControlStateNormal];
            self.Like.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
    } else {
        if ([self.selectedLocation.rating isEqual:@"5"]) {
            [self.Like setTitle:@"Like" forState: UIControlStateNormal];
            [self.Like setBackgroundColor:LIKECOLORBACK];
            [self.Like setTitleColor:LIKECOLORTEXT forState:UIControlStateNormal];
            self.Like.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
    }
/*
    NSString *text = myCell.subtitleLabel.text;
    NSString *a = @"@";
    NSString *searchby = [a stringByAppendingString:self.subject];
    //NSURL *URL = [NSURL URLWithString: @"whatsapp://app"];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
    //[str addAttribute:NSLinkAttributeName value:URL range:[text rangeOfString:@"@"]];
    [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[text rangeOfString:searchby]];
    myCell.subtitleLabel.attributedText = str; */
    
    
    NSString *textLink = myCell.subtitleLabel.text;
    //NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:textLink];
    //[str addAttribute:NSLinkAttributeName value:URL range:[textLink rangeOfString:@"@"]];
    [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[textLink rangeOfString:@"@Peter Balsamo"]];
    myCell.subtitleLabel.attributedText = str;

    return myCell;
}

#pragma mark - Button Update
-(IBAction)update:(id)sender{
   [self performSegueWithIdentifier:BLOGEDITSEGUE sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:BLOGEDITSEGUE])
    {
        BlogNewViewController *detailVC = segue.destinationViewController;
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            detailVC.formStatus = @"None";
            detailVC.textcontentobjectId = self.objectId;
            detailVC.textcontentmsgNo = self.msgNo;
            detailVC.textcontentdate = self.msgDate;
            detailVC.textcontentsubject = self.subject;
            detailVC.textcontentpostby = self.postby;
            detailVC.textcontentrating = self.rating;
        } else {
            detailVC.textcontentmsgNo = self.selectedLocation.msgNo;
            detailVC.textcontentdate = self.selectedLocation.msgDate;
            detailVC.textcontentsubject = self.selectedLocation.subject;
            detailVC.textcontentpostby = self.selectedLocation.postby;
            detailVC.textcontentrating = self.selectedLocation.rating;
        }
    }
}

#pragma mark - Notification
#pragma mark Button Notification
- (IBAction)sendNotification:(UIButton *)sender
{
    UIAlertView *alert;
    UIDatePicker *DatePicker;
    
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    alert = [[UIAlertView alloc] initWithTitle:@"Notification date:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;//UIAlertViewStylePlainTextInput;
    DatePicker = [[UIDatePicker alloc] init];
    DatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    DatePicker.timeZone = [NSTimeZone localTimeZone];
    DatePicker.date = [NSDate date];
    
    self.DateInput = [alert textFieldAtIndex:0];
    self.itemText = [alert textFieldAtIndex:1];
    [self.DateInput setTextAlignment:NSTextAlignmentLeft];
    [self.itemText setTextAlignment:NSTextAlignmentLeft];
    self.DateInput.text = [DateFormatter stringFromDate:[NSDate date]];
    self.itemText.text = BLOGNOT_BODY;
    [self.DateInput setPlaceholder:@"notification date"];
    [self.itemText setPlaceholder:@"title"];
    self.itemText.secureTextEntry = NO;
    self.DateInput.inputView=DatePicker;
    [DatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [alert show];
}

- (void) dateChanged:(UIDatePicker *)DatePicker {
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.DateInput.text = [DateFormatter stringFromDate:DatePicker.date];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"]) {
        [self requestApptdate];
    }
}

- (void)requestApptdate {
    NSDate *apptdate;
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
        apptdate = [DateFormatter dateFromString:self.DateInput.text];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = self.itemText.text; //BLOGNOTIFICATION;
    localNotification.category = BLOGNOT_CATEGORY;
    localNotification.alertAction = NSLocalizedString(BLOGNOT_ACTION, nil);
    localNotification.alertTitle = NSLocalizedString(BLOGNOT_TITLE, nil);;
    localNotification.soundName = @"Tornado.caf";//UILocalNotificationDefaultSoundName;
    localNotification.fireDate = apptdate;//[NSDate dateWithTimeIntervalSinceNow:60];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] BADGENO; //The number to diplay on the icon badge
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

@end