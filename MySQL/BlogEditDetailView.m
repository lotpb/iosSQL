//
//  BlogEditDetailView.m
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogEditDetailView.h"

@interface BlogEditDetailView ()
{
    NSMutableArray *_feedItems;
    UIBarButtonItem *trashItem, *shareItem;
    UIRefreshControl *refreshControl;
}

@end

@implementation BlogEditDetailView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(BLOGEDITTITLE, nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.listTableView1.rowHeight = UITableViewAutomaticDimension;
    self.listTableView1.estimatedRowHeight = 75;
    self.listTableView1.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//fix
    self.view.backgroundColor = BLOGBACKCOLOR;
    self.toolBar.translucent = NO;
    self.toolBar.barTintColor = [UIColor whiteColor];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.5f);
    topBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.toolBar.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.toolBar.frame.size.height, self.view.frame.size.width, 0.5f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    [self.toolBar.layer addSublayer:bottomBorder];
    
    UIImage *image = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.Like setImage:image forState:UIControlStateNormal];
    [self.Like setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.update setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDeleteConfirmation:)];
    NSArray *actionButtonItems = @[shareItem, trashItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
//---------------Reply Blog Query--------------------------------------
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query whereKey:@"ReplyId" equalTo:self.objectId];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _feedItems = nil;
            _feedItems = [[NSMutableArray alloc] initWithArray:objects];
            [self.listTableView1 reloadData];
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
//------------------------------------------------------------------
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];

}
//-----------------------------end-------------------------------------

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    [self.listTableView reloadData];
    [self.listTableView1 reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:KEY_DATEREFRESH];
            NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }
        [refreshControl endRefreshing];
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.listTableView]) {
        return 1;
    } else if ([tableView isEqual:self.listTableView1]) {
        return [_feedItems count];
    }
    return 1;
}

