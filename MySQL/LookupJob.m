//
//  LookupJob.m
//  MySQL
//
//  Created by Peter Balsamo on 1/6/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "LookupJob.h"
#import <Parse/Parse.h>

@interface LookupJob ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *jobArray;
    NSString *jobName;
}
@property (strong, nonatomic) NSString *tjo22;
@property (strong, nonatomic) NSString *tjn22;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation LookupJob
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  @"Job lookup";
    self.listTableView.estimatedRowHeight = 64.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.listTableView.tableHeaderView = self.searchBar;
    self.definesPresentationContext = YES;
    
    jobArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"JobNo"]];
    [query selectKeys:@[@"Description"]];
    [query orderByDescending:@"Description"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [jobArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]); 
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:jobArray];
    
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
        return jobArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (!isFilltered)
        jobName = [[jobArray objectAtIndex:indexPath.row] objectForKey:@"Description"];
     else
        jobName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Description"];
    
    myCell.textLabel.text = jobName;
    
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
        for(PFObject *str in jobArray)
        {
    NSRange stringRange = [[str objectForKey:@"Description"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
    if(stringRange.location != NSNotFound) {
                [filteredString addObject:str]; }
    }
    }
    [self.listTableView reloadData];
}

- (void)passDataBack {
    
    NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
    if (!isFilltered) {
        [self.delegate jobFromController:self.tjo22 = [[jobArray objectAtIndex:indexPath.row]objectForKey:@"JobNo"]];
        [self.delegate jobNameFromController:self.tjn22 =[[jobArray objectAtIndex:indexPath.row]objectForKey:@"Description"]];
      } else {
        [self.delegate jobFromController:self.tjo22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"JobNo"]];
        [self.delegate jobNameFromController:self.tjn22 = [[filteredString objectAtIndex:indexPath.row]objectForKey:@"Description"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
