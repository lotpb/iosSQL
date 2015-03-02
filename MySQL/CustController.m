//
//  CustController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/1/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "CustController.h"
#import "CustLocation.h"

@interface CustController ()
{
    NSMutableArray *salesArray, *jobArray, *prodArray;
    CustModel *_CustModel; NSMutableArray *_feedItems; CustLocation *_selectedLocation; UIRefreshControl *refreshControl;
}
//@property (nonatomic, weak) IBOutlet UIStepper *defaultStepper;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation CustController

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.title =  @"Customer";
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"name",@"city",@"phone",@"date", @"active"];
    self.definesPresentationContext = YES;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Product"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query1 selectKeys:@[@"ProductNo"]];
    [query1 selectKeys:@[@"Products"]];
    [query1 orderByDescending:@"Products"];
    //[query1 whereKey:@"Active" containsString:@"Active"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        prodArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [prodArray addObject:object];
                [self.listTableView reloadData]; }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
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
    
    _feedItems = [[NSMutableArray alloc] init]; _CustModel = [[CustModel alloc] init]; _CustModel.delegate = self; [_CustModel downloadItems];
    
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:KEY_DATEREFRESH];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
    [refreshView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButton NewData
-(IBAction)newData:(id)sender{
    [self performSegueWithIdentifier:@"newCustSeque"sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items{
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
-(void)reloadDatas{
     [self.listTableView reloadData];
     [refreshControl endRefreshing];
}

#pragma mark TableView Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing
           animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    [self.listTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Delete the selected customer?"
                                     message:@"OK, delete it"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 CustLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.custNo;
                                 NSString *_custNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:@"_custNo=%@&&", _custNo];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteCustomer.php"];
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

#pragma mark TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isFilltered)
        return filteredString.count;
    else
        return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -90, 0, 75, 27)];
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    CustLocation *item;
    if (!isFilltered)
        item = _feedItems[indexPath.row];
        else
        item = [filteredString objectAtIndex:indexPath.row];
    
       [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
    
        myCell.textLabel.text = item.lastname;
        myCell.detailTextLabel.text = item.city;
      //  UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
      // [myCell.imageView setImage:myImage];

    label2.text=  item.date;
    [label2 setFont:CELL_BOLDFONT(CELL_FONTSIZE - 2)]; //[UIFont boldSystemFontOfSize:12.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:[UIColor whiteColor]];
    [label2 setBackgroundColor:[UIColor redColor]];
    label2.tag = 103;
    [myCell.contentView addSubview:label2];

    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!isFilltered)
        return 55.0;
    else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"CUST \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n4,727.35"];
    NSString *newString2 = [NSString stringWithFormat:@"DOW \n17,776.80"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:[UIFont systemFontOfSize:12]];
    [label1 setTextColor:[UIColor whiteColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:[UIFont systemFontOfSize:12]];
    [label2 setTextColor:[UIColor whiteColor]];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 45, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

#pragma mark - SearchBar
- (void)searchButton:(id)sender {
    
     self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
     self.searchBar.text=@"";
     self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isFilltered = NO;
    } else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        
        for(CustLocation* string in _feedItems)
        {
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.lastname rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.phone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.date rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 4)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
        }
    }
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{     if (!isFilltered)
     _selectedLocation = _feedItems[indexPath.row];
      else
     _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detailCustSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"detailCustSegue"])
    {
        NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        detailVC.formController = @"Customer";
        detailVC.custNo = _selectedLocation.custNo;
        detailVC.leadNo = _selectedLocation.leadNo;
        detailVC.date = _selectedLocation.date;
        detailVC.name = _selectedLocation.lastname;
        detailVC.address = _selectedLocation.address;
        detailVC.city = _selectedLocation.city;
        detailVC.state = _selectedLocation.state;
        detailVC.zip = _selectedLocation.zip;
        detailVC.amount = _selectedLocation.amount;
        detailVC.tbl11 = _selectedLocation.contractor;
        detailVC.tbl12 = _selectedLocation.phone;
        detailVC.tbl13 = _selectedLocation.first;
        detailVC.tbl14 = _selectedLocation.spouse;
        detailVC.tbl15 = _selectedLocation.email;
        detailVC.tbl21 = _selectedLocation.start;
        detailVC.tbl22 = _selectedLocation.salesNo;
        detailVC.tbl23 = _selectedLocation.jobNo;
        detailVC.tbl24 = _selectedLocation.prodNo;
        detailVC.tbl25 = _selectedLocation.quan;
        detailVC.tbl16 = _selectedLocation.time;
        detailVC.tbl26 = _selectedLocation.rate;
        
        detailVC.salesman = [[salesArray objectAtIndex:indexPath.row]objectForKey:@"Salesman"];
        detailVC.jobdescription = [[jobArray objectAtIndex:indexPath.row]objectForKey:@"Description"];
        detailVC.advertiser = [[prodArray objectAtIndex:indexPath.row]objectForKey:@"Products"];
        
        detailVC.complete = _selectedLocation.completion;
        detailVC.photo = _selectedLocation.photo;
        detailVC.comments = _selectedLocation.comments;
        detailVC.active = _selectedLocation.active;
        //photo1, photo2
     
        detailVC.l11 = @"Contractor"; detailVC.l12 = @"Phone";
        detailVC.l13 = @"First"; detailVC.l14 = @"Spouse";
        detailVC.l15 = @"Email"; detailVC.l21 = @"Start date";
        detailVC.l22 = @"Salesman"; detailVC.l23 = @"Job";
        detailVC.l24 = @"Product"; detailVC.l25 = @"Quan";
        detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Rate";
        detailVC.l1datetext = @"Sale Date:";
        detailVC.lnewsTitle = @"Customer News Peter Balsamo Appointed to United's Board of Directors";
    }
       if ([[segue identifier] isEqualToString:@"newCustSeque"])
       {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = @"Customer";
       }
}

@end
