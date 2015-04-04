//
//  JobViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "JobViewController.h"
#import "JobLocation.h"
#import <Parse/Parse.h>

@interface JobViewController ()
{
    JobModel *_JobModel; NSMutableArray *_feedItems; JobLocation *_selectedLocation; UIRefreshControl *refreshControl;
    NSMutableArray *jobCount;
}
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation JobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Jobs", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    
    _feedItems = [[NSMutableArray alloc] init]; _JobModel = [[JobModel alloc] init];
    _JobModel.delegate = self; [_JobModel downloadItems];
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];
    
#pragma mark  Bar Button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newData)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark  Table Refresh
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButton NewData
-(void)newData {
    [self performSegueWithIdentifier:@"jobDetailSegue"sender:self];
}

#pragma mark - Table
-(void)itemsDownloaded:(NSMutableArray *)items
{   // This delegate method will get called when the items are finished downloading
    _feedItems = items;
    [self.listTableView reloadData];
    [self parseJob];
}

#pragma mark Table Refresh Control
- (void)reloadDatas:(id)sender {
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
                                     alertControllerWithTitle:@"Delete the selected job?"
                                     message:@"OK, delete it"
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 JobLocation *item;
                                 item = [_feedItems objectAtIndex:indexPath.row];
                                 NSString *deletestring = item.jobNo;
                                 NSString *_jobNo = deletestring;
                                 NSString *rawStr = [NSString stringWithFormat:@"_jobNo=%@&&", _jobNo];
                                 NSData *data = [rawStr dataUsingEncoding:NSUTF8StringEncoding];
                                 
                                 NSURL *url = [NSURL URLWithString:@"http://localhost:8888/deleteJob.php"];
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

#pragma mark  TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFilltered)
        return [filteredString  count];
    return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    myCell.layer.cornerRadius = 5;
    myCell.layer.masksToBounds = YES;
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    JobLocation *item;
    if (!isFilltered)
        item = _feedItems[indexPath.row];
        else
        item = [filteredString objectAtIndex:indexPath.row];
    
        myCell.textLabel.text = item.jobdescription;
       // myCell.detailTextLabel.text = item.jobNo;
        UIImage *myImage = [UIImage imageNamed:@"DemoCellImage"];
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
    NSString *newString = [NSString stringWithFormat:@"JOB \n%lu", (unsigned long) _feedItems.count];
      NSString *newString1 = [NSString stringWithFormat:@"ACTIVE \n%lu",(unsigned long) jobCount.count];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, tableView.frame.size.width, 45)];
    [label setFont:CELL_MEDFONT(HEADFONTSIZE)];
    [label setTextColor:HEADCOLOR];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 3, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_MEDFONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 45, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 3, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_MEDFONT(HEADFONTSIZE)];
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
    self.searchController.searchBar.scopeButtonTitles = @[@"job",@"jobNo",@"active"];
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
        // [filteredString removeAllObjects];
        filteredString = [[NSMutableArray alloc]init];
        
        for(JobLocation *string in _feedItems)
        {
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.jobdescription rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.jobNo rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.active rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound)
                    [filteredString addObject:string];
            }
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Parse
-(void)parseJob {
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"Description"]];
    //[query whereKey:@"Active" containsString:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        jobCount = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"jobDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"jobDetailSegue"])
    {
        NewDataDetail *detailVC = segue.destinationViewController;
        detailVC.formController = @"Jobs";
        detailVC.frm11= _selectedLocation.active;
        detailVC.frm12 = _selectedLocation.jobNo;
        detailVC.frm13 = _selectedLocation.jobdescription;
    }
}

@end
