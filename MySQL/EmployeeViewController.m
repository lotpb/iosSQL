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
    EmployeeModel *_EmployeeModel; EmployeeLocation *_selectedLocation;
    NSMutableArray *headCount, *_feedItems;
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
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseEmployee]; [parseConnection parseHeadEmployee];
    } else {
        _EmployeeModel = [[EmployeeModel alloc] init];
        _EmployeeModel.delegate = self; [_EmployeeModel downloadItems];
    }
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.listTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
   //self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    //[self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseEmployee]; [parseConnection parseHeadEmployee];
    } else {
        [_EmployeeModel downloadItems];
    }
    [self.listTableView reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:KEY_DATEREFRESH];
            NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }
        
        [refreshControl endRefreshing];
    }
}

#pragma mark - BarButton New
-(void)newData:(id)sender {
    [self performSegueWithIdentifier:EMPLOYNEWSEGUE sender:self];
}

#pragma mark - ParseDelegate
- (void)parseEmployeeloaded:(NSMutableArray *)employItem {
    _feedItems = employItem;
    [self.listTableView reloadData];
}

- (void)parseHeadEmployeeloaded:(NSMutableArray *)employheadItem {
    headCount = employheadItem;
    [self.listTableView reloadData];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
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
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_FONT(IPADFONT20)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT14)];
    } else {
        [myCell.textLabel setFont:CELL_FONT(IPHONEFONT20)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPHONEFONT14)];
    }
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -65, 0, 50, 27)];
    [label2 setFont:CELL_MEDFONT(IPHONEFONT16 - 2)];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:DATECOLORTEXT];
    [label2 setBackgroundColor:NUMCOLORBACK];
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.accessoryType = UITableViewCellAccessoryNone;
    [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        if (!isFilltered) {
            if ((![[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"] isEqual:[NSNull null]] ) && ( [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"] length] != 0 ))
                firstItem = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"];
            else firstItem = @"";
            
            if ((![[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Last"] isEqual:[NSNull null]] ) && ( [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Last"] length] != 0 ))
                lastnameItem = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Last"];
            else lastnameItem = @"";
            
            if ((![[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Company"] isEqual:[NSNull null]] ) && ( [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Company"] length] != 0 ))
                companyItem = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Company"];
            else companyItem = @"";
            
            myCell.detailTextLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
            label2.text = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"EmployeeNo"]stringValue];
        } else {
            if ((![[[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"] isEqual:[NSNull null]] ) && ( [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"] length] != 0 ))
                firstItem = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"];
            else firstItem = @"";
            
            if ((![[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Last"] isEqual:[NSNull null]] ) && ( [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Last"] length] != 0 ))
                lastnameItem = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Last"];
            else lastnameItem = @"";
            
            if ((![[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Company"] isEqual:[NSNull null]] ) && ( [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Company"] length] != 0 ))
                companyItem = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Company"];
            else companyItem = @"";
            
            myCell.detailTextLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
            label2.text = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"EmployeeNo"]stringValue];
        }
    } else {
        EmployeeLocation *item;
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
        
        myCell.detailTextLabel.text = item.city;
        label2.text = item.employeeNo;
    }
    myCell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",firstItem, lastnameItem, companyItem];
    
    UIImage *myImage = [UIImage imageNamed:TABLECELLIMAGE];
    [myCell.imageView setImage:myImage];
    
    label2.tag = 103;
    [myCell.contentView addSubview:label2];
    
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
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
                                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                                     PFQuery *query = [PFQuery queryWithClassName:@"Employee"];
                                     [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId] ];
                                     [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (!error) {
                                             for (PFObject *object in objects) {
                                                 [object deleteInBackground];
                                             }
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                 } else {
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
                                 }
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                // GOBACK; // Dismiss the viewController upon success
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
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            view.popoverPresentationController.sourceView = self.view;
            view.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
        }
        [self presentViewController:view animated:YES completion:nil];
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
    NSString *newString1 = [NSString stringWithFormat:@"ACTIVE \n%lu",(unsigned long) headCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE1)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE2)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE3)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [label setFont:CELL_FONT(IPADFONT16)];
        [label1 setFont:CELL_FONT(IPADFONT16)];
        [label2 setFont:CELL_FONT(IPADFONT16)];
    } else {
        [label setFont:CELL_FONT(IPHONEFONT14)];
        [label1 setFont:CELL_FONT(IPHONEFONT14)];
        [label2 setFont:CELL_FONT(IPHONEFONT14)];
    }
    
    label.numberOfLines = 0;
    [label setTextColor:HEADTEXTCOLOR];
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE1)];
    separatorLineView.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView];
    
    label1.numberOfLines = 0;
    [label1 setTextColor:HEADTEXTCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(LINESIZE2)];
    separatorLineView1.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView1];
    
    label2.numberOfLines = 0;
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
        for(PFObject *string in _feedItems)
        //for(EmployeeLocation* string in _feedItems)
        {
            NSRange stringRange;
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
            {
                stringRange = [[string objectForKey:@"Last"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.lastname rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
            {
                stringRange = [[string objectForKey:@"City"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
            {
                stringRange = [[string objectForKey:@"HomePhone"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.homephone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 3)
            {
                stringRange = [[string objectForKey:@"Active"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            if(stringRange.location != NSNotFound)
                [filteredString addObject:string];
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
        /*
         *******************************************************************************************
         Parse.com
         *******************************************************************************************
         */
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
             NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            if (!isFilltered) {
                detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                detailVC.leadNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"EmployeeNo"]stringValue];
                detailVC.date = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.name = [NSString stringWithFormat:@"%@ %@ %@",[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"],[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Last"], [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Company"]];
                detailVC.custNo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Last"];
                detailVC.address = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Street"];
                detailVC.city = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
                detailVC.state = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"State"];
                detailVC.zip = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Zip"];
                detailVC.amount = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Title"];
                detailVC.tbl11 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"HomePhone"];
                detailVC.tbl12 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"WorkPhone"];
                detailVC.tbl13 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CellPhone"];
                detailVC.tbl14 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"SS"];
                detailVC.tbl15 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Middle"];
                detailVC.tbl21 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.tbl22 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Department"];
                detailVC.tbl23 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Title"];
                detailVC.tbl24 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Manager"];
                detailVC.tbl25 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Country"];
                detailVC.tbl16 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Time"];
                detailVC.tbl26 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"];
                detailVC.tbl27 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Company"];
                detailVC.comments = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Comments"];
                detailVC.active = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            } else {
                detailVC.objectId = [[filteredString objectAtIndex:indexPath.row] objectId];
                detailVC.leadNo = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"EmployeeNo"]stringValue];
                detailVC.date = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.name = [NSString stringWithFormat:@"%@ %@ %@",[[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"],[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Last"], [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Company"]];
                detailVC.custNo = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Last"];
                detailVC.address = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Street"];
                detailVC.city = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
                detailVC.state = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"State"];
                detailVC.zip = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Zip"];
                detailVC.amount = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Title"];
                detailVC.tbl11 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"HomePhone"];
                detailVC.tbl12 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"WorkPhone"];
                detailVC.tbl13 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"CellPhone"];
                detailVC.tbl14 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"SS"];
                detailVC.tbl15 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Middle"];
                detailVC.tbl21 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.tbl22 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Department"];
                detailVC.tbl23 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Title"];
                detailVC.tbl24 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Manager"];
                detailVC.tbl25 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Country"];
                detailVC.tbl16 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Time"];
                detailVC.tbl26 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"];
                detailVC.tbl27 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Company"];
                detailVC.comments = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Comments"];
                detailVC.active = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            }
        } else {
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
            detailVC.tbl16 = _selectedLocation.time;
            detailVC.tbl26 = _selectedLocation.first;
            detailVC.tbl27 = _selectedLocation.company;
            detailVC.comments = _selectedLocation.comments;
            detailVC.active = _selectedLocation.active;
        }
        
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
