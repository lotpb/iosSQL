//
//  LookupProduct.m
//  MySQL
//
//  Created by Peter Balsamo on 1/15/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
// this ViewController handles Products and Advertisers

#import "LookupProduct.h"

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
    else
        self.title = NSLocalizedString(@"Advertising lookup", nil);
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
    
    adproductArray = [[NSMutableArray alloc] init];
    filteredString= [[NSMutableArray alloc] initWithArray:adproductArray];
    
    ParseConnection *parseConnection = [[ParseConnection alloc]init];
    parseConnection.delegate = (id)self;
    //[parseConnection parseLookupProduct];
    
    if ([_formController isEqual:TNAME2]) {
        [parseConnection parseLookupProduct];
    } else {
        [parseConnection parseLookupAd];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    [self.searchController.searchBar becomeFirstResponder];
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ParseDelegate
- (void)parseLookupProductloaded:(NSMutableArray *)prodItem {
    adproductArray = prodItem;
}

- (void)parseLookupAdloaded:(NSMutableArray *)adItem {
    adproductArray = adItem;
}

#pragma mark - Tableview
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_FONT(IPADFONT20)];
    } else {
        [myCell.textLabel setFont:CELL_FONT(IPHONEFONT18)];
    }

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
            NSRange stringRange;
            if ([_formController isEqual:TNAME2]) {
            stringRange = [[str objectForKey:@"Products"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            } else {
            stringRange = [[str objectForKey:@"Advertiser"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            }
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
    GOBACK;
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
