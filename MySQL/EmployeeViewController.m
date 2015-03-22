//
//  EmployeeViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "EmployeeViewController.h"
#import "EmployeeLocation.h"

@interface EmployeeViewController ()
{
    EmployeeModel *_EmployeeModel; NSMutableArray *_feedItems; EmployeeLocation *_selectedLocation;
    UIRefreshControl *refreshControl;
    NSString *firstItem, *lastnameItem, *companyItem;
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation EmployeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Employee", nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    
    _feedItems = [[NSMutableArray alloc] init]; _EmployeeModel = [[EmployeeModel alloc] init]; _EmployeeModel.delegate = self; [_EmployeeModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem,addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:KEY_DATEREFRESH];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
            forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle; }
    [refreshView addSubview:refreshControl];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - BarButton NewData
-(void)newData:(id)sender{
    [self performSegueWithIdentifier:@"newEmplySegue"sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items
{   // This delegate method will get called when the items are finished downloading
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
- (void)reloadDatas:(id)sender {
    [self.listTableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    if (isFilltered)
        return filteredString.count;
        else
        return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EmployeeLocation *item;
    static NSString *CellIdentifier = @"BasicCell";
    
    if (!isFilltered)
        item = _feedItems[indexPath.row];
        else
        item = [filteredString objectAtIndex:indexPath.row];
    
    if ((![item.first isEqual:[NSNull null]] ) && ( [item.first length] != 0 ))
         firstItem = item.first;
    else firstItem = @"";
    
    if ((![item.lastname isEqual:[NSNull null]] ) && ( [item.lastname length] != 0 ))
         lastnameItem = item.lastname;
    else lastnameItem = @"";
    
    if ((![item.company isEqual:[NSNull null]] ) && ( [item.company length] != 0 ))
         companyItem = item.company;
    else companyItem = @"";
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    myCell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",firstItem, lastnameItem, companyItem];
    myCell.detailTextLabel.text = item.city;
    
    //Retreive an image
    UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
    [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark TableView Delete
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
                                     alertControllerWithTitle:@"Delete the selected employee?"
                                     message:@"OK, delete it"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 EmployeeLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.employeeNo;
                                 NSString *_employeeNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:@"_employeeNo=%@&&", _employeeNo];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteEmployee.php"];
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

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!isFilltered)
        return HEADHEIGHT;
        else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"EMPLOY \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:HEADTITLE2];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:CELL_FONT(HEADFONTSIZE)];
    [label setTextColor:HEADCOLOR];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor redColor];// you can also put image here
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_FONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_FONT(HEADFONTSIZE)];
    [label2 setTextColor:HEADCOLOR];
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

#pragma mark - Search
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
    self.searchController.searchBar.scopeButtonTitles = @[@"name",@"city",@"phone",@"active"];
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
    {
        isFilltered = NO;
        [filteredString removeAllObjects];
        [filteredString addObjectsFromArray:_feedItems];
    } else {
        isFilltered = YES;
        [filteredString removeAllObjects];
        filteredString = [[NSMutableArray alloc]init];
        
        for(EmployeeLocation* string in _feedItems)
        {
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.lastname rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
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
                NSRange stringRange = [string.homephone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"employdetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:@"employdetailSegue"])
   {
       LeadDetailViewControler *detailVC = segue.destinationViewController;
       detailVC.formController = @"Employee";
    // detailVC.selectedLocation = _selectedLocation;
       if ( [_selectedLocation.first isEqual:[NSNull null]] ) { _selectedLocation.first = @""; }
       if ( [_selectedLocation.lastname isEqual:[NSNull null]] ) { _selectedLocation.lastname = @""; }
       if ( [_selectedLocation.company isEqual:[NSNull null]] ) { _selectedLocation.company = @""; }
       
       detailVC.leadNo = _selectedLocation.employeeNo;
       detailVC.date = _selectedLocation.email;
       detailVC.name = [NSString stringWithFormat:@"%@ %@ %@",_selectedLocation.first,_selectedLocation.lastname, _selectedLocation.company];
       detailVC.custNo = _selectedLocation.lastname;
       detailVC.address = _selectedLocation.street;
       detailVC.city = _selectedLocation.city;
       detailVC.state = _selectedLocation.state;
       detailVC.zip = _selectedLocation.zip;
       detailVC.amount = _selectedLocation.titleEmploy;
       detailVC.tbl11 = _selectedLocation.homephone;
       detailVC.tbl12 = _selectedLocation.workphone;
       detailVC.tbl13 = _selectedLocation.cellphone;
       detailVC.tbl14 = _selectedLocation.social;
       detailVC.tbl15 = _selectedLocation.middle;
       detailVC.tbl21 = _selectedLocation.email;
       detailVC.tbl22 = _selectedLocation.department;
       detailVC.tbl23 = _selectedLocation.titleEmploy;
       detailVC.tbl24 = _selectedLocation.manager;
       detailVC.tbl25 = _selectedLocation.country;
       detailVC.tbl16 = _selectedLocation.time; detailVC.tbl26 = _selectedLocation.email;
       detailVC.comments = _selectedLocation.comments;
       detailVC.active = _selectedLocation.active;
       
       detailVC.salesman = _selectedLocation.first;
       detailVC.jobdescription = _selectedLocation.middle;
       detailVC.advertiser = _selectedLocation.company;
       
       detailVC.l11 = @"Home Phone"; detailVC.l12 = @"Work phone";
       detailVC.l13 = @"Mobile Phone"; detailVC.l14 = @"Social Security";
       detailVC.l15 = @"Middle Name"; detailVC.l21 = @"Email";
       detailVC.l22 = @"Department"; detailVC.l23 = @"Title";
       detailVC.l24 = @"Manager"; detailVC.l25 = @"Country";
       detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Email";
       detailVC.l1datetext = @"Email:";
       detailVC.lnewsTitle = @"Employee News Peter Balsamo Appointed to United's Board of Directors";
   }
    if ([[segue identifier] isEqualToString:@"newEmplySegue"])
    {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = @"Employee";
    }
}

@end