#pragma mark - TableView Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.listTableView]) {
        
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
        [query setLimit:1]; //parse.com standard is 100
        query.cachePolicy = kPFCACHEPOLICY;
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                PFFile *file = [object objectForKey:@"imageFile"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        [myCell.blogImageView setImage:[UIImage imageWithData:data]];
                    } else {
                        [myCell.blogImageView setImage:[UIImage imageNamed:@"profile-rabbit-toy.png"]];
                    }
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        /*
        myCell.blogImageView.clipsToBounds = YES;
        myCell.blogImageView.layer.cornerRadius = BLOGIMGRADIUS;
        myCell.blog2ImageView.contentMode = UIViewContentModeScaleToFill; */
        
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
            
            if (([self.rating isEqual:@"5"]) ||  ([self.selectedLocation.rating isEqual:@"5"])){
                NSString *stringCount = [NSString stringWithFormat:@"%@ %@",@" Likes", self.liked];
                [self.Like setTitle:stringCount forState: UIControlStateNormal];
                [self.Like setSelected:YES];
                self.Like.tintColor = [UIColor redColor];
                //[self.Like setBackgroundColor:LIKECOLORBACK];
                //[self.Like setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                //self.Like.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            } else {
                //if (self.liked > 0) {
                NSString *stringCount = @" Like";
                [self.Like setTitle:stringCount forState: UIControlStateNormal];
                [self.Like setSelected:NO];
                self.Like.tintColor = [UIColor lightGrayColor];
                // }
            }
        }
        
        NSString *textLink = myCell.subtitleLabel.text;
        NSString *a = @"@";
        NSString *searchby = [a stringByAppendingString:self.postby];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:textLink];
        //NSURL *URL = [NSURL URLWithString:@"http://www.google.com"];
        //[str addAttribute:NSLinkAttributeName value:URL range:[textLink rangeOfString:@"@"]];
        [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[textLink rangeOfString:searchby]];
        myCell.subtitleLabel.attributedText = str;
        
        return myCell;
    }
    
    else if ([tableView isEqual:self.listTableView1]) {
        
        static NSString *CellIdentifier = @"ReplyCell";
        CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [myCell.replytitleLabel setFont:CELL_BOLDFONT(IPADFONT16)];
            [myCell.replysubtitleLabel setFont:CELL_FONT(IPADFONT16)];
            [myCell.replynumLabel setFont:CELL_FONT(IPADFONT14)];
            [myCell.replydateLabel setFont:CELL_FONT(IPADFONT12)];
        } else {
            [myCell.replytitleLabel setFont:CELL_BOLDFONT(IPHONEFONT14)];
            [myCell.replysubtitleLabel setFont:CELL_FONT(IPHONEFONT14)];
            [myCell.replynumLabel setFont:CELL_FONT(IPHONEFONT12)];
            [myCell.replydateLabel setFont:CELL_FONT(IPHONEFONT12)];
        }
        
        myCell.accessoryType = UITableViewCellAccessoryNone;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (myCell == nil)
            myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            /*
             NSString *dateStr = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
             static NSDateFormatter *DateFormatter = nil;
             if (DateFormatter == nil) {
             NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
             [DateFormatter setDateFormat:KEY_DATETIME];
             NSDate *date = [DateFormatter dateFromString:dateStr];
             [DateFormatter setDateFormat:BLOG_FORMAT];
             dateStr = [DateFormatter stringFromDate:date];
             } */
            
            NSDate *creationDate = [[_feedItems objectAtIndex:indexPath.row] createdAt];
            NSDate *datetime1 = creationDate;
            NSDate *datetime2 = [NSDate date];
            double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
            NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
            
            myCell.replytitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            myCell.replysubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            myCell.replynumLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Liked"] stringValue];
            myCell.replydateLabel.text = resultDateDiff;
        } else {
            myCell.replysubtitleLabel.text = self.selectedLocation.postby;
            myCell.replysubtitleLabel.text = self.selectedLocation.subject;
            myCell.replydateLabel.text = self.selectedLocation.msgDate;
        }
        
        UIImage *image = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [myCell.replylikeButton setImage:image forState:UIControlStateNormal];
        [myCell.replylikeButton sizeToFit];
        myCell.replylikeButton.tintColor = [UIColor lightGrayColor];
        
        [myCell.replynumLabel sizeToFit];
        if (![myCell.replynumLabel.text isEqual: @"0"] ) {
            myCell.replynumLabel.textColor = [UIColor grayColor];
        } else {
            myCell.replynumLabel.text = @"";
        }
        
        [myCell.replydateLabel sizeToFit];
        myCell.replydateLabel.textColor = [UIColor grayColor];
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"]];
        [query setLimit:1]; //parse.com standard is 100
        query.cachePolicy = kPFCACHEPOLICY;
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                PFFile *file = [object objectForKey:@"imageFile"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        [myCell.replyImageView setImage:[UIImage imageWithData:data]];
                    } else {
                        [myCell.replyImageView setImage:[UIImage imageNamed:@"profile-rabbit-toy.png"]];
                    }
                }];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
        NSString *textLink = myCell.replysubtitleLabel.text;
        NSString *a = @"@";
        NSString *searchby = [a stringByAppendingString:self.postby];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:textLink];
        [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[textLink rangeOfString:searchby]];
        myCell.replysubtitleLabel.attributedText = str;
        
        return myCell;
    } else {
        return nil;
    }
}

#pragma mark TableView Delete Button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.listTableView1]) {
        return UITableViewCellEditingStyleDelete;
    }
    return 0;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [self.listTableView1 setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *view = [UIAlertController alertControllerWithTitle:DELMESSAGE1 message:DELMESSAGE2 preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                     {
                         if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                             
                             PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
                             [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
                             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                 if (objects) {
                                     //[updateblog incrementKey:@"CommentCount"];
                                     [PFObject deleteAllInBackground:objects];
                                 } else {
                                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                                 }
                             }];
                         }
                     }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                         {
                             [view dismissViewControllerAnimated:YES completion:nil];
                         }];
        
        [view addAction:ok];
        [view addAction:cancel];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            view.popoverPresentationController.sourceView = self.view;
            view.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
        }
        [self presentViewController:view animated:YES completion:nil];
    }
}

#pragma mark - button
- (void)share:(id)sender {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height), self.view.opaque, 0.0);
    }else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height), self.view.opaque, 0.0);
    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newPNG = UIImageJPEGRepresentation(img, 0.0f); // or you can use JPG or PDF
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"I would like to share this.",newPNG, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.barButtonItem = shareItem;
        activityVC.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark actionSheet
-(void)showDeleteConfirmation:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:DELMESSAGE1
                                 message:nil//DELMESSAGE2
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                                 
                                 PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
                                 [query whereKey:@"objectId" equalTo:self.objectId];
                                 [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                     if (!error) {
                                         for (PFObject *object in objects) {
                                             [object deleteInBackground];
                                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
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
                                  NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
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


#pragma mark  Button Update
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

@end