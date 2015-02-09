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
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation LookupProduct
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([_formController isEqual: @"Customer"])
    self.title =  @"Product lookup";
    else self.title =  @"Advertising lookup"; 
    self.listTableView.estimatedRowHeight = 64.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
   [self.searchBar becomeFirstResponder];
    self.searchBar.barTintColor = [UIColor clearColor];
    self.listTableView.tableHeaderView = self.searchBar;
    self.definesPresentationContext = YES;
    
    adproductArray = [[NSMutableArray alloc] init];
    
    if ([_formController isEqual: @"Customer"]) {
     PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
      query3.cachePolicy = kPFCachePolicyCacheThenNetwork;
     [query3 selectKeys:@[@"ProductNo"]];
     [query3 selectKeys:@[@"Products"]];
     [query3 orderByDescending:@"Products"];
     [query3 whereKey:@"Active" containsString:@"Active"];
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
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
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
    }]; }
    
    filteredString= [[NSMutableArray alloc] initWithArray:adproductArray];
    
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
        return adproductArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    if (!isFilltered) {
        if ([_formController isEqual: @"Customer"])
        adproductName = [[adproductArray objectAtIndex:indexPath.row] objectForKey:@"Products"];
        else
        adproductName = [[adproductArray objectAtIndex:indexPath.row] objectForKey:@"Advertiser"];
      } else
        if ([_formController isEqual: @"Customer"])
        adproductName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Products"];
        else
        adproductName = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Advertiser"];
    
    myCell.textLabel.text = adproductName;
    
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
        for(PFObject *str in adproductArray)
        {
        NSRange stringRange = [[str objectForKey:@"Products"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if(stringRange.location != NSNotFound) {
          [filteredString addObject:str]; }
        }
    }
    [self.listTableView reloadData];
}

- (void)passDataBack {
    
    NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
    if (!isFilltered) {
        if ([_formController isEqual: @"Customer"]) {
        [self.delegate productFromController:self.tpr22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"ProductNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"Products"]];
       } else {
        [self.delegate productFromController:self.tpr22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"AdNo"]];
        [self.delegate productNameFromController:self.tpn22 = [[adproductArray objectAtIndex:indexPath.row]objectForKey:@"Advertiser"]]; }
       } else {
     if ([_formController isEqual: @"Customer"]) {
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
