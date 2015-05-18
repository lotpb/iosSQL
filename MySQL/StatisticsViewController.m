//
//  StatisticsViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 4/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()
{
    StatModel *_StatModel; NSMutableArray *_feedItems; //CustLocation *_selectedLocation;
    StatLeadModel *_StatLeadModel; NSMutableArray *_feedLeadItems; //CustLocation *_selectedLocation;
    StatHeaderModel *_StatHeaderModel; NSMutableArray *_feedHeaderItems; //CustLocation *_selectedHeaderLocation;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation StatisticsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//fix
    self.title = NSLocalizedString(@"Statistics", nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = [UIColor lightGrayColor];
    //[self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //self.listTableView.estimatedRowHeight = 44.0;
    //self.listTableView.rowHeight = UITableViewAutomaticDimension;

    _feedItems = [[NSMutableArray alloc] init]; _StatModel = [[StatModel alloc] init];
    _StatModel.delegate = self; [_StatModel downloadItems];
    
    _feedLeadItems = [[NSMutableArray alloc] init]; _StatLeadModel = [[StatLeadModel alloc] init];
    _StatLeadModel.delegate = self; [_StatLeadModel downloadItems];
    
    _feedHeaderItems = [[NSMutableArray alloc] init]; _StatHeaderModel = [[StatHeaderModel alloc] init];
    _StatHeaderModel.delegate = self; [_StatHeaderModel downloadItems];
    
    tableLeadData = [[NSMutableArray alloc]initWithObjects:SNAME1, SNAME2, SNAME3, SNAME4, SNAME5, SNAME6, nil];
    tableCustData = [[NSMutableArray alloc]initWithObjects:SNAME8, SNAME9, SNAME10, SNAME11, SNAME12,nil];
    
    filteredString= [[NSMutableArray alloc] init];

#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor lightGrayColor];
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR; //set in AppDelegate - grayColor
}

- (void)viewDidAppear:(BOOL)animated { //fix only works in viewdidappear
    [super viewDidAppear:animated];
   /*
    tableData1 = [[NSMutableArray alloc]initWithObjects:SNAME22, SNAME22, SNAME33, SNAME44, SNAME55, SNAME66, SNAME77, SNAME88, SNAME99, nil];
    [self.listTableView reloadData]; */
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)itemsDownloaded:(NSMutableArray *)items {
    _feedItems = items;
    [self.listTableView reloadData];
    // NSLog(@"rawStr is %@",_feedItems);
}

-(void)itemsLeadDownloaded:(NSMutableArray *)itemsLead {
    _feedLeadItems = itemsLead;
    [self.listTableView reloadData];
    // NSLog(@"rawStr is %@",_feedHeaderItems);
}

-(void)itemsHeaderDownloaded:(NSMutableArray *)itemsHeader {
    _feedHeaderItems = itemsHeader;
    [self.listTableView reloadData];
   // NSLog(@"rawStr is %@",_feedHeaderItems);
}

#pragma mark - RefreshControl
-(void)reloadDatas:(id)sender {
    
    [_StatModel downloadItems];
    [self.listTableView reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:KEY_DATEREFRESH];
            NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }
        
        [refreshControl endRefreshing];
    }
}

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
       if (section == 0)
            return _feedLeadItems.count;
        else if (section == 1)
            return _feedItems.count;
    return 0;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        
        static NSString *CellIdentifier = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         if (myCell == nil)
         myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        CustLocation *item;
        item = _feedLeadItems[indexPath.row];

        myCell.textLabel.text = [tableLeadData objectAtIndex:indexPath.row];
        myCell.detailTextLabel.text = item.leadNo;
        [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        return myCell;
        
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         if (myCell == nil)
         myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; 
        
        CustLocation *item;
        item = _feedItems[indexPath.row];
        
        myCell.textLabel.text = [tableCustData objectAtIndex:indexPath.row];
        myCell.detailTextLabel.text = item.custNo;
        [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        return myCell;
        
    }
    return nil;
}

#pragma mark TableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     if (section == 0){
        return MAINHEADHEIGHT;
     }
    else return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//  CustLocation *itemsHeader;
 //NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
    NSString *newString = @"Statistics";
    NSString *newString1 = @"SALES";
    NSString *newString2 = @"$81,295"; //[[_feedHeaderItems objectAtIndex:indexPath.row]objectForKey:@"amount"];//itemsHeader.amount;
//NSLog(@"rawStr is %@",_feedHeaderItems);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, MAINHEADHEIGHT)];
    
    UIImage *image = [UIImage imageNamed:@"background"];
    imageHolder.image = image;
    imageHolder.contentMode = UIViewContentModeScaleAspectFill;
    imageHolder.clipsToBounds = true;
    
    [view addSubview:imageHolder];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width /2 -45, 3, 90, 45)];
    [label setFont: [UIFont fontWithName:@"Avenir-Book" size:21]];//Avenir-Black];
    [label setTextColor:HEADTEXTCOLOR];
     label.textAlignment = NSTextAlignmentCenter;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"WEEKLY", @"MONTHLY", @"YEARLY", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(tableView.frame.size.width /2 -125, 45, 250, 30);
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    [view addSubview:segmentedControl];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width /2 -25, 75, 50, 45)];
     label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:[UIFont fontWithName:@"Avenir-Black" size:16]];
    [label1 setTextColor:[UIColor greenColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.size.width /2 -30, 110, 60, 1.9)];
    separatorLineView1.backgroundColor = [UIColor whiteColor];
    [view addSubview:separatorLineView1];
    
    UILabel *textframe = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width /2 -70, 115, 140, 45)];
     self.label2 = textframe;
     self.label2.textAlignment = NSTextAlignmentCenter;
    [self.label2 setFont:[UIFont fontWithName:@"Avenir-Black" size:30]];
    [self.label2 setTextColor:HEADTEXTCOLOR];
    NSString *string2 = newString2;
    [self.label2 setText:string2];
    [view addSubview:self.label2];
    
    return view;
}

#pragma mark - SegmentedControl
- (void)segmentAction:(UISegmentedControl *)segment {

    if (segment.selectedSegmentIndex == 0) {
        [self.label2 setText:@"$23,399"];
    }
    if (segment.selectedSegmentIndex == 1) {
        self.label2.text = @"$81,295";
    }
    if (segment.selectedSegmentIndex == 2) {
        self.label2.text = @"$199,392";
    }
}

#pragma mark - Search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = MHIDE;
    self.searchController.dimsBackgroundDuringPresentation = SDIM;
    self.definesPresentationContext = SDEFINE;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLORMAIN;
    self.searchController.hidesBottomBarWhenPushed = SHIDEBAR;
    self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
        isFilltered = NO;
    else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(NSString *str in tableLeadData)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
                [filteredString addObject:str];
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Segue
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row];
    
   // [self performSegueWithIdentifier:LEADVIEWSEGUE sender:self];
} */

@end
