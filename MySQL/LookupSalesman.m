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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LookupSalesman
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  @"Salesman lookup";
    self.listTableView.estimatedRowHeight = 64.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.searchBar;
    self.definesPresentationContext = YES;
    
    salesArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"Salesman"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [salesArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:salesArray];
    
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.searchBar.clipsToBounds = YES;
    [self.searchBar becomeFirstResponder];
    //self.navigationController.navigationBar.translucent = YES;
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
        return salesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
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
- (void)searchButton:(id)sender{
    
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
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
        for(PFObject *str in salesArray)
        {
            NSRange stringRange = [[str objectForKey:@"Salesman"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound) {
                [filteredString addObject:str]; }
        }
    }
    [self.tableView reloadData];
}

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
