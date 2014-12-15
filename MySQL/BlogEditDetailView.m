//
//  BlogEditDetailView.m
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogEditDetailView.h"
#import "CustomTableViewCell.h"
#import "BlogNewViewController.h"


@interface BlogEditDetailView ()

- (IBAction)sendNotification:(UIButton *)sender;

@end

@implementation BlogEditDetailView
@synthesize msgDate, postby, subject, rating, msgNo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.listTableView.estimatedRowHeight = 155.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.hidden = NO;
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDeleteConfirmation:)];
    NSArray *actionButtonItems = @[shareItem, trashItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
  [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];
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
- (void)share:(id)sender{
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
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Really delete the selected contact?"
                                                             delegate:nil
                                                    cancelButtonTitle:@"No, I changed my mind"
                                               destructiveButtonTitle:@"Yes, delete it"
                                                    otherButtonTitles:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    } else {
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    actionSheet.tag = 200;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   // Return the number of feed items (initially 0)
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44; //this keep contraint errors away don't remove
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44; //this keep contraint errors away don't remove
}

#pragma mark - TableView Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve cell
    static NSString *CellIdentifier = @"BasicCell";
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        myCell.accessoryType = UITableViewCellAccessoryNone;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Get references to labels of cell
    myCell.titleLabel.text = self.selectedLocation.postby;
    myCell.subtitleLabel.text = self.selectedLocation.subject;
    myCell.msgDateLabel.text = self.selectedLocation.msgDate;
    myCell.blogImageView.image = [[UIImage imageNamed:@"DemoCellImage"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    
     // (x, y, width, height)
    CGRect frame1=CGRectMake(20,145, 30, 11);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame1;
    label2.text=  @"Like";
    label2.font = [UIFont boldSystemFontOfSize:9.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:[UIColor whiteColor]];
    [label2 setBackgroundColor:[UIColor redColor]];
    label2.tag = 103;
    if ([self.selectedLocation.rating isEqual: @"4"])
    { label2.hidden = YES; }
    else { label2.hidden = NO; };
    [myCell.contentView addSubview:label2];
    
    return myCell;
}

#pragma mark - Button Update
-(IBAction)update:(id)sender{
   [self performSegueWithIdentifier:@"updateNewSeque"sender:self];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"updateNewSeque"])
    {
        BlogNewViewController *detailVC = segue.destinationViewController;
        
        detailVC.textcontentmsgNo = self.selectedLocation.msgNo;
        detailVC.textcontentdate = self.selectedLocation.msgDate;
        detailVC.textcontentsubject = self.selectedLocation.subject;
        detailVC.textcontentpostby = self.selectedLocation.postby;
        detailVC.textcontentrating = self.selectedLocation.rating;
    }
}

#pragma mark - Button Notification
- (IBAction)sendNotification:(UIButton *)sender
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    localNotification.alertBody = @"new Blog Posted at iOScreator.com";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end