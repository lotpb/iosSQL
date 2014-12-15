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
   // NSString *msgNo; //added
}
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end

@implementation BlogViewController
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title =  @"Blog";
    self.listTableView.estimatedRowHeight = 64.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"subject", @"date", @"rating", @"postby"];
    self.definesPresentationContext = YES;
   // [self.view addSubview:self.tableView];
    //[self.view addSubview:self.searchBar];
  
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
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor blackColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Refreshing"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
    refreshControl.attributedTitle = refreshString;
    [refreshView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bar Button
-(void)foundView:(id)sender
{
    [self performSegueWithIdentifier:@"NewBlogSegue" sender:self];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

-(void)itemsDownloaded:(NSMutableArray *)items
{
    // Set the downloaded items to the array
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark TableRefresh Reload
-(void)reloadDatas {
    [refreshControl endRefreshing];
}

#pragma mark TableView Delete Button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [self.listTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_feedItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
     //   [self.tableView reloadData];
        
      //  for(BlogLocation* string in _feedItems)
      //  {
        NSString *deletestring = _selectedLocation.msgNo;
      //  NSString *recordIDToDelete = deletestring;
            
     //   NSMutableString *rawStr = [NSString stringWithFormat:@"_msgNo=%@&&",[recordIDToDelete objectForKey:msgNo]];
        NSString *_msgNo = deletestring; //_selectedLocation.msgNo;
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
        
        NSLog(@"%lu", (unsigned long)responseString.length);
        NSLog(@"%lu", (unsigned long)success.length);
        
        [self.tableView reloadData];
        //[self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
       // }
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
    CustomTableViewCell *myCell = (CustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
    
    BlogLocation *item;
    if (!isFilltered) {
        item = _feedItems[indexPath.row];
    } else {
        item = [filteredString objectAtIndex:indexPath.row];
    }
    /*
    NSString *dateStr = item.msgDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd+hh:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    // Convert date object to desired output format
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [dateFormat setTimeStyle:NSDateFormatterNoStyle];
    dateStr = [dateFormat stringFromDate:date]; */
    
    myCell.blogtitleLabel.text = item.postby;
    myCell.blogsubtitleLabel.text = item.subject;
    myCell.blogmsgDateLabel.text = item.msgDate; //dateStr;
    myCell.blog2ImageView.image = [UIImage imageNamed:@"DemoCellImage"];
    
    // (x, y, width, height)
    CGRect frame1=CGRectMake(10,145, 30, 11);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame1;
    label2.text=  @"Like";
    label2.font = [UIFont boldSystemFontOfSize:9.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:[UIColor whiteColor]];
    [label2 setBackgroundColor:[UIColor redColor]];
    label2.tag = 103;
    
    if ([item.rating isEqual: @"4"])
    { label2.hidden = YES; }
    else { label2.hidden = NO; };
    [myCell.contentView addSubview:label2];
    
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"MSG \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n4,727.35"];
    NSString *newString2 = [NSString stringWithFormat:@"DOW \n17,776.80"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    //tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor redColor];// you can also put image here
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:[UIFont systemFontOfSize:12]];
    [label1 setTextColor:[UIColor whiteColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 45, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - Search
- (void)searchButton:(id)sender{
     self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
     self.searchBar.text=@"";
     self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isFilltered = NO;
       //[filteredString removeAllObjects];
      // [filteredString addObjectsFromArray:_feedItems];
    } else {
        isFilltered = YES;
       //[filteredString removeAllObjects];
        filteredString = [[NSMutableArray alloc]init];
        
        for(BlogLocation* string in _feedItems)
        {
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.subject rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.msgDate rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.rating rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.postby rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
        }
    }
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