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

#pragma mark - Button
- (void)share:(id)sender {
    NSString * message = self.selectedLocation.msgDate;
    NSString * message1 = self.selectedLocation.postby;
    NSString * message2 = self.selectedLocation.subject;
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, message2, image];
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
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
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
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
      //  UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width / 10, 145, 30, 11)];
    
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        myCell.accessoryType = UITableViewCellAccessoryNone;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
    [myCell.titleLabel setFont:CELL_BOLDFONT(CELL_FONTSIZE - 1)];
    [myCell.subtitleLabel setFont:CELL_FONT(CELL_FONTSIZE - 2)];
    [myCell.msgDateLabel setFont:CELL_FONT(CELL_FONTSIZE - 3)];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        myCell.titleLabel.text = self.postby;
        myCell.subtitleLabel.text = self.subject;
        myCell.msgDateLabel.text = self.msgDate;
        
    } else {
        
        myCell.titleLabel.text = self.selectedLocation.postby;
        myCell.subtitleLabel.text = self.selectedLocation.subject;
        myCell.msgDateLabel.text = self.selectedLocation.msgDate;
    }
    
    myCell.blogImageView.image = [[UIImage imageNamed:BLOGCELLIMAGE]  stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    myCell.blogImageView.clipsToBounds = YES;
    myCell.blogImageView.layer.cornerRadius = BLOGIMGRADIUS;
    myCell.blog2ImageView.contentMode = UIViewContentModeScaleAspectFit;
  
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