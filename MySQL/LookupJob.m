//
//  LookupJob.m
//  MySQL
//
//  Created by Peter Balsamo on 1/6/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "LookupJob.h"

@interface LookupJob ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *jobArray;
    NSString *jobName;
}
@property (strong, nonatomic) NSString *tjo22;
@property (strong, nonatomic) NSString *tjn22;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LookupJob

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Job lookup", nil);
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
    
    ParseConnection *parseConnection = [[ParseConnection alloc]init];
    parseConnection.delegate = (id)self;
   [parseConnection parseLookupJob];
    
    filteredString = [[NSMutableArray alloc] initWithArray:jobArray];
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

#pragma mark - ParseDelegate
- (void)parseLookupJobloaded:(NSMutableArray *)jobItem {
    jobArray = jobItem;
}

#pragma mark - TableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFilltered)
        return filteredString.count;
        else
        return jobArray.count;
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
    
    if (!isFilltered)
        jobName = [[jobArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
        else
        jobName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Description"];
    
    myCell.textLabel.text = jobName;
    
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
        for(PFObject *str in jobArray)
        {
            NSRange stringRange = [[str objectForKey:@"Description"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
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
        [self.delegate jobFromController:self.tjo22 = [[jobArray objectAtIndex:indexPath.row]objectForKey:@"JobNo"]];
        [self.delegate jobNameFromController:self.tjn22 =[[jobArray objectAtIndex:indexPath.row]objectForKey:@"Description"]];
      } else {
        [self.delegate jobFromController:self.tjo22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"JobNo"]];
        [self.delegate jobNameFromController:self.tjn22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"Description"]];
    }
    GOBACK;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
    [jobArray objectAtIndex:indexPath.row];
    else
    [filteredString objectAtIndex:indexPath.row];
    
    [self passDataBack];
}

@end
