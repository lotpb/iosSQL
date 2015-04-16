//
//  EmployeeViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "EmployeeViewController.h"

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
     self.title = NSLocalizedString(TNAME4, nil);
     self.edgesForExtendedLayout = UIRectEdgeNone; //fix
     self.listTableView.delegate = self;
     self.listTableView.dataSource = self;
     self.listTableView.backgroundColor = BACKGROUNDCOLOR;
    
    _feedItems = [[NSMutableArray alloc] init]; _EmployeeModel = [[EmployeeModel alloc] init];
    _EmployeeModel.delegate = self; [_EmployeeModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData:)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem,addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; 
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    
    [refreshView addSubview:refreshControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    [_EmployeeModel downloadItems];
    [self.listTableView reloadData];
    
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:KEY_DATEREFRESH];
        NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;
        
        [refreshControl endRefreshing];
    }
}

#pragma mark - BarButton NewData
-(void)newData:(id)sender {
    [self performSegueWithIdentifier:EMPLOYNEWSEGUE sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {   // This delegate method will get called when the items are finished downloading
    _feedItems = items;
    [self.listTableView reloadData];
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
    static NSString *CellIdentifier = IDCELL;
    
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
    UIImage *myImage = [UIImage imageNamed:TABLECELLIMAGE];
    [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark TableView Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.listTableView setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:DELMESSAGE1
                                     message:DELMESSAGE2
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
                                 NSString *rawStr = [NSString stringWithFormat:EMPLOYDELETENO, EMPLOYDELETENO1];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:EMPLOYEEDELETEURL];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE1)];
    [label setFont:CELL_FONT(HEADFONTSIZE)];
    [label setTextColor:HEADTEXTCOLOR];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE1)];
    separatorLineView.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE2)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_FONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADTEXTCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE2)];
    separatorLineView1.backgroundColor = LINECOLOR2;
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE3)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_FONT(HEADFONTSIZE)];
    [label2 setTextColor:HEADTEXTCOLOR];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE3)];
    separatorLineView2.backgroundColor = LINECOLOR3;
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
    self.searchController.hidesNavigationBarDuringPresentation = SHIDE;
    self.searchController.dimsBackgroundDuringPresentation = SDIM;
    self.definesPresentationContext = SDEFINE;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLOR;
    self.searchController.searchBar.barTintColor = SEARCHBARTINTCOLOR;
    self.searchController.searchBar.scopeButtonTitles = @[EMPLOYSCOPE];
    self.searchController.hidesBottomBarWhenPushed = SHIDEBAR;
    self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
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
    
    [self performSegueWithIdentifier:EMPLOYVIEWSEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   if ([[segue identifier] isEqualToString:EMPLOYVIEWSEGUE])
   {
       LeadDetailViewControler *detailVC = segue.destinationViewController;
       detailVC.formController = TNAME4;
    // detailVC.selectedLocation = _selectedLocation;
       if ( [_selectedLocation.first isEqual:[NSNull null]] ) { _selectedLocation.first = @""; }
       if ( [_selectedLocation.lastname isEqual:[NSNull null]] ) { _selectedLocation.lastname = @""; }
       if ( [_selectedLocation.company isEqual:[NSNull null]] ) { _selectedLocation.company = @""; }
       
       detailVC.leadNo = _selectedLocation.employeeNo;
       detailVC.date = _selectedLocation.email;
      // detailVC.first = _selectedLocation.email;
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
       detailVC.tbl16 = _selectedLocation.time;
       detailVC.tbl26 = _selectedLocation.first;
       detailVC.tbl27 = _selectedLocation.company;
       //detailVC.tbl28 = _selectedLocation.company;
       detailVC.comments = _selectedLocation.comments;
       detailVC.active = _selectedLocation.active;
       
       detailVC.l11 = @"Home Phone"; detailVC.l12 = @"Work phone";
       detailVC.l13 = @"Mobile Phone"; detailVC.l14 = @"Social Security";
       detailVC.l15 = @"Middle Name"; detailVC.l21 = @"Email";
       detailVC.l22 = @"Department"; detailVC.l23 = @"Title";
       detailVC.l24 = @"Manager"; detailVC.l25 = @"Country";
       detailVC.l16 = @"Last Updated"; detailVC.l26 = @"First";
       detailVC.l1datetext = @"Email:";
       detailVC.lnewsTitle = EMPLOYEENEWSTITLE;
   }
    if ([[segue identifier] isEqualToString:EMPLOYNEWSEGUE])
    {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME4;
    }
}

@end
