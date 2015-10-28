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
    UILabel *emptyLabel;
    UIRefreshControl *refreshControl;
}
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

    self.selectedImage = [UIImage imageNamed:@"profile-rabbit-toy.png"];
    [self parseData];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    NSArray *actionButtonItems = @[shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = DARKGRAYCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
    
    emptyLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.text = @"You have no customer data :)";
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
    
    self.navigationController.navigationBar.barTintColor = DARKGRAYCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    [self parseData];
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

/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/

- (void)parseHeadBlogloaded:(NSMutableArray *)blogheadItem {
    headCount = blogheadItem;
    [self.listTableView reloadData];
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
        myCell.commentLabel.font = LIKEFONT(IPADFONT16);
    } else {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPHONEFONT17)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPHONEFONT17)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPHONEFONT14)];
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
                [DateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *date = [DateFormatter dateFromString:dateStr];
                [DateFormatter setDateFormat:@"MMM dd, yyyy"];
                dateStr = [DateFormatter stringFromDate:date];
            
            myCell.blogtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            myCell.blogsubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
                myCell.blogmsgDateLabel.text = dateStr;//[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];;
            myCell.commentLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]stringValue];
            }
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
    NSString *newString3, *newString;
    if ([self.formController isEqual:TNAME1]) {
        newString = [NSString stringWithFormat:@"CUST \n%lu", (unsigned long) _feedItems.count];
    } else {
        newString = [NSString stringWithFormat:@"LEADS \n%lu", (unsigned long) _feedItems.count];
    }
    NSString *newString1 = [NSString stringWithFormat:@"ACTIVE \n%lu",(unsigned long) headCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    NSString *newString4 = self.postBy;
    NSString *newString5 = self.comments;
    NSString *dateStr = self.leadDate;
    
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [DateFormatter dateFromString:dateStr];
        [DateFormatter setDateFormat:@"MMM dd, yyyy"];
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
    label4.numberOfLines = 1;
    NSString *string4 = newString4;
    [label4 setText:string4];
    [view addSubview:label4];
    
    [label5 setTextColor:DARKGRAYCOLOR];
    label5.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label5.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label5.numberOfLines = 0;
    label5.backgroundColor = [UIColor clearColor];
    NSString *string5 = newString5;
    [label5 setText:string5];
    [view addSubview:label5];
    
    [label3 setTextColor:DARKGRAYCOLOR];
    label3.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label3.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label3.numberOfLines = 1;
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
    
    [label1 setTextColor:MAINNAVCOLOR];
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE2)];
    separatorLineView1.backgroundColor = BLOGLINECOLOR1;
    [view addSubview:separatorLineView1];
    
    [label2 setTextColor:MAINNAVCOLOR];
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label2.numberOfLines = 0;
    label2.backgroundColor = [UIColor clearColor];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(BLINESIZE3)];
    separatorLineView2.backgroundColor = BLOGLINECOLOR1;
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:LIGHTGRAYCOLOR]; //[UIColor clearColor]]
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - Parse
- (void)parseData {
    if ([self.formController isEqual:TNAME1]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query whereKey:@"LastName" equalTo:self.postBy];
        query.cachePolicy = kPFCACHEPOLICY;
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                _feedItems = nil;
                _feedItems = [[NSMutableArray alloc] initWithArray:objects];
                
                if (_feedItems.count==0) {
                    [self.listTableView addSubview:emptyLabel];
                } else {
                    [emptyLabel removeFromSuperview];
                }
                
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
                
                if (_feedItems.count==0) {
                    [self.listTableView addSubview:emptyLabel];
                } else {
                    [emptyLabel removeFromSuperview];
                }
                
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
}

#pragma mark - Button

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

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (!isFilltered)
        _selectedLocation = _feedItems[indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row]; */
    
    [self performSegueWithIdentifier:@"leaduserDetailSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"leaduserDetailSegue"])
    {
        
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
        
        if ([self.formController isEqual:TNAME2]) {
            
            detailVC.formController = TNAME2;
            detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
            detailVC.leadNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LeadNo"]stringValue];
            detailVC.date = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];
            detailVC.name = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            detailVC.address = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Address"];
            detailVC.city = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
            detailVC.state = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"State"];
            detailVC.zip = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Zip"]stringValue];
            detailVC.amount = [NSString stringWithFormat:@"%@",[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
            detailVC.tbl11 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CallBack"];
            detailVC.tbl12 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Phone"];
            detailVC.tbl13 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"];
            detailVC.tbl14 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Spouse"];
            detailVC.tbl15 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Email"];
            detailVC.tbl21 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"AptDate"];
            detailVC.tbl22 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"SalesNo"]stringValue];
            detailVC.tbl23 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"JobNo"]stringValue];
            detailVC.tbl24 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"AdNo"]stringValue];
            detailVC.tbl25 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            detailVC.tbl16 = [NSString stringWithFormat:@"%@",[[_feedItems objectAtIndex:indexPath.row] updatedAt]];
            detailVC.tbl26 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Photo"];
            detailVC.photo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Photo"];
            detailVC.comments = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Coments"];
            detailVC.active = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            
            detailVC.l11 = @"Call Back"; detailVC.l12 = @"Phone";
            detailVC.l13 = @"First"; detailVC.l14 = @"Spouse";
            detailVC.l15 = @"Email"; detailVC.l21 = @"Apt Date";
            detailVC.l22 = @"Salesman"; detailVC.l23 = @"Job";
            detailVC.l24 = @"Advertiser"; detailVC.l25 = @"Active";
            detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Photo";
            detailVC.l1datetext = @"Lead Date:";
            detailVC.lnewsTitle = LEADNEWSTITLE;
            
        } else if ([self.formController isEqual:TNAME1]) {
            
            detailVC.formController = TNAME1;
            detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
            detailVC.custNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CustNo"]stringValue];
            detailVC.leadNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LeadNo"]stringValue];
            detailVC.date = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];
            detailVC.name = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            detailVC.address = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Address"];
            detailVC.city = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
            detailVC.state = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"State"];
            detailVC.zip = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Zip"]stringValue];
            detailVC.amount = [NSString stringWithFormat:@"%@",[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
            detailVC.tbl11 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Contractor"];
            detailVC.tbl12 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Phone"];
            detailVC.tbl13 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"];
            detailVC.tbl14 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Spouse"];
            detailVC.tbl15 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Email"];
            detailVC.tbl21 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Start"];
            detailVC.tbl22 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"SalesNo"]stringValue];
            detailVC.tbl23 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"JobNo"]stringValue];
            detailVC.tbl24 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"ProductNo"]stringValue];
            detailVC.tbl25 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Quan"]stringValue];
            detailVC.tbl16 = [NSString stringWithFormat:@"%@",[[_feedItems objectAtIndex:indexPath.row] updatedAt]];
            detailVC.tbl26 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rate"];
            detailVC.complete = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Completion"];
            detailVC.photo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Photo"];
            detailVC.comments = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Comments"];
            detailVC.active = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            
            detailVC.l11 = @"Contractor"; detailVC.l12 = @"Phone";
            detailVC.l13 = @"First"; detailVC.l14 = @"Spouse";
            detailVC.l15 = @"Email"; detailVC.l21 = @"Start date";
            detailVC.l22 = @"Salesman"; detailVC.l23 = @"Job";
            detailVC.l24 = @"Product"; detailVC.l25 = @"Quan";
            detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Rate";
            detailVC.l1datetext = @"Sale Date:";
            detailVC.lnewsTitle = CUSTOMERNEWSTITLE;
            
        }
    }
}

@end
