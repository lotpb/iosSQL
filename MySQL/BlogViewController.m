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
    UIRefreshControl *refreshControl;
    NSMutableArray *_feedItems;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation BlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BLOGNAVLOGO]];
    self.title = NSLocalizedString(TNAME9, nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.listTableView.backgroundColor = BLOGNAVBARCOLOR;
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self; [parseConnection parseBlog];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = BLOGNAVBARCOLOR;
    self.navigationController.navigationBar.translucent = BLOGNAVBARTRANSLUCENT;
    self.navigationController.navigationBar.tintColor = BLOGNAVBARTINTCOLOR ;
   [self reloadDatas:nil];
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
        parseConnection.delegate = (id)self; [parseConnection parseBlog];
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

#pragma mark - Bar Button
-(void)foundView:(id)sender {
    [self performSegueWithIdentifier:BLOGNEWSEGUE sender:self];
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

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
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
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(23, 143, 30, 11)];
    
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    BlogLocation *item;
    if (!isFilltered)
        item = _feedItems[indexPath.row];
    else
        item = [filteredString objectAtIndex:indexPath.row];
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        
        myCell.blogtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
        myCell.blogsubtitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
        myCell.blogmsgDateLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
        if (![[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rating"] isEqual:@"5"])
             label2.hidden = NO;
        else label2.hidden = YES;
    } else {
        myCell.blogtitleLabel.text = item.postby;
        myCell.blogsubtitleLabel.text = item.subject;
        myCell.blogmsgDateLabel.text = item.msgDate;
        if (![item.rating isEqual:@"5"])
             [label2 setBackgroundColor:LIKECOLORBACK];
           // label2.hidden = NO;
        else [label2 setBackgroundColor:[UIColor whiteColor]];//label2.hidden = YES;
    }
    
    [myCell.blogtitleLabel setFont:CELL_MEDFONT(BLOG_FONTSIZE)];
    [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(BLOG_FONTSIZE)];
    [myCell.blogmsgDateLabel setFont:CELL_FONT(BLOG_FONTSIZE - 1)];
    
    myCell.blog2ImageView.image = [UIImage imageNamed:BLOGCELLIMAGE];
    myCell.blog2ImageView.clipsToBounds = YES;
    myCell.blog2ImageView.layer.cornerRadius = BLOGIMGRADIUS;
    myCell.blog2ImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    label2.text = @"Like";
    label2.font = LIKEFONT(LIKEFONTSIZE);
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:LIKECOLORTEXT];

    [myCell.contentView addSubview:label2];
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return HEADHEIGHT;
        else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"MSG \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:HEADTITLE2];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    //tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE1)];
    [label setFont:CELL_MEDFONT(HEADFONTSIZE) ];
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
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE2)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_MEDFONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADTEXTCOLOR];
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE2)];
    separatorLineView1.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE3)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_MEDFONT(HEADFONTSIZE)];
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
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search" message:@"No search in Parse at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        } else {
            for(BlogLocation* string in _feedItems)
            {
                if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
                {
                    NSRange stringRange = [string.subject rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                    if(stringRange.location != NSNotFound)
                        [filteredString addObject:string];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
                {
                    NSRange stringRange = [string.msgDate rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                    if(stringRange.location != NSNotFound)
                        [filteredString addObject:string];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
                {
                    NSRange stringRange = [string.rating rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                    if(stringRange.location != NSNotFound)
                        [filteredString addObject:string];
                }
                
                if (self.searchController.searchBar.selectedScopeButtonIndex == 3)
                {
                    NSRange stringRange = [string.postby rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                    if(stringRange.location != NSNotFound)
                        [filteredString addObject:string];
                }
            }
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
        BlogEditDetailView*detailVC = segue.destinationViewController;
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            
            NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
            detailVC.msgNo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgNo"];
            detailVC.postby = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"PostBy"];
            detailVC.subject = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Subject"];
            detailVC.msgDate = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"MsgDate"];
            detailVC.rating = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rating"];
        }
        else
            detailVC.selectedLocation = _selectedLocation;
        
    }
}

@end