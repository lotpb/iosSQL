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
    BlogModel *_BlogModel; BlogLocation *_selectedLocation; //ParseConnection *parseConnection;
    NSMutableArray *headCount, *_feedItems;
    UIRefreshControl *refreshControl;
    UILabel *numLabel;
    UIButton *flagButton;
    UIButton *likeButton;
    //BOOL *liked, *likeSelected;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation BlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BLOGNAVLOGO]];
    self.title = NSLocalizedString(TNAME9, nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 110; ROW_HEIGHT;
    self.listTableView.backgroundColor = BLOGNAVBARCOLOR;
    self.listTableView.pagingEnabled = YES;

    
   // bool liked = !likeButton.selected;
    
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
    NSArray *actionButtonItems = @[searchItem, addItem];
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

#pragma mark - Button
#pragma mark Bar Button
-(void)foundView:(id)sender {
    [self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
}

#pragma mark flag button
- (void) flagButton {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Report inappropriate user" message:@"Please enter reason" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"report",nil];
    
    alert.tintColor = [UIColor lightGrayColor];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
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

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    return 110.0;
    } else {
    return 105.0;
    }
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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:DELMESSAGE1
                                     message:DELMESSAGE2
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
                                     [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId] ];
                                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (!error) {
                                             for (PFObject *object in objects) {
                                                 [object deleteInBackground];
                                             }
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 } else {
                                 BlogLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.msgNo;
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
                                 [success dataUsingEncoding:NSUTF8StringEncoding];
                                 }
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                              //   GOBACK; //Do some thing here
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPADFONT18)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPADFONT18)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPADFONT16)];
    } else {
        [myCell.blogtitleLabel setFont:CELL_MEDFONT(IPHONEFONT17)];
        [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(IPHONEFONT17)];
        [myCell.blogmsgDateLabel setFont:CELL_FONT(IPHONEFONT14)];
    }

     myCell.blog2ImageView.clipsToBounds = YES;
     myCell.blog2ImageView.layer.cornerRadius = BLOGIMGRADIUS;
     myCell.blog2ImageView.contentMode = UIViewContentModeScaleToFill;
     myCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"]];
    [query setLimit:1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [myCell.blog2ImageView setImage:[UIImage imageWithData:data]];
                    myCell.blog2ImageView.contentMode = UIViewContentModeScaleAspectFill;
                    myCell.blog2ImageView.clipsToBounds = YES;
                    myCell.blog2ImageView.layer.cornerRadius = 22.f;
                    myCell.blog2ImageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
                    myCell.blog2ImageView.layer.borderWidth = 0.5f;
                } else {
                    [myCell.blog2ImageView setImage:[UIImage imageNamed:BLOGCELLIMAGE]];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        if (!isFilltered) {
            NSString *dateStr = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
            static NSDateFormatter *DateFormatter = nil;
            if (DateFormatter == nil) {
                NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
                [DateFormatter setDateFormat:KEY_DATETIME];
                NSDate *date = [DateFormatter dateFromString:dateStr];
                [DateFormatter setDateFormat:BLOG_FORMAT];
                dateStr = [DateFormatter stringFromDate:date];
            }
            
            myCell.blogtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            myCell.blogsubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            myCell.blogmsgDateLabel.text = dateStr;
        } else {
            myCell.blogtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            myCell.blogsubtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            myCell.blogmsgDateLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
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
   
    UIView *buttonview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(myCell.blogsubtitleLabel.frame) +40, self.listTableView.frame.size.width, 25)];
    buttonview.backgroundColor = [UIColor whiteColor];
    [myCell.contentView addSubview:buttonview];
    
    UIButton *replyButton = [[UIButton alloc] initWithFrame:CGRectMake(75 ,5, 20, 20)];
    replyButton.tintColor = [UIColor lightGrayColor];
    UIImage *replyimage =[[UIImage imageNamed:@"Left 2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [replyButton setImage:replyimage forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    [buttonview addSubview:replyButton];
    
    //bool liked = likeButton.selected;
    UIImage *image = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [likeButton setImage:image forState:UIControlStateNormal];
    
    [likeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    //[likeButton addTarget:self action:@selector(buttonPressReset:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    [likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
    likeButton = [[UIButton alloc] initWithFrame:CGRectMake(140 ,5, 20, 20)];
    likeButton.tintColor = [UIColor lightGrayColor];
/*
    if (likeButton.isSelected) {
        likeButton.tintColor = [UIColor redColor];
    } else {
        likeButton.tintColor = [UIColor lightGrayColor];
    } */
    //likeButton.tag=indexPath.row;
    [buttonview addSubview:likeButton];
    
    numLabel = nil;
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 7, 20, 20)];
    numLabel.font = CELL_FONT(IPHONEFONT16);
    numLabel.textColor = [UIColor grayColor];
    numLabel.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Liked"]stringValue];
    [numLabel sizeToFit];
    [buttonview addSubview:numLabel];
    
    flagButton = [[UIButton alloc] initWithFrame:CGRectMake(205 ,5, 20, 20)];
    flagButton.tintColor = [UIColor lightGrayColor];
    UIImage *reportimage = [[UIImage imageNamed:@"Flag.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [flagButton setImage:reportimage forState:UIControlStateNormal];
    [flagButton addTarget:self action:@selector(flagButton) forControlEvents:UIControlEventTouchUpInside];
    [buttonview addSubview:flagButton];

    return myCell;
}

-(void)buttonPress:(id)sender{
    UIButton* button = (UIButton*)sender;
    if (!likeButton.selected) {
        [likeButton setSelected:YES];
        button.tintColor = [UIColor redColor];
    } else {
        [likeButton setSelected:NO];
        button.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark like button
- (void)likeButton:(id)sender  {
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.listTableView];
    NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition.origin];
    //NSLog(@"%ld",(long)indexPath.row);
    
    //BOOL liked = likeButton.selected;
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.listTableView];
    //NSIndexPath *indexPath = [self.listTableView indexPathForRowAtPoint:buttonPosition];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateLead, NSError *error) {
        if (!error) {
            NSNumber* likedNum = [[_feedItems objectAtIndex:indexPath.row] valueForKey:@"Liked"];
            int likeCount = [likedNum intValue];
 
            if (likeButton.isSelected) {
                likeCount++;
               // NSLog(@"selected");
            } else {
                likeCount--;
               // NSLog(@"not selected");
            }
            
            NSNumber *numCount = [NSNumber numberWithInteger: likeCount];
            [updateLead setObject:numCount ? numCount:[NSNumber numberWithInteger: 0] forKey:@"Liked"];
            [updateLead saveInBackground];

            //[self reloadDatas:self];
            //numLabel.text = [NSString stringWithFormat:@"%d", likeCount]; //dont work
        }
    }];
    //[self.listTableView reloadData];
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
    
    if ([[segue identifier] isEqualToString:BLOGVIEWSEGUE])
    {
        BlogEditDetailView *detailVC = segue.destinationViewController;
       
        /*
         *******************************************************************************************
         Parse.com
         *******************************************************************************************
         */
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
             NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            if (!isFilltered) {
                detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                detailVC.msgNo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgNo"];
                detailVC.postby = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
                detailVC.subject = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
                detailVC.msgDate = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
                detailVC.rating = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rating"];
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