//
//  BlogViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "BlogViewController.h"
#import "CustomTableViewCell.h"

@interface BlogViewController ()
{
    BlogModel *_BlogModel; NSMutableArray *_feedItems; BlogLocation *_selectedLocation;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation BlogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = BLOGNAVCOLOR;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mySQLBLOG.png"]];
    self.title = NSLocalizedString(@"Blog", nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
  
    _feedItems = [[NSMutableArray alloc] init]; _BlogModel = [[BlogModel alloc] init];
    _BlogModel.delegate = self; [_BlogModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(foundView:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = BLOGNAVCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:KEY_DATEREFRESH];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
        forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
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

#pragma mark - Bar Button
-(void)foundView:(id)sender {
    [self performSegueWithIdentifier:@"NewBlogSegue" sender:self];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
- (void)reloadDatas:(id)sender {
    [_BlogModel downloadItems];
    [self.listTableView reloadData];
    [refreshControl endRefreshing];
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
                                     alertControllerWithTitle:@"Delete the selected message?"
                                     message:@"OK, delete it"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 BlogLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.msgNo;
                                 // NSLog(@"rawStr is %@",deletestring);
                                 NSString *_msgNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:@"_msgNo=%@&&", _msgNo];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteBlog.php"];
                                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                                 
                                 [request setHTTPMethod:@"POST"];
                                 [request setHTTPBody:data];
                                 NSURLResponse *response;
                                 NSError *err;
                                 NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                                 NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
                                 NSLog(@"%@", responseString);
                                 NSString *success = @"success";
                                 [success dataUsingEncoding:NSUTF8StringEncoding];
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                 [self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
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
        [self.listTableView reloadData];
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
    static NSString *CellIdentifier = @"blogCell";
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 30, 11)];
    
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    BlogLocation *item;
    if (!isFilltered)
        item = _feedItems[indexPath.row];
        else
        item = [filteredString objectAtIndex:indexPath.row];
    
    [myCell.blogtitleLabel setFont:CELL_MEDFONT(BLOG_FONTSIZE)];
    [myCell.blogsubtitleLabel setFont:CELL_LIGHTFONT(BLOG_FONTSIZE)];
    [myCell.blogmsgDateLabel setFont:CELL_FONT(BLOG_FONTSIZE - 1)];
    
    myCell.blogtitleLabel.text = item.postby;
    myCell.blogsubtitleLabel.text = item.subject;
    myCell.blogmsgDateLabel.text = item.msgDate;
    myCell.blog2ImageView.image = [UIImage imageNamed:@"DemoCellImage"];
    
    //not working properly below
    if ([item.rating isEqual:@"5"])
         label2.hidden = NO;
    else label2.hidden = YES;
    
     label2.text = @"Like";
     label2.font = LIKEFONT(LIKEFONTSIZE);
     label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:LIKECOLORTEXT];
    [label2 setBackgroundColor:LIKECOLORBACK];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:CELL_MEDFONT(HEADFONTSIZE) ];
    [label setTextColor:HEADCOLOR];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor whiteColor];// you can also put image here
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_MEDFONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_MEDFONT(HEADFONTSIZE)];
    [label2 setTextColor:HEADCOLOR];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 45, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:BLOGNAVCOLOR]; //[UIColor clearColor]]
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
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.barStyle = UIBarStyleBlack;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    //self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.scopeButtonTitles = @[@"subject", @"date", @"rating", @"postby"];
    self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
   [self presentViewController:self.searchController animated:YES completion:nil];
}

 - (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
 {
 [self updateSearchResultsForSearchController:self.searchController];
 }

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        return;
    }
    
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length == 0)
        isFilltered = NO;
        else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
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
    [self.listTableView reloadData];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFilltered)
        _selectedLocation = _feedItems[indexPath.row];
        else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"blogviewSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"blogviewSegue"])
   {
    BlogEditDetailView*detailVC = segue.destinationViewController;
    detailVC.selectedLocation = _selectedLocation;
   }
}

@end