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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LookupCity
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  @"City lookup";
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.searchBar.delegate = self;
   [self.searchBar becomeFirstResponder];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.listTableView.tableHeaderView = self.searchBar;
    self.definesPresentationContext = YES;
    
    zipArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"ZipNo"]];
    [query selectKeys:@[@"City"]];
    [query selectKeys:@[@"State"]];
    [query selectKeys:@[@"zipCode"]];
    [query orderByAscending:@"City"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [zipArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:zipArray];
    
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

     self.searchBar.clipsToBounds = YES;
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
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
 
    }
} */

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
- (void)searchButton:(id)sender{
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     self.searchBar.text=@"";
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
        isFilltered = NO;
     else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(PFObject *str in zipArray)
        {
        NSRange stringRange = [[str objectForKey:@"City"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(stringRange.location != NSNotFound) {
        [filteredString addObject:str]; }
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
