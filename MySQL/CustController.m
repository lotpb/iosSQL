//
//  CustController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/1/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "CustController.h"

@interface CustController ()
{
    CustModel *_CustModel; CustLocation *_selectedLocation;
    NSMutableArray * headCount, *_feedItems;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation CustController

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.title = NSLocalizedString(TNAME2, nil);
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
       [parseConnection parseCustomer]; [parseConnection parseHeadCustomer];
    } else {
         _CustModel = [[CustModel alloc] init]; _CustModel.delegate = self;
        [_CustModel downloadItems];
    }
     //_feedItems = [[NSMutableArray alloc] init];
     filteredString= [[NSMutableArray alloc] init];
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
  //self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
   [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseCustomer]; //[parseConnection parseHeadCustomer];
    } else {
        [_CustModel downloadItems];
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
    [self performSegueWithIdentifier:CUSTNEWSEGUE sender:self];
}

#pragma mark - ParseDelegate
- (void)parseCustomerloaded:(NSMutableArray *)custItem {
    _feedItems = custItem;
    [self.listTableView reloadData];
}

- (void)parseHeadCustomerloaded:(NSMutableArray *)custheadItem {
    headCount = custheadItem;
    [self.listTableView reloadData];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark TableView Delete
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
                                     PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
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
                                 CustLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.custNo;
                                 NSString *_custNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:CUSTDELETENO, CUSTDELETENO1];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:CUSTDELETEURL];
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

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFilltered)
        return filteredString.count;
    else
        return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -95, 23, 95, 27)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -95, 0, 95, 27)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_FONT(IPADFONT20)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT16)];
    } else {
        [myCell.textLabel setFont:CELL_FONT(IPHONEFONT20)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPHONEFONT16)];
    }
    
    [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
    [label1 setFont:CELL_FONT(IPHONEFONT16)];
    [label2 setFont:CELL_MEDFONT(IPHONEFONT16)];
    label1.textAlignment = NSTextAlignmentCenter;
    label2.textAlignment = NSTextAlignmentCenter;
    [label1 setTextColor:[UIColor blackColor]];
    [label2 setTextColor:DATECOLORTEXT];
    [label1 setBackgroundColor:[UIColor whiteColor]];
    [label2 setBackgroundColor:DATECOLORBACK];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString;
        
        if (!isFilltered) {
            numberAsString = [numberFormatter stringFromNumber:[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
            myCell.textLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            myCell.detailTextLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
            label1.text = numberAsString;
            label2.text=  [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];
        } else {
            numberAsString = [numberFormatter stringFromNumber:[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
            myCell.textLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"LastName"];
            myCell.detailTextLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
            label1.text = numberAsString;
            label2.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Date"];
        }
    } else {
        CustLocation *item;
        if (!isFilltered)
            item = _feedItems[indexPath.row];
        else
            item = [filteredString objectAtIndex:indexPath.row];
        
        myCell.textLabel.text = item.lastname;
        myCell.detailTextLabel.text = item.city;
        label1.text = [NSString stringWithFormat:@"$%@",item.amount];
        label2.text = item.date;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIImage *myImage = [UIImage imageNamed:TABLECELLIMAGE];
        [myCell.imageView setImage:myImage];
    }
    
    label1.tag = 102;
    [myCell.contentView addSubview:label1];
    
    label2.tag = 103;
    [myCell.contentView addSubview:label2];
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myCell;
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
    NSString *newString = [NSString stringWithFormat:@"CUST \n%lu", (unsigned long) _feedItems.count];
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

#pragma mark - SearchBar
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
    self.searchController.searchBar.scopeButtonTitles = @[CUSTSCOPE];
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
        isFilltered = NO;
        else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(PFObject *string in _feedItems)
      //for(CustLocation* string in _feedItems)
        {
            NSRange stringRange;
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0) {
                stringRange = [[string objectForKey:@"LastName"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.lastname rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1) {
                stringRange = [[string objectForKey:@"City"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2) {
                stringRange = [[string objectForKey:@"Phone"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.phone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 3) {
                stringRange = [[string objectForKey:@"Date"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.date rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 4) {
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
        _selectedLocation = _feedItems[indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:CUSTVIEWSEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:CUSTVIEWSEGUE])
    {
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME2;
        /*
         *******************************************************************************************
         Parse.com
         *******************************************************************************************
         */
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            if (!isFilltered) {
                detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                detailVC.custNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"CustNo"]stringValue];
                detailVC.leadNo = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LeadNo"]stringValue];
                detailVC.date = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Date"];
                detailVC.name = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"LastName"];
                detailVC.address = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Address"];
                detailVC.city = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"City"];
                detailVC.state = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"State"];
                detailVC.zip = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Zip"]stringValue];
                detailVC.amount = [NSString stringWithFormat:@"%@",[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
                detailVC.tbl11 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Contractor"];
                detailVC.tbl12 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Phone"];
                detailVC.tbl13 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"First"];
                detailVC.tbl14 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Spouse"];
                detailVC.tbl15 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.tbl21 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Start"];
                detailVC.tbl22 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"SalesNo"]stringValue];
                detailVC.tbl23 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"JobNo"]stringValue];
                detailVC.tbl24 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"ProductNo"]stringValue];
                detailVC.tbl25 = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Quan"]stringValue];
                detailVC.tbl16 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Time"];
                detailVC.tbl26 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Rate"];
                detailVC.complete = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Completion"];
                detailVC.photo = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Photo"];
                detailVC.comments = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Comments"];
                detailVC.active = [[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            } else {
                detailVC.objectId = [[filteredString objectAtIndex:indexPath.row] objectId];
                detailVC.custNo = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"CustNo"]stringValue];
                detailVC.leadNo = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"LeadNo"]stringValue];
                detailVC.date = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Date"];
                detailVC.name = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"LastName"];
                detailVC.address = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Address"];
                detailVC.city = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"City"];
                detailVC.state = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"State"];
                detailVC.zip = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Zip"]stringValue];
                detailVC.amount = [NSString stringWithFormat:@"%@",[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Amount"]];
                detailVC.tbl11 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Contractor"];
                detailVC.tbl12 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Phone"];
                detailVC.tbl13 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"First"];
                detailVC.tbl14 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Spouse"];
                detailVC.tbl15 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Email"];
                detailVC.tbl21 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Start"];
                detailVC.tbl22 = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"SalesNo"]stringValue];
                detailVC.tbl23 = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"JobNo"]stringValue];
                detailVC.tbl24 = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"ProductNo"]stringValue];
                detailVC.tbl25 = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Quan"]stringValue];
                detailVC.tbl16 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Time"];
                detailVC.tbl26 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Rate"];
                detailVC.complete = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Completion"];
                detailVC.photo = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Photo"];
                detailVC.comments = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Comments"];
                detailVC.active = [[[filteredString objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
            }
        } else {
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
            detailVC.complete = _selectedLocation.completion;
            detailVC.photo = _selectedLocation.photo;
            detailVC.comments = _selectedLocation.comments;
            detailVC.active = _selectedLocation.active;
            //photo1, photo2
        }
        
        detailVC.l11 = @"Contractor"; detailVC.l12 = @"Phone";
        detailVC.l13 = @"First"; detailVC.l14 = @"Spouse";
        detailVC.l15 = @"Email"; detailVC.l21 = @"Start date";
        detailVC.l22 = @"Salesman"; detailVC.l23 = @"Job";
        detailVC.l24 = @"Product"; detailVC.l25 = @"Quan";
        detailVC.l16 = @"Last Updated"; detailVC.l26 = @"Rate";
        detailVC.l1datetext = @"Sale Date:";
        detailVC.lnewsTitle = CUSTOMERNEWSTITLE;
    }
    if ([[segue identifier] isEqualToString:CUSTNEWSEGUE]) {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME2 ;
    }
}

@end
