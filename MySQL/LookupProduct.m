//
//  LookupProduct.m
//  MySQL
//
//  Created by Peter Balsamo on 1/15/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
// this ViewController handles Products and Advertisers

#import "LookupProduct.h"
#import <Parse/Parse.h>

@interface LookupProduct ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *adproductArray;
    NSString *adproductName;
}
@property (strong, nonatomic) NSString *tpr22;
@property (strong, nonatomic) NSString *tpn22;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LookupProduct

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_formController isEqual:TNAME2])
    self.title = NSLocalizedString(@"Product lookup", nil);
    else self.title = NSLocalizedString(@"Advertising lookup", nil);
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
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLOR;
    self.searchController.searchBar.barTintColor = SEARCHBARTINTCOLOR;
    self.listTableView.contentInset = UIEdgeInsetsMake(EDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // self.navigationItem.titleView = self.searchController.searchBar;
    [self presentViewController:self.searchController animated:YES completion:nil];
    
    adproductArray = [[NSMutableArray alloc] init];
    
    if ([_formController isEqual:TNAME2]) {
     PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
     //[PFQuery clearAllCachedResults];
     [query3 selectKeys:@[@"ProductNo"]];
     [query3 selectKeys:@[@"Products"]];
     [query3 orderByDescending:@"Products"];
     [query3 whereKey:@"Active" containsString:@"Active"];
      query3.cachePolicy = kPFCACHEPOLICY;
     [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if (!error) {
             for (PFObject *object in objects) {
                 [adproductArray addObject:object];
                 [self.listTableView reloadData]; }
         } else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
     }];
    } else {  //leads
    PFQuery *query1 = [PFQuery queryWithClassName:@"Advertising"];
    query1.cachePolicy = kPFCACHEPOLICY;
    [query1 selectKeys:@[@"AdNo"]];
    [query1 selectKeys:@[@"Advertiser"]];
    [query1 orderByDescending:@"Advertiser"];
    [query1 whereKey:@"Active" containsString:@"Active"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adproductArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [adproductArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}
    
    filteredString= [[NSMutableArray alloc] initWithArray:adproductArray];
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
}

#pragma mark RefreshControl 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilltered)
        return filteredString.count;
    else
        return adproductArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    if (!isFilltered) {
        if ([_formController isEqual:TNAME2])
        adproductName = [[adproductArray objectAtIndex:indexPath.row] objectForKey:@"Products"];
        else
        adproductName = [[adproductArray objectAtIndex:indexPath.row] objectForKey:@"Advertiser"];
      } else
        if ([_formController isEqual:TNAME2])
        adproductName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Products"];
        else
        adproductName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Advertiser"];
    
    myCell.textLabel.text = adproductName;
    
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
        for(PFObject *str in adproductArray)
        {
            NSRange stringRange = [[str objectForKey:@"Products"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
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
        if ([_formController isEqual:TNAME2]) {
        [self.delegate productFromController:self.tpr22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"ProductNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"Products"]];
       } else {
        [self.delegate productFromController:self.tpr22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"AdNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"Advertiser"]]; }
       } else {
     if ([_formController isEqual:TNAME2]) {
        [self.delegate productFromController:self.tpr22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"ProductNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"Products"]];
       } else {
        [self.delegate productFromController:self.tpr22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"AdNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"Advertiser"]];
       }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        [adproductArray objectAtIndex:indexPath.row];
    else
        [filteredString objectAtIndex:indexPath.row];
    
    [self passDataBack];
}

@end
