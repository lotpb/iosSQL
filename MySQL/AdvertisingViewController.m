//
//  AdvertisingViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "AdvertisingViewController.h"
#import "AdLocation.h"
#import <Parse/Parse.h>

@interface AdvertisingViewController ()

{
    AdModel *_AdModel; NSMutableArray *_feedItems; AdLocation *_selectedLocation; UIRefreshControl *refreshControl;
  
    NSMutableArray *adCount;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation AdvertisingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  @"Advertising";
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"advertisement",@"adNo",@"active"];
    self.definesPresentationContext = YES;
    
    _feedItems = [[NSMutableArray alloc] init];
    _AdModel = [[AdModel alloc] init];
    _AdModel.delegate = self; [_AdModel downloadItems];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Advertising"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" containsString:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adCount = [[NSMutableArray alloc]initWithArray:objects];
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark  Bar Button
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark  Table Refresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor grayColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Refreshing"];
    //add date to refresh
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
    [refreshView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table
-(void)itemsDownloaded:(NSMutableArray *)items
{   // This delegate method will get called when the items are finished downloading
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
-(void)reloadDatas {
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark  Table Delete Button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing
           animated:(BOOL)animated{
    
    [super setEditing:editing
             animated:animated];
    
    [self.listTableView setEditing:editing
                          animated:animated];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_feedItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView reloadData];
        /*
         NSError *error = nil;
         if (![tableView save:&error]) {
         NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
         return;
         } */
    }
}

#pragma mark  TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFilltered) {
        return [filteredString  count];
    }
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    myCell.layer.cornerRadius = 5;
    myCell.layer.masksToBounds = YES;
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
    
    AdLocation *item;
    if (!isFilltered) {
        item = _feedItems[indexPath.row];
    } else {
        item = [filteredString objectAtIndex:indexPath.row];
    }
    
        myCell.textLabel.text = item.Advertiser;
        myCell.detailTextLabel.text = item.AdNo;
        UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
        [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark  Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return 55.0;
    else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"ADS \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"ACTIVE \n%lu",(unsigned long) adCount.count];
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
    separatorLineView1.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 45, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor greenColor];
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
        
        for(AdLocation *string in _feedItems)
        {
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.Advertiser rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.AdNo rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Set selected location to var
    //  _selectedLocation = _feedItems[indexPath.row];
    //  [self performSegueWithIdentifier:@"proddetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"proddetailSegue"])
    { /*
       // Get reference to the destination view controller
       VendorDetailController *detailVC = segue.destinationViewController;
       detailVC.selectedLocation = _selectedLocation; */
    }
}

@end
