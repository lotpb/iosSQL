//
//  LeadsUserController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/11/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "LeadsUserController.h"

@interface LeadsUserController ()
{
    BlogModel *_BlogModel; BlogLocation *_selectedLocation;
    NSMutableArray *headCount, *_feedItems;
    UIRefreshControl *refreshControl;
    BOOL isReplyClicked;
    //NSString *posttoIndex, *userIndex, *getpostby, *getdate;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UIView *buttonView;
@property (strong, nonatomic) UIImage *selectedImage;

@end

@implementation LeadsUserController

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
    if ([self.formController isEqual:TNAME1]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query whereKey:@"LastName" equalTo:self.postBy];
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
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Leads"];
        [query1 whereKey:@"objectId" equalTo:self.objectId];
        query1.cachePolicy = kPFCACHEPOLICY;
        [query1 orderByDescending:@"createdAt"];
        [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                self.comments = [object objectForKey:@"Coments"];
                self.leadDate = [object objectForKey:@"Date"];
                [self.listTableView reloadData];
            } else
                NSLog(@"Error: %@ %@", error, [error userInfo]);
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
        [query whereKey:@"LastName" equalTo:self.postBy];
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
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"Customer"];
        [query1 whereKey:@"objectId" equalTo:self.objectId];
        query1.cachePolicy = kPFCACHEPOLICY;
        [query1 orderByDescending:@"createdAt"];
        [query1 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                self.comments = [object objectForKey:@"Comments"];
                self.leadDate = [object objectForKey:@"Date"];
                [self.listTableView reloadData];
            } else
                NSLog(@"Error: %@ %@", error, [error userInfo]);
        }];
    }

    self.selectedImage = [UIImage imageNamed:@"profile-rabbit-toy.png"];
    
    /*
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
    }]; */
    
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
    //[self reloadDatas:nil];
    
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

#pragma mark New BarButton
-(void)foundView:(id)sender {
    //isReplyClicked = NO;
    //[self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
}

/*
#pragma mark reply button
-(void)replyButton:(id)sender {
    isReplyClicked = YES;
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.listTableView];
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition.origin];
    posttoIndex = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
    userIndex = [[_feedItems objectAtIndex:indexPath.row] objectId];
    [self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
} */

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
        //myCell.numLabel.font = LIKEFONT(IPADFONT16);
        myCell.commentLabel.font = LIKEFONT(IPADFONT16);
    } else {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPHONEFONT17)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPHONEFONT17)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPHONEFONT14)];
        //myCell.numLabel.font = LIKEFONT(IPHONEFONT16);
        myCell.commentLabel.font = LIKEFONT(IPHONEFONT16);
    }
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        if (!isFilltered) {
            
            NSString *dateStr = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];
            static NSDateFormatter *DateFormatter = nil;
            if (DateFormatter == nil) {
                NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:@"yyyy-mm-dd"];
                NSDate *date = [DateFormatter dateFromString:dateStr];
                [DateFormatter setDateFormat:@"MMM-dd-yy"];
                dateStr = [DateFormatter stringFromDate:date];
            }
            
            myCell.blogtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            myCell.blogsubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
            myCell.blogmsgDateLabel.text = dateStr;
            myCell.commentLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]stringValue];
        } else {
            myCell.blogtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            myCell.blogsubtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
            //myCell.blogmsgDateLabel.text = dateStr;
            myCell.commentLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]stringValue];
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
    
    myCell.replyButton.tintColor = [UIColor lightGrayColor];
    UIImage *replyimage =[[UIImage imageNamed:@"Commentfilled.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.replyButton setImage:replyimage forState:UIControlStateNormal];
    //[myCell.replyButton addTarget:self action:@selector(replyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [myCell.likeButton setImage:image forState:UIControlStateNormal];
    //[myCell.likeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    //[myCell.likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    myCell.likeButton.tintColor = [UIColor lightGrayColor];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
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
    NSString *newString3;
    NSString *newString = [NSString stringWithFormat:@"CUST \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"ACTIVE \n%lu",(unsigned long) headCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    NSString *newString4 = self.postBy;
    NSString *newString5 = self.comments;
    
    NSString *dateStr = self.leadDate;
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSDate *date = [DateFormatter dateFromString:dateStr];
        [DateFormatter setDateFormat:@"MMM-dd-yy"];
        dateStr = [DateFormatter stringFromDate:date];
        if ([self.formController isEqual:TNAME1]) {
            newString3 = [NSString stringWithFormat:@"Lead since %@",dateStr];
        } else {
            newString3 = [NSString stringWithFormat:@"Customer since %@",dateStr];
        }
    }
    
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
        [label3 setFont:CELL_LIGHTFONT(IPADFONT18)];
        [label4 setFont:CELL_MEDFONT(IPADFONT18)];
        [label5 setFont:CELL_LIGHTFONT(IPADFONT18)];
    } else {
        [label setFont:CELL_MEDFONT(IPHONEFONT14) ];
        [label1 setFont:CELL_MEDFONT(IPHONEFONT14)];
        [label2 setFont:CELL_MEDFONT(IPHONEFONT14)];
        [label3 setFont:CELL_LIGHTFONT(IPHONEFONT17) ];
        [label4 setFont:CELL_MEDFONT(IPHONEFONT17)];
        [label5 setFont:CELL_LIGHTFONT(IPHONEFONT17)];
    }
    
    UIImageView *image1 =[[UIImageView alloc] initWithFrame:CGRectMake(21, 10, 45, 45)];
    image1.image = self.selectedImage;
    image1.contentMode = UIViewContentModeScaleToFill;
    image1.clipsToBounds = YES;
    image1.layer.cornerRadius = image1.frame.size.width / 2;
    image1.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    image1.layer.borderWidth = 0.5f;
    [view addSubview:image1];
    
    [label4 setTextColor:HEADTEXTCOLOR];
    label4.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label4.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label4.backgroundColor = [UIColor clearColor];
    label4.numberOfLines = 0;
    NSString *string4 = newString4;
    [label4 setText:string4];
    [view addSubview:label4];
    
    [label5 setTextColor:HEADTEXTCOLOR];
    label5.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label5.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label5.numberOfLines = 0;
    label5.backgroundColor = [UIColor clearColor];
    NSString *string5 = newString5;
    [label5 setText:string5];
    [view addSubview:label5];
    
    [label3 setTextColor:HEADTEXTCOLOR];
    label3.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label3.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label3.numberOfLines = 0;
    label3.backgroundColor = [UIColor clearColor];
    NSString *string3 = newString3;
    [label3 setText:string3];
    [view addSubview:label3];
    
    [label setTextColor:HEADTEXTCOLOR];
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
    [label1 setTextColor:HEADTEXTCOLOR];
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
    [label2 setTextColor:HEADTEXTCOLOR];
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label2.backgroundColor = [UIColor clearColor];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE3)];
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
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
}

@end
