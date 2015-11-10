//
//  BlogUserController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/10/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "BlogUserController.h"

@interface BlogUserController ()
{
    BlogModel *_BlogModel; BlogLocation *_selectedLocation;
    NSMutableArray *headCount, *_feedItems;
    UIRefreshControl *refreshControl;
    UIButton *likeButton;
    BOOL isReplyClicked;
    NSString *posttoIndex, *userIndex, *getpostby, *getdate;
}
//@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIView *buttonView;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation BlogUserController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(self.postBy, nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 110; //ROW_HEIGHT;
    self.listTableView.backgroundColor = [UIColor whiteColor]; //BLOGNAVBARCOLOR;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//fix

/*
 *******************************************************************************************
 Parse.com
 *******************************************************************************************
 */
    
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query setLimit:1000]; //parse.com standard is 100
    [query whereKey:@"PostBy" equalTo:self.postBy];
     query.cachePolicy = kPFCACHEPOLICY;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            _feedItems = nil;
            _feedItems = [[NSMutableArray alloc] initWithArray:objects];
            [self.listTableView reloadData];
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    PFQuery *query1 = [PFUser query];
    [query1 whereKey:@"username" equalTo:self.postBy];
     query1.cachePolicy = kPFCACHEPOLICY;
    [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            getpostby = [object objectForKey:@"username"];
            static NSDateFormatter *formatter = nil;
            if (formatter == nil) {
                NSDate *updated = [object createdAt];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MMM dd, yyyy"];
                NSString *createAtString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updated]];
                getdate = createAtString;
                PFFile *file = [object objectForKey:@"imageFile"];
                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                    if (!error) {
                        self.selectedImage = [UIImage imageWithData:data];
                        [self.listTableView reloadData];
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseBlog]; [parseConnection parseHeadBlog];
    } else {
        //_feedItems = [[NSMutableArray alloc] init];
        //_BlogModel = [[BlogModel alloc] init];
        //_BlogModel.delegate = self; [_BlogModel downloadItems];
    } */
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(popoverWithoutBarButton:)];
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = BLOGNAVBARCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    
    [refreshView addSubview:refreshControl];
}

/*
 *******************************************************************************************
 Code Below
 *******************************************************************************************
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BLOGNAVBARCOLOR;
    self.navigationController.navigationBar.translucent = BLOGNAVBARTRANSLUCENT;
    self.navigationController.navigationBar.tintColor = BLOGNAVBARTINTCOLOR;
    //[self reloadDatas:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Popover Presentation Controller Delegate
-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller
{
    return UIModalPresentationNone;
}

- (IBAction)popoverWithoutBarButton:(id)sender {
    
    //ContentViewController *contentVC = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popover = nav.popoverPresentationController;
    controller.preferredContentSize = CGSizeMake(300, 200);
    popover.delegate = self;
    popover.sourceView = self.view;
    //popover.sourceRect = self.button.frame;
    popover.sourceRect = CGRectMake(100, 100, 0, 0);
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    [self presentViewController:nav animated:YES completion:nil];
    /*
     // in case we don't have a bar button as reference
     popController.sourceView = self.view;
     popController.sourceRect = CGRectMake(30, 50, 10, 10); */
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
/*
 *******************************************************************************************
 Parse.com
 *******************************************************************************************
 */
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseBlog]; [parseConnection parseHeadBlog];
    } else {
        [_BlogModel downloadItems];
    } */
    [self.listTableView reloadData];
    
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

#pragma mark - Fix
- (UIViewController*) topMostController // view is not in the window hierarchy
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

/*
 *******************************************************************************************
 Parse.com
 *******************************************************************************************
 */

- (void)parseHeadBlogloaded:(NSMutableArray *)blogheadItem {
    headCount = blogheadItem;
    [self.listTableView reloadData];
}

#pragma mark - Button

