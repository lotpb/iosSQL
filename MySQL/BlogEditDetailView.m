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
//@synthesize msgDate, postby, subject, rating, msgNo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(BLOGEDITTITLE, nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.view.backgroundColor = BLOGBACKCOLOR;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDeleteConfirmation:)];
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        NSString * message = self.msgDate;
        NSString * message1 = self.postby;
        NSString * message2 = self.subject;
        UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
        NSArray * shareItems = @[message, message1, message2, image];
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
    } else {
        NSString * message = self.selectedLocation.msgDate;
        NSString * message1 = self.selectedLocation.postby;
        NSString * message2 = self.selectedLocation.subject;
        UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
        NSArray * shareItems = @[message, message1, message2, image];
        UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
        [self presentViewController:avc animated:YES completion:nil];
    }
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
                                             
                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Complete" message:@"Successfully deleted the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                             [alert show];
                                             GOBACK;
                                             //[self.listTableView reloadData];
                                         }
                                     } else {
                                         NSLog(@"Error: %@ %@", error, [error userInfo]);
                                     }
                                 }];
                             } else { /*
                                       //BlogLocation *item;
                                       //item = [_feedItems objectAtIndex:indexPath.row];
                                       NSString *deletestring = _selectedLocation.msgNo;
                                       NSString *_msgNo = deletestring;
                                       NSString *rawStr = [NSString stringWithFormat:BLOGDELETENO, BLOGDELETENO1];
                                       NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                       NSURL *url = [NSURL URLWithString:BLOGDELETEURL];
                                       NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                                       [request setHTTPMethod:@"POST"]; [request setHTTPBody:data];
                                       NSURLResponse *response; NSError *err;
                                       NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                                       NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
                                       NSLog(@"%@", responseString);
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
    [self presentViewController:view animated:YES completion:nil];

}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of feed items (initially 0)
    return 1;
}

//this keep contraint errors away don't remove
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}
//this keep contraint errors away don't remove
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT; //this keep contraint errors away don't remove
}

#pragma mark - TableView Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = IDCELL;
  //UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 10, 145, 30, 11)];
    
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
   
    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        myCell.accessoryType = UITableViewCellAccessoryNone;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    [myCell.titleLabel setFont:CELL_BOLDFONT(BLOG_FONTSIZE)];
    [myCell.subtitleLabel setFont:CELL_FONT(BLOG_FONTSIZE)];
    [myCell.msgDateLabel setFont:CELL_FONT(BLOG_FONTSIZE - 2)];
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        myCell.titleLabel.text = self.postby;
        myCell.subtitleLabel.text = self.subject;
        myCell.msgDateLabel.text = self.msgDate;
        
    } else {
        
        myCell.titleLabel.text = self.selectedLocation.postby;
        myCell.subtitleLabel.text = self.selectedLocation.subject;
        myCell.msgDateLabel.text = self.selectedLocation.msgDate;
    }

    myCell.blogImageView.clipsToBounds = YES;
    myCell.blogImageView.layer.cornerRadius = BLOGIMGRADIUS;
    myCell.blog2ImageView.contentMode = UIViewContentModeScaleAspectFit;
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        if ([self.rating isEqual:@"5"]) {
            [self.Like setTitle: @"Like" forState: UIControlStateNormal];
            [self.Like setBackgroundColor:LIKECOLORBACK];
            [self.Like setTitleColor:LIKECOLORTEXT forState:UIControlStateNormal];
            self.Like.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        
    } else {
        
        if ([self.selectedLocation.rating isEqual:@"5"]) {
            [self.Like setTitle: @"Like" forState: UIControlStateNormal];
            [self.Like setBackgroundColor:LIKECOLORBACK];
            [self.Like setTitleColor:LIKECOLORTEXT forState:UIControlStateNormal];
            self.Like.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
    }
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

#pragma mark - Button Notification
- (IBAction)sendNotification:(UIButton *)sender
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = BLOGNOTIFICATION;
    localNotification.category = BNOTIFCATEGORY;
    localNotification.alertAction = NSLocalizedString(BNOTIFACTION, nil);
    localNotification.alertTitle = NSLocalizedString(BNOTIFTITLE, nil);
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1; //The number to diplay on the icon badge
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end