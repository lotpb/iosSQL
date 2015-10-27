//
//  BlogViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogViewController.h"

@interface BlogViewController ()
{
    BlogModel *_BlogModel; BlogLocation *_selectedLocation;
    NSMutableArray *headCount, *_feedItems;
    UIRefreshControl *refreshControl;
    //UILabel *numLabel;
    //UIButton *flagButton;
    UIButton *likeButton;
    BOOL isReplyClicked;
    NSString *posttoIndex, *userIndex, *titleLabel;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIView *buttonView;


@end

@implementation BlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BLOGNAVLOGO]];
    //self.title = NSLocalizedString(TNAME9, nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 110; //ROW_HEIGHT;
    self.listTableView.backgroundColor = BLOGNAVBARCOLOR;
    
    //[self.listTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseBlog]; [parseConnection parseHeadBlog];
    } else {
        //_feedItems = [[NSMutableArray alloc] init];
        _BlogModel = [[BlogModel alloc] init];
        _BlogModel.delegate = self; [_BlogModel downloadItems];
    }
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(foundView:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[addItem, searchItem];
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
   [self reloadDatas:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseBlog]; [parseConnection parseHeadBlog];
    } else {
        [_BlogModel downloadItems];
    }
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
#pragma mark - ParseDelegate
- (void)parseBlogloaded:(NSMutableArray *)blogItem {
    _feedItems = blogItem;
    [self.listTableView reloadData];
}

- (void)parseHeadBlogloaded:(NSMutableArray *)blogheadItem {
    headCount = blogheadItem;
    [self.listTableView reloadData];
}