#pragma mark flag button
- (void) flagButton:(id)sender  {
    
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.listTableView];
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition.origin];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Report inappropriate user" message:@"Please enter reason" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Reason";
    }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
        textField.text = [[_feedItems objectAtIndex:indexPath.row] valueForKey:@"PostBy"];
        textField.textColor = [UIColor redColor];
    }];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   //Do Some action here
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
        viewController = viewController.presentedViewController;
    }
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark like button
- (void)likeButton:(id)sender {
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.listTableView];
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition.origin];
    [btn setSelected:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateLead, NSError *error) {
        if (!error) {
            NSNumber* likedNum = [[_feedItems objectAtIndex:indexPath.row] valueForKey:@"Liked"];
            int likeCount = [likedNum intValue];
            
            if (btn.isSelected) {
                likeCount++;
            } else {
                if (likeCount > 0) {
                    likeCount--;
                }
            }
            NSNumber *numCount = [NSNumber numberWithInteger: likeCount];
            [updateLead setObject:numCount ? numCount:[NSNumber numberWithInteger: 0] forKey:@"Liked"];
            [updateLead saveInBackground];
        }
    }];
}

-(void)buttonPress:(id)sender {
    UIButton* button = (UIButton*)sender;
    if (!likeButton.selected) {
        [likeButton setSelected:YES];
        button.tintColor = [UIColor redColor];
    } else {
        [likeButton setSelected:NO];
        button.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark reply button
-(void)replyButton:(id)sender {
    isReplyClicked = YES;
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.listTableView];
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition.origin];
    posttoIndex = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
    userIndex = [[_feedItems objectAtIndex:indexPath.row] objectId];
    [self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
}

#pragma mark ActivityViewController
- (void)share:(id)sender {
    
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* email = [UIAlertAction
                            actionWithTitle:@"Email this Message"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                //[self facebookPost:self];
                            }];
    
    UIAlertAction* sms = [UIAlertAction
                          actionWithTitle:@"SMS this Message"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              //[self twitterPost:self];
                          }];
    UIAlertAction* follow = [UIAlertAction
                             actionWithTitle:@"Follow"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //[self sendSMS:self];
                             }];
    UIAlertAction* block = [UIAlertAction
                            actionWithTitle:@"Block this Message"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                //[self twitterPost:self];
                            }];
    UIAlertAction* report = [UIAlertAction
                             actionWithTitle:@"Report this Message"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //[self sendSMS:self];
                             }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:email];
    [view addAction:sms];
    [view addAction:follow];
    [view addAction:block];
    [view addAction:report];
    [view addAction:cancel];

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIView* senderView = (UIView *)sender;
        view.popoverPresentationController.sourceView = senderView;
        view.popoverPresentationController.sourceRect = senderView.bounds;
        view.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark TableView Delete Button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [self.listTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *view = [UIAlertController alertControllerWithTitle:DELMESSAGE1 message:DELMESSAGE2
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
 /*
  *******************************************************************************************
  Parse.com
  *******************************************************************************************
  */
                                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                                     
                                     PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
                                     [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
                                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (objects) {
                                             [PFObject deleteAllInBackground:objects];
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 } else {
                                     NSURL *url = [NSURL URLWithString:BLOGDELETEURL];
                                     NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                                     NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                                     
                                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                                     request.HTTPMethod = @"POST";
                                     
                                     BlogLocation *item;
                                     item = [_feedItems objectAtIndex:indexPath.row];
                                     NSString *deletestring = item.msgNo;
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
                                     [success dataUsingEncoding:NSUTF8StringEncoding];
                                 }
                                 
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                 //   GOBACK; //Do some thing here
                                 [view dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilltered)
        return filteredString.count;
    else
        return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = IDCELL;
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPADFONT18)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPADFONT18)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPADFONT16)];
        myCell.numLabel.font = CELL_BOLDFONT(IPADFONT16);
        myCell.commentLabel.font = CELL_BOLDFONT(IPADFONT16);
    } else {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPHONEFONT17)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPHONEFONT17)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPHONEFONT14)];
        myCell.numLabel.font = CELL_BOLDFONT(IPHONEFONT16);
        myCell.commentLabel.font = CELL_BOLDFONT(IPHONEFONT16);
    }
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        if (!isFilltered) {
            NSString *dateStr = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
            static NSDateFormatter *DateFormatter = nil;
            if (DateFormatter == nil) {
                NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:KEY_DATETIME];
                NSDate *date = [DateFormatter dateFromString:dateStr];
                [DateFormatter setDateFormat:@"MMM dd, yyyy"];
                dateStr = [DateFormatter stringFromDate:date];
            }
            
            myCell.blogtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            myCell.blogsubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            myCell.blogmsgDateLabel.text = dateStr;
            myCell.numLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Liked"]stringValue];
            myCell.commentLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CommentCount"]stringValue];
        } else {
            myCell.blogtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            myCell.blogsubtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            myCell.blogmsgDateLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
            myCell.numLabel.text = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Liked"]stringValue];
            myCell.commentLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CommentCount"]stringValue];
        }
    } else {
        BlogLocation *item;
        if (!isFilltered)
            item = _feedItems[indexPath.row];
        else
            item = [filteredString objectAtIndex:indexPath.row];
        
        myCell.blogtitleLabel.text = item.postby;
        myCell.blogsubtitleLabel.text = item.subject;
        myCell.blogmsgDateLabel.text = item.msgDate;
    }
    
    myCell.blog2ImageView.image = self.selectedImage;
    myCell.blog2ImageView.contentMode = UIViewContentModeScaleToFill;
    myCell.blog2ImageView.clipsToBounds = YES;
    myCell.blog2ImageView.layer.cornerRadius = myCell.blog2ImageView.frame.size.width / 2;
    myCell.blog2ImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myCell.blog2ImageView.layer.borderWidth = 0.5f;
    myCell.blog2ImageView.layer.masksToBounds = YES;
    
    myCell.replyButton.tintColor = [UIColor lightGrayColor];
    UIImage *replyimage =[[UIImage imageNamed:@"Commentfilled.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.replyButton setImage:replyimage forState:UIControlStateNormal];
    [myCell.replyButton addTarget:self action:@selector(replyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.likeButton setImage:image forState:UIControlStateNormal];
    [myCell.likeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [myCell.likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    myCell.likeButton.tintColor = [UIColor lightGrayColor];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        [myCell.numLabel sizeToFit];
        if (![myCell.numLabel.text isEqual: @"0"] ) {
            myCell.numLabel.textColor = [UIColor redColor];
        } else {
            myCell.numLabel.text = @"";
        }
        
        [myCell.commentLabel sizeToFit];
        if (![myCell.commentLabel.text isEqual: @"0"] ) {
            myCell.commentLabel.textColor = [UIColor lightGrayColor];
        } else {
            myCell.commentLabel.text = @"";
        }
        
        if ([myCell.commentLabel.text length] > 0)  {
            myCell.replyButton.tintColor = [UIColor redColor];
        } else {
            myCell.replyButton.tintColor = [UIColor lightGrayColor];
        }
    }
    
    myCell.flagButton.tintColor = [UIColor lightGrayColor];
    UIImage *reportimage = [[UIImage imageNamed:@"Flag.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.flagButton setImage:reportimage forState:UIControlStateNormal];
    [myCell.flagButton addTarget:self action:@selector(flagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    myCell.actionBtn.tintColor = [UIColor darkGrayColor];
    UIImage *imagebutton = [[UIImage imageNamed:@"Upload50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.actionBtn setImage:imagebutton forState:UIControlStateNormal];
    [myCell.actionBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *textLink = myCell.blogsubtitleLabel.text;
    NSString *a = @"@";
    NSString *searchby = [a stringByAppendingString:self.postBy];//this is only getting Peter Balsamo
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:textLink];
    [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[textLink rangeOfString:searchby]];
    myCell.blogsubtitleLabel.attributedText = str;
    
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return 180;
    else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"MSG \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"LIKES \n%lu",(unsigned long) headCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    NSString *newString3 = [NSString stringWithFormat:@"Member since %@",getdate];
    NSString *newString4 = getpostby;
    NSString *newString5 = [NSString stringWithFormat:@"90 percent of my picks made $$$. The stock whisper has traded over 1000 traders worldwide"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    //self.listTableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE1)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE2)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE3)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE4)];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE5)];
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(BLABELSIZE6)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [label setFont:CELL_BOLDFONT(IPADFONT16)];
        [label1 setFont:CELL_BOLDFONT(IPADFONT16)];
        [label2 setFont:CELL_BOLDFONT(IPADFONT16)];
        [label3 setFont:CELL_MEDFONT(IPADFONT18)];
        [label4 setFont:CELL_MEDFONT(IPADFONT18)];
        [label5 setFont:CELL_LIGHTFONT(IPADFONT18)];
    } else {
        [label setFont:CELL_MEDFONT(IPHONEFONT14) ];
        [label1 setFont:CELL_MEDFONT(IPHONEFONT14)];
        [label2 setFont:CELL_MEDFONT(IPHONEFONT14)];
        [label3 setFont:CELL_MEDFONT(IPHONEFONT18) ];
        [label4 setFont:CELL_MEDFONT(IPHONEFONT18)];
        [label5 setFont:CELL_LIGHTFONT(IPHONEFONT18)];
    }
    
    UIImageView *image1 =[[UIImageView alloc] initWithFrame:CGRectMake(21, 10, 45, 45)];
    image1.image = self.selectedImage;
    image1.contentMode = UIViewContentModeScaleToFill;
    image1.clipsToBounds = YES;
    image1.layer.cornerRadius = image1.frame.size.width / 2;
    image1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    image1.layer.borderWidth = 0.5f;
    [view addSubview:image1];
    
    [label4 setTextColor:MAINNAVCOLOR];
    label4.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label4.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label4.backgroundColor = [UIColor clearColor];
    label4.numberOfLines = 0;
    NSString *string4 = newString4;
    [label4 setText:string4];
    [view addSubview:label4];
    
    [label5 setTextColor:MAINNAVCOLOR];
    label5.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label5.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label5.numberOfLines = 0;
    label5.backgroundColor = [UIColor clearColor];
    NSString *string5 = newString5;
    [label5 setText:string5];
    [view addSubview:label5];
    
    [label3 setTextColor:MAINNAVCOLOR];
    label3.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label3.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label3.numberOfLines = 0;
    label3.backgroundColor = [UIColor clearColor];
    NSString *string3 = newString3;
    [label3 setText:string3];
    [view addSubview:label3];
    
    [label setTextColor:MAINNAVCOLOR];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE1)];
    separatorLineView.backgroundColor = BLOGLINECOLOR1;// you can also put image here
    [view addSubview:separatorLineView];
    
    label1.numberOfLines = 0;
    [label1 setTextColor:MAINNAVCOLOR];
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label1.backgroundColor = [UIColor clearColor];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE2)];
    separatorLineView1.backgroundColor = BLOGLINECOLOR1;
    [view addSubview:separatorLineView1];
    
    label2.numberOfLines = 0;
    [label2 setTextColor:MAINNAVCOLOR];
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label2.backgroundColor = [UIColor clearColor];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE3)];
    separatorLineView2.backgroundColor = BLOGLINECOLOR1;
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:LIGHTGRAYCOLOR]; //BLOGNAVBARCOLOR
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFilltered)
        _selectedLocation = _feedItems[indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"blogusereditSegue" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"blogusereditSegue"])
    {
        BlogEditDetailView *detailVC = segue.destinationViewController;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            if (!isFilltered) {
                detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                detailVC.msgNo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgNo"];
                detailVC.postby = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
                detailVC.subject = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
                detailVC.msgDate = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
                detailVC.rating = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rating"];
                detailVC.liked = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Liked"];
                detailVC.replyId = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"ReplyId"];
            } else {
                detailVC.objectId = [[filteredString objectAtIndex:indexPath.row] objectId];
                detailVC.msgNo = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"MsgNo"];
                detailVC.postby = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
                detailVC.subject = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Subject"];
                detailVC.msgDate = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
                detailVC.rating = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Rating"];
            }
        }
        else
            detailVC.selectedLocation = _selectedLocation;
        
    }

}

@end
