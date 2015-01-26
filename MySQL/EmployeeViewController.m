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
    EmployeeModel *_EmployeeModel; NSMutableArray *_feedItems; EmployeeLocation *_selectedLocation; UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end

@implementation EmployeeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =  @"Employee";
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"name",@"city",@"phone",@"active"];
    self.definesPresentationContext = YES;
    
    _feedItems = [[NSMutableArray alloc] init]; _EmployeeModel = [[EmployeeModel alloc] init]; _EmployeeModel.delegate = self;
    [_EmployeeModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem,addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.tableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor grayColor];
    refreshControl.tintColor = [UIColor whiteColor];
    [refreshControl addTarget:self action:@selector(reloadDatas) forControlEvents:UIControlEventValueChanged];
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Refreshing"];
    //add date to refresh
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, refreshString.length)];
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
-(IBAction)newData:(id)sender{
    [self performSegueWithIdentifier:@"newEmplySegue"sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items
{   // This delegate method will get called when the items are finished downloading
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark Table Refresh Control
-(void)reloadDatas{
    [self.tableView reloadData];
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
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (!isFilltered)
        item = _feedItems[indexPath.row];
     else
        item = [filteredString objectAtIndex:indexPath.row];
    
    NSString *firstItem = item.first; NSString *lastnameItem = item.lastname;
    NSString *companyItem = item.company;
    
    if ( ( ![item.first isEqual:[NSNull null]] ) && ( [item.first length] != 0 ) )
           firstItem = item.first;
     else  firstItem = @"";
    
    if ( ( ![item.lastname isEqual:[NSNull null]] ) && ( [item.lastname length] != 0 ) )
           lastnameItem = item.lastname;
     else  lastnameItem = @"";
    
    if ( ( ![item.company isEqual:[NSNull null]] ) && ( [item.company length] != 0 ) )
           companyItem = item.company;
     else  companyItem = @"";
    
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
        [self.tableView reloadData];
    }
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
    NSString *newString = [NSString stringWithFormat:@"EMPLOY \n%lu", (unsigned long) _feedItems.count];
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
    separatorLineView.backgroundColor = [UIColor redColor];// you can also put image here
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
    separatorLineView2.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView2];
    
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
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
       [filteredString removeAllObjects];
       [filteredString addObjectsFromArray:_feedItems];
    } else {
        isFilltered = YES;
       [filteredString removeAllObjects];
        filteredString = [[NSMutableArray alloc]init];
        
        for(EmployeeLocation* string in _feedItems)
        {
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.lastname rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.homephone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 3)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
        }
    }
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   // Set selected location to var
    _selectedLocation = _feedItems[indexPath.row];
    
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
       detailVC.l1datetext = @"Email:";
       detailVC.lnewsTitle = @"Employee News Peter Balsamo Appointed to United's Board of Directors";
   }
    if ([[segue identifier] isEqualToString:@"newEmplySegue"])
    {
        NewDataViewController *detailVC = segue.destinationViewController;
        detailVC.formController = @"Employee";
    }
}

@end
