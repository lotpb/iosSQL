//
//  SalesmanViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "SalesmanViewController.h"

@interface SalesmanViewController ()
{
    PFObject *imageObject;
    PFFile *imageFile;
    SalesModel *_SalesModel; SalesLocation *_selectedLocation;
    NSMutableArray *headCount, *_feedItems;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation SalesmanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(TNAME8, nil);
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
       [parseConnection parseSalesman]; [parseConnection parseHeadSalesman];
    } else {
        _feedItems = [[NSMutableArray alloc] init]; _SalesModel = [[SalesModel alloc] init];
        _SalesModel.delegate = self; [_SalesModel downloadItems];
    }
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark  Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[addItem, searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
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
   //self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
    [self.listTableView reloadData];
}

-(void)viewDidLayoutSubviews {//white space seperatorline
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.listTableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
       [parseConnection parseSalesman]; [parseConnection parseHeadSalesman];
    } else {
        [_SalesModel downloadItems];
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
-(void)newData {
     isFormStat = YES;
    [self performSegueWithIdentifier:SALEVIEWSEGUE sender:self];
}

#pragma mark - ParseDelegate
- (void)parseHeadSalesmanloaded:(NSMutableArray *)salesheadItem {
    headCount = salesheadItem;
    [self.listTableView reloadData];
}

- (void)parseSalesmanloaded:(NSMutableArray *)saleItem {
    _feedItems = saleItem;
    [self.listTableView reloadData];
}

#pragma mark - Table
-(void)itemsDownloaded:(NSMutableArray *)items
{   // This delegate method will get called when the items are finished downloading
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
                                     PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
                                     [query whereKey:@"objectId" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectId] ];
                                     [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                                         if (object) {
                                             [object deleteEventually];
                                         } else {
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     
                                 } else {
                                     NSURL *url = [NSURL URLWithString:SALEDELETEURL];
                                     NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                                     NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                                     
                                     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                                     request.HTTPMethod = @"POST";
                                     
                                     SalesLocation *item;
                                     item = [_feedItems objectAtIndex:indexPath.row];
                                     NSString *deletestring = item.salesNo;
                                     NSString *_salesNo = deletestring;
                                     NSString *rawStr = [NSString stringWithFormat:SALEDELETENO, SALEDELETENO1];
                                     NSError *error = nil;
                                     NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                     [request setHTTPBody:data];
                                     
                                     if (!error) {
                                         NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                                                                    fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                                                                                                        // Handle response here
                                                                                                    }];
                                         
                                         [uploadTask resume];
                                     }
                                     
                                     NSString *success = @"success";
                                     [success dataUsingEncoding:NSUTF8StringEncoding];
                                 }
                                 [_feedItems removeObjectAtIndex:indexPath.row];
                                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                                 //GOBACK; // Dismiss the viewController upon success
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

#pragma mark  TableView Delegate
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_FONT(IPADFONT20)];
        //[myCell.detailTextLabel setFont:CELL_FONT(IPADFONT16)];
    } else {
        [myCell.textLabel setFont:CELL_FONT(IPHONEFONT20)];
        //[myCell.detailTextLabel setFont:CELL_FONT(IPHONEFONT16 - 2)];
    }
     myCell.layer.cornerRadius = 5;
     myCell.layer.masksToBounds = YES;
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        if (!isFilltered)
            myCell.textLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
        else
            myCell.textLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
    } else {
        SalesLocation *item;
        if (!isFilltered)
            item = _feedItems[indexPath.row];
        else
            item = [filteredString objectAtIndex:indexPath.row];
        myCell.textLabel.text = item.salesman;
        // myCell.detailTextLabel.text = item.salesNo;
    }

    UIImage *myImage = [UIImage imageNamed:TABLECELLIMAGE];
    [myCell.imageView setImage:myImage];
    
    return myCell;
}

#pragma mark  Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return HEADHEIGHT;
        else
        return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"SALESMAN \n%lu", (unsigned long) _feedItems.count];
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
    self.searchController.searchBar.scopeButtonTitles = @[SALESCOPE];
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
        //for(SalesLocation* string in _feedItems)
        {
            NSRange stringRange;
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
            {
                stringRange = [[string objectForKey:@"Salesman"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.salesman rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
            {
                stringRange = [[string objectForKey:@"SalesNo"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
                //stringRange = [string.salesNo rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
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
    imageObject = [_feedItems objectAtIndex:indexPath.row];
    imageFile = [imageObject objectForKey:KEY_IMAGE];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.selectedImage = [UIImage imageWithData:data];
            
            if (!isFilltered)
                _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
            else
                _selectedLocation = [filteredString objectAtIndex:indexPath.row];
            
            isFormStat = NO;
            [self performSegueWithIdentifier:SALEVIEWSEGUE sender:self];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:SALEVIEWSEGUE])
    {
        NewDataDetail *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME8;
        
        if (isFormStat == YES)
            detailVC.formStatus = @"New";
        else
            detailVC.formStatus = @"Edit";
/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
            if (!isFilltered) {
                detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                detailVC.frm11 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Active"];
                detailVC.frm12 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"SalesNo"];
                detailVC.frm13 = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
                detailVC.image = self.selectedImage;
            } else {
                detailVC.objectId = [[filteredString objectAtIndex:indexPath.row] objectId];
                detailVC.frm11 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Active"];
                detailVC.frm12 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"SalesNo"];
                detailVC.frm13 = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
                detailVC.image = self.selectedImage;
            }
        } else {
            detailVC.frm11 = _selectedLocation.active;
            detailVC.frm12 = _selectedLocation.salesNo;
            detailVC.frm13 = _selectedLocation.salesman;
        }
    }
}

@end
