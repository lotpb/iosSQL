//
//  ViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "ViewController.h"
#import "Location.h"

@interface ViewController ()
{
    NSMutableArray *adArray, *salesArray, *jobArray;
    HomeModel *_homeModel; NSMutableArray *_feedItems; Location *_selectedLocation;
    UIRefreshControl *refreshControl;
}
@property (strong, nonatomic) NSString *tsa22;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =  @"Leads";
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Advertising"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query1 selectKeys:@[@"AdNo"]];
    [query1 selectKeys:@[@"Advertiser"]];
    [query1 orderByDescending:@"Advertiser"];
    [query1 whereKey:@"Active" containsString:@"Active"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [adArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
 
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
   // [query1 whereKey:@"SalesNo" containsString:_selectedLocation.salesNo];
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"Salesman"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [salesArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Job"];
    query2.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query2 selectKeys:@[@"JobNo"]];
    [query2 selectKeys:@[@"Description"]];
    [query2 orderByDescending:@"Description"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        jobArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [jobArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];

    _feedItems = [[NSMutableArray alloc] init]; _homeModel = [[HomeModel alloc] init]; _homeModel.delegate = self; [_homeModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] init];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem,addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh

    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor blackColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Refreshing"];
    
    //add date to refresh
    static NSDateFormatter *formatter = nil;
    if (formatter == nil)
    { NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [ formatter setDateFormat:KEY_DATEREFRESH];
      NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
      refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    }

    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
        [refreshView addSubview:refreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  [self.searchBar resignFirstResponder];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButton NewData
-(IBAction)newData:(id)sender{
    [self performSegueWithIdentifier:@"newLeadSeque"sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    // Set the downloaded items to the array
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
-(void)reloadDatas {
    [self.listTableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark TableView Delete Button
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    [self.listTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Delete the selected lead?"
                                     message:@"OK, delete it"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 Location *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.leadNo;
                                 NSString *_leadNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:@"_leadNo=%@&&", _leadNo];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteLeads.php"];
                                 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                                 
                                 [request setHTTPMethod:@"POST"];
                                 [request setHTTPBody:data];
                                 NSURLResponse *response;
                                 NSError *err;
                                 NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
                                 NSString *responseString = [NSString stringWithUTF8String:[responseData bytes]];
                                 NSLog(@"%@", responseString);
                                 NSString *success = @"success";
                                 [success dataUsingEncoding:NSUTF8StringEncoding];
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                 [self.navigationController popViewControllerAnimated:YES]; // Dismiss the viewController upon success
                                 //Do some thing here
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        [view addAction:ok];
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        [self.listTableView reloadData];
    }
}

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFilltered)
    return filteredString.count;
    else
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BasicCell";
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -90, 0, 75, 27)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    Location *item;
    if (!isFilltered)
        item = _feedItems[indexPath.row];
        else
        item = [filteredString objectAtIndex:indexPath.row];

    [myCell.detailTextLabel setTextColor:[UIColor grayColor]];

    myCell.textLabel.text = item.name;
    myCell.detailTextLabel.text = item.city;
  //  UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
   // [myCell.imageView setImage:myImage];
      //problem below with iphone 5 width

    label2.text=  item.date;
    [label2 setFont:CELL_BOLDFONT(CELL_FONTSIZE - 2)];//[UIFont boldSystemFontOfSize:12.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:[UIColor whiteColor]];
    [label2 setBackgroundColor:[UIColor redColor]];
     label2.tag = 103;
    [myCell.contentView addSubview:label2];
    
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return 55.0;
    else
       return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"LEADS \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n4,727.35"];
    NSString *newString2 = [NSString stringWithFormat:@"DOW \n17,776.80"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
     label.numberOfLines = 0;
     NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:[UIFont systemFontOfSize:12]];
    [label1 setTextColor:[UIColor whiteColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 45, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
   [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.barStyle = UIBarStyleBlack;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    self.searchController.searchBar.scopeButtonTitles = @[@"name",@"city",@"phone",@"date",@"active"];
    self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.edgesForExtendedLayout = UIRectEdgeNone;
   [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        return;
    }
    
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length == 0)
        
        isFilltered = NO;
    else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        
        for(Location* string in _feedItems)
        {
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.name rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.phone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.date rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 4)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
        }
    }
   [self.listTableView reloadData];  
}

- (void)passDataBack {
 /*
    PFQuery *query31 = [PFQuery queryWithClassName:@"Salesman"];
    //query31.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query31 whereKey:@"SalesNo" equalTo:_selectedLocation.salesNo];
    [query31 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            self.tsa22 = [object objectForKey:@"Salesman"];
            NSLog(@"rawStr is %@",self.tsa22); }
    }];
 
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //[query whereKey:@"SalesNo" equalTo:_selectedLocation.salesNo];
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    
    [query orderByDescending:@"SalesNo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
         [self.listTableView reloadData];
         NSLog(@"rawStr is %@",salesArray);
        
    }];
    
     NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
      PFObject * postObject = [salesArray objectAtIndex:indexPath.row];
    [postObject fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        PFObject *postAuthor = [object objectForKey:@"SalesNo"];
    self.tsa22 =  [postAuthor objectForKey:@"Salesman"];
    NSLog(@"Peter is %@",self.tsa22);
    }]; */
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
       [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailSegue"])
    {
        NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
           //  [self passDataBack];
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        detailVC.formController = @"Leads";
        detailVC.leadNo = _selectedLocation.leadNo; detailVC.date = _selectedLocation.date;
        detailVC.name = _selectedLocation.name; detailVC.address = _selectedLocation.address;
        detailVC.city = _selectedLocation.city; detailVC.state = _selectedLocation.state;
        detailVC.zip = _selectedLocation.zip; detailVC.amount = _selectedLocation.amount;
        detailVC.tbl11 = _selectedLocation.callback; detailVC.tbl12 = _selectedLocation.phone;
        detailVC.tbl13 = _selectedLocation.first; detailVC.tbl14 = _selectedLocation.spouse;
        detailVC.tbl15 = _selectedLocation.email; detailVC.tbl21 = _selectedLocation.aptdate;
        detailVC.tbl22 = _selectedLocation.salesNo; detailVC.tbl23 = _selectedLocation.jobNo;
        detailVC.tbl24 = _selectedLocation.adNo; detailVC.tbl25 = _selectedLocation.active;
        detailVC.tbl16 = _selectedLocation.time; detailVC.tbl26 = _selectedLocation.photo;
         
        detailVC.salesman = [[salesArray objectAtIndex:indexPath.row]objectForKey:@"Salesman"];
        detailVC.jobdescription = [[jobArray objectAtIndex:indexPath.row]objectForKey:@"Description"];
        detailVC.advertiser = [[adArray objectAtIndex:indexPath.row]objectForKey:@"Advertiser"];
        
        detailVC.photo = _selectedLocation.photo;
        detailVC.comments = _selectedLocation.comments;
        detailVC.active = _selectedLocation.active;
        
        detailVC.l11 = @"Call Back"; detailVC.l12 = @"Phone";
        detailVC.l13 = @"First"; detailVC.l14 = @"Spouse";
        detailVC.l15 = @"Email"; detailVC.l21 = @"Apt Date";
        detailVC.l22 = @"Salesman"; detailVC.l23 = @"Job";
        detailVC.l24 = @"Advertiser"; detailVC.l25 = @"Active";
        detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Photo";
        detailVC.l1datetext = @"Lead Date:";
        detailVC.lnewsTitle = @"Customer News Peter Balsamo Appointed to United's Board of Directors";
    }
    if ([[segue identifier] isEqualToString:@"newLeadSeque"]) {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = @"Leads"; }
}

@end
