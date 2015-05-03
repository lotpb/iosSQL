//
//  ViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
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
     self.title = NSLocalizedString(TNAME1, nil);
     self.edgesForExtendedLayout = UIRectEdgeNone; //fix
     self.listTableView.delegate = self;
     self.listTableView.dataSource = self;
     self.listTableView.backgroundColor = BACKGROUNDCOLOR;
     self.listTableView.pagingEnabled = YES;
    
    _feedItems = [[NSMutableArray alloc] init]; _homeModel = [[HomeModel alloc] init]; _homeModel.delegate = self; [_homeModel downloadItems];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  // [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    [_homeModel downloadItems];
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

#pragma mark - BarButton NewData
-(void)newData:(id)sender {
    [self performSegueWithIdentifier:LEADNEWSEGUE sender:self];
}

#pragma mark - TableView
-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
}

#pragma mark TableView Delete Button
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
                                 Location *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.leadNo;
                                 NSString *_leadNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:LEADDELETENO, LEADDELETENO1];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:LEADDELETEURL];
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
    static NSString *cellIdentifier = IDCELL;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -90, 23, 75, 27)];
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

    myCell.textLabel.text = item.name;
    myCell.detailTextLabel.text = item.city;
   [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
    
 // UIImage *myImage = [UIImage imageNamed:TABLECELLIMAGE];
 // [myCell.imageView setImage:myImage];
      //problem below with iphone 5 width
    
    label1.text = item.callback;
    [label1 setFont:CELL_FONT1(CELL_FONTSIZE - 2)];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setTextColor:[UIColor blackColor]];
    [label1 setBackgroundColor:[UIColor whiteColor]];
    label1.tag = 102;
    [myCell.contentView addSubview:label1];

    label2.text=  item.date;
    [label2 setFont:CELL_MEDFONT(CELL_FONTSIZE - 2)];//[UIFont boldSystemFontOfSize:12.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setTextColor:DATECOLORTEXT];
    [label2 setBackgroundColor:DATECOLORBACK];
     label2.tag = 103;
    [myCell.contentView addSubview:label2];
    
    return myCell;
}

#pragma mark Tableheader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return HEADHEIGHT;
    else
       return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   //NSString *uppercase = [TNAME1 uppercaseString];
    NSString *newString = [NSString stringWithFormat:@"LEADS \n%lu", (unsigned long) _feedItems.count];
    NSString *newString1 = [NSString stringWithFormat:HEADTITLE2];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LABELSIZE1)];
    [label setFont:CELL_FONT(HEADFONTSIZE)];
    [label setTextColor:HEADTEXTCOLOR];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label.shadowOffset = CGSizeMake(0.0f, 0.5f);
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
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
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
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
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

#pragma mark - search
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
    self.searchController.searchBar.scopeButtonTitles = @[LEADSCOPE];
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

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
       [self performSegueWithIdentifier:LEADVIEWSEGUE sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:LEADVIEWSEGUE])
    {
      //  NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME1;
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
        detailVC.lnewsTitle = LEADNEWSTITLE;
    }
    if ([[segue identifier] isEqualToString:LEADNEWSEGUE]) {
        NewData *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME1; }
}

@end
