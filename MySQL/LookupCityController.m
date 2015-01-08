//
//  LookupCityController.m
//  MySQL
//
//  Created by Peter Balsamo on 1/7/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "LookupCityController.h"
#import <Parse/Parse.h>

@interface LookupCityController ()
{
UIRefreshControl *refreshControl;
 NSMutableArray *zipArray;
     NSString *cityName;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LookupCityController
@synthesize searchBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  @"City lookup";
    self.listTableView.estimatedRowHeight = 64.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
   // self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
   // self.searchBar.showsScopeBar = YES;
   // self.searchBar.scopeButtonTitles = @[@"subject", @"date", @"rating", @"postby"];
    self.definesPresentationContext = YES;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    zipArray = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"ZipNo"]];
    [query selectKeys:@[@"City"]];
    [query selectKeys:@[@"State"]];
    [query selectKeys:@[@"Zip"]];
    //[query orderByDescending:@"City"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *object in objects) {
            [zipArray addObject:[object objectForKey:@"City"]];
        }
        [self.listTableView reloadData];
    }];
    
    filteredString= [[NSMutableArray alloc] initWithArray:zipArray];
    
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
   
    
    if (!isFilltered) {
        cityName = [zipArray objectAtIndex:indexPath.row];
    } else {
        cityName = [filteredString objectAtIndex:indexPath.row];
    }
    
  myCell.textLabel.text = cityName;
    myCell.detailTextLabel.text = nil;//item.city;
 //   UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
 //   [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark - Search
- (void)searchButton:(id)sender{
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

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
        for(NSString *str in zipArray)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound) {
                [filteredString addObject:str];
            }
        }
    }
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        cityName = [zipArray objectAtIndex:indexPath.row];
    //_selectedLocation = _feedItems[indexPath.row];
    else
        cityName = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"cityreturnSegue" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"cityreturnSegue"])
    {
        // Get reference to the destination view controller
    //    NewDataViewController *detailVC = segue.destinationViewController;
        // detailVC.selectedLocation = _selectedLocation;
       // detailVC.city = [cityName objectForKey:@"City"]
       // detailVC.state = [object objectForKey:@"State"]
      //  detailVC.zip = [object objectForKey:@"Zip"]
  
      
    }
}

@end
