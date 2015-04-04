//
//  LookupCity.m
//  MySQL
//
//  Created by Peter Balsamo on 1/7/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "LookupCity.h"
#import <Parse/Parse.h>

@interface LookupCity ()
{
UIRefreshControl *refreshControl;
NSMutableArray *zipArray;
NSString *cityName;
}
@property (strong, nonatomic) NSString *tci14;
@property (strong, nonatomic) NSString *tst15;
@property (strong, nonatomic) NSString *tzi21;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation LookupCity

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"City lookup", nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.barStyle = UIBarStyleBlack;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // self.navigationItem.titleView = self.searchController.searchBar;
    [self presentViewController:self.searchController animated:YES completion:nil];
    
    zipArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
    [PFQuery clearAllCachedResults];
    //[query selectKeys:@[@"ZipNo"]];
    [query selectKeys:@[@"City"]];
    [query selectKeys:@[@"State"]];
    [query selectKeys:@[@"zipCode"]];
    [query orderByAscending:@"City"];
    [query setLimit: 1000]; //parse.com standard is 100
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [zipArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:zipArray];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilltered)
        return filteredString.count;
        else
        return zipArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (!isFilltered)
        cityName = [[zipArray objectAtIndex:indexPath.row] objectForKey:@"City"];
       else
        cityName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
    
    myCell.textLabel.text = cityName;
    
    return myCell;
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length == 0)
        isFilltered = NO;
    else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(PFObject *str in zipArray)
        {
            NSRange stringRange = [[str objectForKey:@"City"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
                [filteredString addObject:str];
        }
    }
    [self.listTableView reloadData];
}

- (void)passDataBack {
   
    NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
     if (!isFilltered) {
     [self.delegate cityFromController:self.tci14 =[[zipArray objectAtIndex:indexPath.row]objectForKey:@"City"]];
     [self.delegate stateFromController:self.tst15 =[[zipArray objectAtIndex:indexPath.row]objectForKey:@"State"]];
     [self.delegate zipFromController:self.tzi21 =[[zipArray objectAtIndex:indexPath.row]objectForKey:@"zipCode"]];
     } else {
     [self.delegate cityFromController:self.tci14 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"City"]];
     [self.delegate stateFromController:self.tst15 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"State"]];
     [self.delegate zipFromController:self.tzi21 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"zipCode"]]; }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        [zipArray objectAtIndex:indexPath.row];
        else
        [filteredString objectAtIndex:indexPath.row];
    
        [self passDataBack];
}

@end
