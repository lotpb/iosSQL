//
//  ParseStatsController.m
//  MySQL
//
//  Created by Peter Balsamo on 7/3/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "ParseStatsController.h"

@interface ParseStatsController ()
{
   // StatCustModel *_StatCustModel; StatLeadModel *_StatLeadModel;
    NSMutableArray *_statHeaderItems, *_feedCustItems; //*respond11;
    NSDictionary *dict, *s1results, *s2results, *s3results, *s4results, *s5results, *s6results, *w1results, *results11;
    NSString *amount, *respond, *respond1, *respond2, *respond3, *respond4, *respond5, *respond6, *respond7, *srrespond, *ssrespond, *cirespond, *lastrespond, *respond11, *respond12;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ParseStatsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//fix
    self.title = NSLocalizedString(@"Statistics", nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = STATBACKCOLOR;
    self.listTableView.rowHeight = 30; //UITableViewAutomaticDimension;
    //[self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //self.listTableView.estimatedRowHeight = 44.0;
    
    //[self itemsStatHeaderDownloaded];
    
    [self YahooFinanceLoad];
    
    filteredString= [[NSMutableArray alloc] init];
    
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = STATBACKCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)viewDidAppear:(BOOL)animated { //fix only works in viewdidappear
    [super viewDidAppear:animated];
    [self.listTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR; //set in AppDelegate - grayColor
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
-(void)reloadDatas:(id)sender {
  //  [_StatLeadModel downloadItems];
  //  [_StatCustModel downloadItems];
    [self YahooFinanceLoad];
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

#pragma mark - TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 6;
    else if (section == 1)
        return 6;
    else if (section == 2)
        return 8;
    else if (section == 3)
        return 8;
    else if (section == 4)
        return 1; //respond11.count;
    return 0;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    CustLocation *item;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.accessoryType = UITableViewCellAccessoryNone;
    [myCell.textLabel setFont:CELL_FONT(STATFONTSIZE)];
    [myCell.detailTextLabel setFont:CELL_MEDFONT(STATFONTSIZE)];
    [myCell.detailTextLabel setTextColor:STATTEXTCOLOR];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"NASDAQ";
            myCell.detailTextLabel.text = respond;
            
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"S&P 500";
            myCell.detailTextLabel.text = respond1;
            
            return myCell;
            
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"UUP";
            myCell.detailTextLabel.text = respond5;
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"VSCY";
            myCell.detailTextLabel.text = respond4;
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"GPRO";
            myCell.detailTextLabel.text = respond6;
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"UPL";
            myCell.detailTextLabel.text = respond7;
            
            return myCell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"Todays Temperature";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Todays Weather";
            myCell.detailTextLabel.text = respond3;
            
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Sunrise";
            myCell.detailTextLabel.text = srrespond;
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Sunset";
            myCell.detailTextLabel.text = ssrespond;
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"City";
            myCell.detailTextLabel.text = cirespond;
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Last Update";
            myCell.detailTextLabel.text = lastrespond;
            
            return myCell;
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"Leads Today";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Appointment's Today";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Appointment's Tomorrow";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Leads Active";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Leads Year";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Leads Avg";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 6) {
            
            myCell.textLabel.text = @"Leads High";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 7) {
            
            myCell.textLabel.text = @"Leads Low";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        }
        
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            myCell.textLabel.text = @"Customers Today";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Customers Yesterday";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Customers Active";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Customers Year";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Customers Avg";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Customers High";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 6) {
            
            myCell.textLabel.text = @"Customers Low";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        } else if (indexPath.row == 7) {
            
            myCell.textLabel.text = @"Windows Sold";
            myCell.detailTextLabel.text = respond2;
            
            return myCell;
        }
        
        } else if (indexPath.section == 4) {
            if (indexPath.row == 0) {
                
            myCell.textLabel.text = @"Windows Sold";
            myCell.detailTextLabel.text = respond2;
            
        }
    }
    return nil;
}

#pragma mark TableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return MAINHEADHEIGHT;
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section {
    NSString *footerTitle;
    if (section == 0)
        footerTitle = @"Weather";
    if (section == 1)
        footerTitle = @"Leads";
    if (section == 2)
        footerTitle = @"Customers";
    
    return footerTitle;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = @"Statistics";
    NSString *newString1 = @"SALES";
    NSString *newString2 = [[_statHeaderItems objectAtIndex:1] objectForKey:@"Amount"];
    
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
        self.label2.text = [[_statHeaderItems objectAtIndex:2] objectForKey:@"Amount"];;
    }
    if (segment.selectedSegmentIndex == 1) {
        self.label2.text = [[_statHeaderItems objectAtIndex:1] objectForKey:@"Amount"];;
    }
    if (segment.selectedSegmentIndex == 2) {
        self.label2.text = [[_statHeaderItems objectAtIndex:0] objectForKey:@"Amount"];
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

#pragma mark - Yahoo Finance
-(void)YahooFinanceLoad {
    
    yql = [[YQL alloc] init];
    NSString *queryString2 = @"select * from weather.forecast where woeid=2446726";
    NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\")";
    NSString *queryString1 = @"select * from yahoo.finance.quote where symbol in (\"SPY\")";
    NSString *queryString3 = @"select * from yahoo.finance.quote where symbol in (\"VCSY\")";
    NSString *queryString4 = @"select * from yahoo.finance.quote where symbol in (\"UUP\")";
     NSString *queryString5 = @"select * from yahoo.finance.quote where symbol in (\"GPRO\")";
     NSString *queryString6 = @"select * from yahoo.finance.quote where symbol in (\"UPL\")";
    //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    NSString *queryString11 = @"select * from yahoo.finance.quote where symbol in (\"YHOO\",\"AAPL\",\"GOOG\",\"SPY\")";
    //NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"SPY\",\"^IXIC\")";
    
    s1results = [yql query:queryString]; //nasdaq
    respond = [[[s1results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    s2results = [yql query:queryString1]; //spy
    respond1 = [[[s2results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    s3results = [yql query:queryString3]; //uup
    respond4 = [[[s3results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    s4results = [yql query:queryString4]; //vcsy
    respond5 = [[[s4results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    s5results = [yql query:queryString5]; //GPRO
    respond6 = [[[s5results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    s6results = [yql query:queryString6]; //UPL
    respond7 = [[[s6results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
    
    results11 = [yql query:queryString11]; //Many
    respond11 = [results11 valueForKeyPath:@"query.results.quote.Symbol"];
    respond12 = [results11 valueForKeyPath:@"query.results.quote.LastTradePriceOnly"];
    
    w1results = [yql query:queryString2];
    respond2 = [[w1results valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"temp"];
    respond3 = [[w1results valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"text"];
    srrespond = [[w1results valueForKeyPath:@"query.results.channel.astronomy"] objectForKey:@"sunrise"];
    ssrespond = [[w1results valueForKeyPath:@"query.results.channel.astronomy"] objectForKey:@"sunset"];
    cirespond = [[w1results valueForKeyPath:@"query.results.channel.location"] objectForKey:@"city"];
    lastrespond = [[w1results valueForKeyPath:@"query.results.channel"] objectForKey:@"lastBuildDate"];
    
    NSLog(@"%@", respond12);
    NSLog(@"%@", respond11);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
}

@end
