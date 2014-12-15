//
//  ViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "ViewController.h"
#import "Location.h"

@interface ViewController ()
{
    HomeModel *_homeModel; NSMutableArray *_feedItems; Location *_selectedLocation;
    UIRefreshControl *refreshControl;
}
//@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation ViewController
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  @"Leads";
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"name",@"city",@"phone",@"active"];
    self.definesPresentationContext = YES;
    
    _feedItems = [[NSMutableArray alloc] init]; _homeModel = [[HomeModel alloc] init]; _homeModel.delegate = self; [_homeModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] init];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor clearColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Refreshing"];
    
    //add date to refresh
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    { NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [ formatter setDateFormat:@"MMM d, h:mm a"];
      NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
      refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    }

    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
        [refreshView addSubview:refreshControl];
/*
    NSMutableArray *scopeButtonTitles = [[NSMutableArray alloc] init];
    [scopeButtonTitles addObject:NSLocalizedString(@"All", @"Search display controller All button.")];
    self.searchBar.scopeButtonTitles = scopeButtonTitles; */
    
}
/*
- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
} 

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
} */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
-(void)reloadDatas {
    [refreshControl endRefreshing];
}

-(void)itemsDownloaded:(NSMutableArray *)items {
    // Set the downloaded items to the array
    _feedItems = items;
    
    // Reload the table view
    [self.listTableView reloadData];
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
        [self.tableView reloadData];
        
        NSString *recordIDToDelete = _feedItems[indexPath.row];
        NSString *_msgNo = recordIDToDelete;
        NSString *rawStr = [NSString stringWithFormat:@"_msgNo=%@&&", _msgNo];
        NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteLead.php"];
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
       // [self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
    }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFilltered)
    return filteredString.count;
    else
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]; }
    
    Location *item;
    if (!isFilltered) {
        item = _feedItems[indexPath.row];
    } else {
        item = [filteredString objectAtIndex:indexPath.row];
    }

    myCell.textLabel.text = item.name;
    myCell.detailTextLabel.text = item.city;
    UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
    [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"LEADS \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n4,727.35"];
    NSString *newString2 = [NSString stringWithFormat:@"DOW \n17,776.80"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor redColor];
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

#pragma mark - search
- (void)searchButton:(id)sender {
    self.searchBar.hidden = NO;
   [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  
    self.searchBar.text=@"";
     self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
    //[self.listTableView reloadData];
    //[self.listTableView becomeFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isFilltered = NO;
    } else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        
        for(Location* string in _feedItems)
        {   
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
               NSRange stringRange = [string.name rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
              if(stringRange.location != NSNotFound) {
                [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.phone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
        }
     }
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        _selectedLocation = _feedItems[indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    // [self.navigationController pushViewController:detailViewController animated:YES];
   // [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
    // Get reference to the destination view controller
    LeadDetailViewControler *detailVC = segue.destinationViewController;
    detailVC.selectedLocation = _selectedLocation;
    }
}

@end
