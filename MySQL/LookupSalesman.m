//
//  LookupSalesman.m
//  MySQL
//
//  Created by Peter Balsamo on 1/25/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "LookupSalesman.h"
#import <Parse/Parse.h>

@interface LookupSalesman ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *salesArray;
    NSString *salesName;
}
@property (strong, nonatomic) NSString *tsa22;
@property (strong, nonatomic) NSString *tsn22;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation LookupSalesman

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Salesman lookup", nil);
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = LHIDE;
    self.searchController.dimsBackgroundDuringPresentation = LDIM;
    self.definesPresentationContext = SDEFINE;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLOR;
    self.searchController.searchBar.barTintColor = SEARCHBARTINTCOLOR;
    self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // self.navigationItem.titleView = self.searchController.searchBar;
    [self presentViewController:self.searchController animated:YES completion:nil];
    
    salesArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    //[PFQuery clearAllCachedResults];
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"Salesman"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [salesArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:salesArray];
 /*
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems; */
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

#pragma mark - TableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilltered)
        return filteredString.count;
        else
        return salesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (!isFilltered)
        salesName = [[salesArray objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
     else
        salesName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
    
    myCell.textLabel.text = salesName;
    
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
        for(PFObject *str in salesArray)
        {
            NSRange stringRange = [[str objectForKey:@"Salesman"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
                [filteredString addObject:str];
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - passDataBack
- (void)passDataBack {
    NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
    if (!isFilltered) {
        [self.delegate salesFromController:self.tsa22 = [[salesArray objectAtIndex:indexPath.row]objectForKey:@"SalesNo"]];
        [self.delegate salesNameFromController:self.tsn22 = [[salesArray objectAtIndex:indexPath.row]objectForKey:@"Salesman"]];
       } else {
        [self.delegate salesFromController:self.tsa22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"SalesNo"]];
        [self.delegate salesNameFromController:self.tsn22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"Salesman"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        [salesArray objectAtIndex:indexPath.row];
    else
        [filteredString objectAtIndex:indexPath.row];
    
    [self passDataBack];
}

@end