#pragma mark - Button
#pragma mark New BarButton
-(void)foundView:(id)sender {
     isReplyClicked = NO;
    [self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
}

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
    
    /*
     UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
     [top presentViewController:alert animated:YES completion: nil];
     */
    
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
            //numLabel.text = [NSString stringWithFormat:@"%d", likeCount]; //dont work
            //numLabel.text = [NSString stringWithFormat:@"%@ until %@!", [CustomTableViewCell stringifyDistance:(self.upcomingBadge.distance - self.distance)], self.upcomingBadge.name];
        }
    }];
    //[self.listTableView reloadData];
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
    //[[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setBackgroundColor:[UIColor blackColor]];
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
                                     
                                     //[query whereKey:@"ReplyId" equalTo:[_feedItems valueForKey objectId ]];
                                      //[query whereKey:@"ReplyId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
                                    
                                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (objects) {
                                             [PFObject deleteAllInBackground:objects];
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     /*
                                     PFQuery *query1 = [PFQuery queryWithClassName:@"Blog"];
                                     [query whereKey:@"ReplyId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
                                     //[query1 whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
                                     [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (objects) {
                                             [PFObject deleteAllInBackground:objects];
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }]; */
                                     
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
         myCell.numLabel.font = LIKEFONT(IPADFONT16);
         myCell.commentLabel.font = LIKEFONT(IPADFONT16);
    } else {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPHONEFONT17)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPHONEFONT17)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPHONEFONT14)];
         myCell.numLabel.font = LIKEFONT(IPHONEFONT16);
         myCell.commentLabel.font = LIKEFONT(IPHONEFONT16);
    }
    
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"]];
    query.cachePolicy = kPFCACHEPOLICY;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [myCell.blog2ImageView setImage:[UIImage imageWithData:data]];
                } else {
                    [myCell.blog2ImageView setImage:[UIImage imageNamed:BLOGCELLIMAGE]];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
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
                [DateFormatter setDateFormat:@"MMM-dd"];
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

    myCell.blog2ImageView.contentMode = UIViewContentModeScaleToFill;
    myCell.blog2ImageView.clipsToBounds = YES;
    myCell.blog2ImageView.layer.cornerRadius = myCell.blog2ImageView.frame.size.width / 2;
    myCell.blog2ImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myCell.blog2ImageView.layer.borderWidth = 0.5f;
    myCell.blog2ImageView.userInteractionEnabled = YES;
    myCell.blog2ImageView.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLoadSegue:)];
    [myCell.blog2ImageView addGestureRecognizer:tap];
    
    myCell.flagButton.tintColor = [UIColor lightGrayColor];
    UIImage *reportimage = [[UIImage imageNamed:@"Flag.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.flagButton setImage:reportimage forState:UIControlStateNormal];
    [myCell.flagButton addTarget:self action:@selector(flagButton:) forControlEvents:UIControlEventTouchUpInside];
    
    myCell.actionBtn.tintColor = [UIColor darkGrayColor];
     UIImage *imagebutton = [[UIImage imageNamed:@"Upload50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.actionBtn setImage:imagebutton forState:UIControlStateNormal];
    [myCell.actionBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
   
    NSString *text = myCell.blogsubtitleLabel.text;
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:text];
    //NSURL *URL = [NSURL URLWithString: @"whatsapp://app"];
    //[str addAttribute:NSLinkAttributeName value:URL range:[text rangeOfString:@"@"]];
    [str addAttribute: NSForegroundColorAttributeName value:BLUECOLOR range:[text rangeOfString:@"@Peter Balsamo"]];
    myCell.blogsubtitleLabel.attributedText = str;

    return myCell;
}

#pragma mark - Segue
- (void)imgLoadSegue:(UITapGestureRecognizer *)sender {
    
    titleLabel = [_feedItems[sender.view.tag] objectForKey:@"PostBy"];
    [self performSegueWithIdentifier: @"bloguserSegue" sender: self];
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return 30; //HEADHEIGHT;
        else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"MSG \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"LIKES \n%lu",(unsigned long) headCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE1)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE2)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE3)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [label setFont:CELL_BOLDFONT(IPADFONT16)];
        [label1 setFont:CELL_BOLDFONT(IPADFONT16)];
        [label2 setFont:CELL_BOLDFONT(IPADFONT16)];
    } else {
        [label setFont:CELL_MEDFONT(IPHONEFONT14) ];
        [label1 setFont:CELL_MEDFONT(IPHONEFONT14)];
        [label2 setFont:CELL_MEDFONT(IPHONEFONT14)];
    }

    [label setTextColor:HEADTEXTCOLOR];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE1)];
    separatorLineView.backgroundColor = BLOGLINECOLOR1;// you can also put image here
    [view addSubview:separatorLineView];
    
    label1.numberOfLines = 0;
    [label1 setTextColor:HEADTEXTCOLOR];
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE2)];
    separatorLineView1.backgroundColor = BLOGLINECOLOR1;
    [view addSubview:separatorLineView1];
    
    label2.numberOfLines = 0;
    [label2 setTextColor:HEADTEXTCOLOR];
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE3)];
    separatorLineView2.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:BLOGNAVBARCOLOR]; //[UIColor clearColor]]
        else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - Search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
   [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = SHIDE;
    self.searchController.dimsBackgroundDuringPresentation = SDIM;
    self.definesPresentationContext = SDEFINE;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLEBLOG;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLOR;
    self.searchController.searchBar.barTintColor = BLOGNAVBARCOLOR;
    //self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[BLOGSCOPE];
    self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   [self presentViewController:self.searchController animated:YES completion:nil];
}

 - (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
 {
 [self updateSearchResultsForSearchController:self.searchController];
 }

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
        return;
    }
    
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length == 0)
        isFilltered = NO;
    else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(PFObject *string in _feedItems)
        //for(BlogLocation* string in _feedItems)
            {
                NSRange stringRange;
                if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
                {
                    stringRange = [[string objectForKey:@"Subject"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    //stringRange = [string.subject rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
                {
                    stringRange = [[string objectForKey:@"MsgDate"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    //stringRange = [string.msgDate rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
                {
                    stringRange = [[string objectForKey:@"Rating"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    //stringRange = [string.rating rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 3)
                {
                    stringRange = [[string objectForKey:@"PostBy"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    //stringRange = [string.postby rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                }
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
        }
    [self.listTableView reloadData];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFilltered)
        _selectedLocation = _feedItems[indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:BLOGVIEWSEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"bloguserSegue"]) {
        BlogUserController *detailVC = segue.destinationViewController;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            if (!isFilltered) {
                detailVC.postBy = titleLabel;
                
            }
        }
    }
    
    if ([[segue identifier] isEqualToString:BLOGNEWSEGUE]) {
        BlogNewViewController *detailVC = segue.destinationViewController;
        if (isReplyClicked) {
            detailVC.formStatus = @"Reply";
            detailVC.textcontentsubject = [NSString stringWithFormat:@"@%@",posttoIndex];
            detailVC.textcontentpostby = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
            detailVC.replyId = [NSString stringWithFormat:@"%@",userIndex];
        } else {
            detailVC.formStatus = @"New";
            detailVC.textcontentpostby = [NSString stringWithFormat:@"%@",[[PFUser currentUser]valueForKey:@"username"]];
        }
    }
    
    if ([[segue identifier] isEqualToString:BLOGVIEWSEGUE])
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