//
//  StatisticsiPadController.m
//  MySQL
//
//  Created by Peter Balsamo on 7/3/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "StatisticsiPadController.h"

@interface StatisticsiPadController ()
{
    NSMutableArray *_statHeaderItems, *_feedItems, *_feedLeadActive, *_feedCustActive, *_feedAppToday, *_feedWinSold, *symYQL, *fieldYQL, *changeYQL, *dayYQL, *textYQL, *humidityYQL;
    NSDictionary *dict, *w1results, *resultsYQL;
    NSString *amount;
    NSTimer *myTimer;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation StatisticsiPadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//fix
    self.title = NSLocalizedString(@"Statistics", nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = STATBACKCOLOR;
    self.listTableView.rowHeight = 30;
    self.listTableViewLeft.rowHeight = 30;
    self.listTableViewRight.rowHeight = 30;
    self.listTableViewLeft1.rowHeight = 30;
    self.listTableViewRight1.rowHeight = 30;
    //UITableViewAutomaticDimension;
    //self.listTableView.estimatedRowHeight = 44.0;
    
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseStatConnection *parseConnection = [[ParseStatConnection alloc]init];
        parseConnection.delegate = (id)self;
        
        [parseConnection parseTodayLeads]; [parseConnection parseActiveLeads];
        [parseConnection parseActiveCust]; [parseConnection parseApptTodayLeads];
        [parseConnection parseWindowSold];
    }
    
    [self YahooFinanceLoad];
    
    //| -------------------------Timer----------------------------------
    
      myTimer = [NSTimer scheduledTimerWithTimeInterval: 3.0 target:self selector:@selector(reloadDatas:) userInfo:nil repeats: YES];
    
    //| ---------------------------end----------------------------------
    
    filteredString= [[NSMutableArray alloc] init];
    
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.scrollWall insertSubview:refreshView atIndex:0];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [myTimer invalidate];
     myTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
-(void)reloadDatas:(id)sender {
    
    [self YahooFinanceLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseStatConnection *parseConnection = [[ParseStatConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseTodayLeads]; [parseConnection parseActiveLeads];
       [parseConnection parseActiveCust]; [parseConnection parseApptTodayLeads];
       [parseConnection parseWindowSold];
    }
    [self.listTableView reloadData]; [self.listTableViewLeft reloadData];
    [self.listTableViewRight reloadData]; [self.listTableViewLeft1 reloadData];
    [self.listTableViewRight1 reloadData];
    
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

#pragma mark - ParseDelegate
- (void)parseLeadTodayloaded:(NSMutableArray *)leadItem {
    _feedItems = leadItem;
    [self.listTableViewLeft reloadData];
}

- (void)parseLeadActiveloaded:(NSMutableArray *)leadItem {
    _feedLeadActive = leadItem;
    [self.listTableViewLeft reloadData];
}

- (void)parseCustActiveloaded:(NSMutableArray *)leadItem {
    _feedCustActive = leadItem;
    [self.listTableViewRight reloadData];
}

- (void)parseLeadApptTodayloaded:(NSMutableArray *)leadItem {
    _feedAppToday = leadItem;
    [self.listTableViewLeft reloadData];
}

- (void)parseWindowSoldloaded:(NSMutableArray *)leadItem {
    _feedWinSold = leadItem;
    [self.listTableViewLeft reloadData];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.listTableView])
        return 10;
    else if ([tableView isEqual:self.listTableViewLeft1])
        return 6;
    else if ([tableView isEqual:self.listTableViewRight1])
        return 6;
    else if ([tableView isEqual:self.listTableViewLeft])
        return 8;
    else if ([tableView isEqual:self.listTableViewRight])
        return 8;
    
    return 0;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.listTableView]) {
        
        static NSString *CellIdentifier = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -165, 6, 77, 17)];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -80, 6, 67, 17)];
        
        [label1 setFont:CELL_LIGHTFONT(IPADFONT16)];
        [label1 setBackgroundColor:[UIColor whiteColor]];
        label1.textAlignment = NSTextAlignmentRight;
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:CELL_MEDFONT(IPADFONT16)];
        label2.textAlignment = NSTextAlignmentRight;
        
         myCell.selectionStyle = UITableViewCellSelectionStyleNone;
         myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADFONT12)];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row == 0) {
            
            if (![[changeYQL objectAtIndex:0] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:0];
            label2.text = [changeYQL objectAtIndex:0];
            label1.text = [fieldYQL objectAtIndex:0];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            if (![[changeYQL objectAtIndex:1] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:1];
            label2.text = [changeYQL objectAtIndex:1];
            label1.text = [fieldYQL objectAtIndex:1];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
            
        } else if (indexPath.row == 2) {
            
            if (![[changeYQL objectAtIndex:2] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:2] ;
            label2.text = [changeYQL objectAtIndex:2] ;
            label1.text = [fieldYQL objectAtIndex:2] ;
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 3) {
            
            if (![[changeYQL objectAtIndex:3] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:3];
            label2.text = [changeYQL objectAtIndex:3];
            label1.text = [fieldYQL objectAtIndex:3];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 4) {
            
            if (![[changeYQL objectAtIndex:4] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:4];
            label2.text = [changeYQL objectAtIndex:4];
            label1.text = [fieldYQL objectAtIndex:4];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 5) {
            
            if (![[changeYQL objectAtIndex:5] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:5];
            label2.text = [changeYQL objectAtIndex:5];
            label1.text = [fieldYQL objectAtIndex:5];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 6) {
            
            if (![[changeYQL objectAtIndex:6] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:6];
            label2.text = [changeYQL objectAtIndex:6];
            label1.text = [fieldYQL objectAtIndex:6];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 7) {
            
            if (![[changeYQL objectAtIndex:7] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:7];
            label2.text = [changeYQL objectAtIndex:7];
            label1.text = [fieldYQL objectAtIndex:7];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 8) {
            
            if (![[changeYQL objectAtIndex:8] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:8];
            label2.text = [changeYQL objectAtIndex:8];
            label1.text = [fieldYQL objectAtIndex:8];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        } else if (indexPath.row == 9) {
            
            if (![[changeYQL objectAtIndex:9] containsString:@"-"]) {
                [label2 setBackgroundColor:STOCKGREEN];
            } else {
                [label2 setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:9];
            label2.text = [changeYQL objectAtIndex:9];
            label1.text = [fieldYQL objectAtIndex:9];
            [myCell.contentView addSubview:label1];
            [myCell.contentView addSubview:label2];
            return myCell;
        }
    } else if ([tableView isEqual:self.listTableViewLeft1]) {
        
        static NSString *CellIdentifier1 = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"Todays Temperature";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"temp"];
            
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Todays Weather";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"text"];
            
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Sunrise";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.astronomy"] objectForKey:@"sunrise"];
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Sunset";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.astronomy"] objectForKey:@"sunset"];
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Humidity";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.atmosphere"] objectForKey:@"humidity"];
            return myCell;
            
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"City";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.location"] objectForKey:@"city"];
            return myCell;
            
        }
    } else if ([tableView isEqual:self.listTableViewRight1]) {
        
        static NSString *CellIdentifier1 = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = [dayYQL objectAtIndex:0];
            myCell.detailTextLabel.text = [textYQL objectAtIndex:0];
            
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = [dayYQL objectAtIndex:1];
            myCell.detailTextLabel.text = [textYQL objectAtIndex:1];
            
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = [dayYQL objectAtIndex:2];
            myCell.detailTextLabel.text = [textYQL objectAtIndex:2];
            
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = [dayYQL objectAtIndex:3];
            myCell.detailTextLabel.text = [textYQL objectAtIndex:3];
            
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = [dayYQL objectAtIndex:4];
            myCell.detailTextLabel.text = [textYQL objectAtIndex:4];
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Last Update";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel"] objectForKey:@"lastBuildDate"];
            
            return myCell;
        }
    } else if ([tableView isEqual:self.listTableViewLeft]) {
        
        static NSString *CellIdentifier1 = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"Leads Today";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Appointment's Today";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedAppToday.count];
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Appointment's Tomorrow";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Leads Active";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedLeadActive.count];
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Leads Year";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Leads Avg";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 6) {
            
            myCell.textLabel.text = @"Leads High";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 7) {
            
            myCell.textLabel.text = @"Leads Low";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        }
        
    } else if ([tableView isEqual:self.listTableViewRight]) {
        
        static NSString *CellIdentifier2 = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADFONT12)];
        [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = @"Customers Today";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Customers Yesterday";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        }  else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Windows Sold";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedWinSold.count];
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Customers Active";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedCustActive.count];
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Customers Year";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Customers Avg";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 6) {
            
            myCell.textLabel.text = @"Customers High";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 7) {
            
            myCell.textLabel.text = @"Customers Low";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        }
    }
    return nil;
}

#pragma mark TableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.listTableView]) {
        if (section == 0)
        return MAINHEADHEIGHT;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.font = [UIFont fontWithName:@"Chalkduster" size:16];
    UIColor *pinkTint = [UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0];
    headerLabel.backgroundColor = pinkTint;
    
    if ([tableView isEqual:self.listTableView]) {
        headerLabel.text = @"  My Weather";
    } else if ([tableView isEqual:self.listTableViewLeft1]) {
        headerLabel.text = @"  My Leads";
    } else if ([tableView isEqual:self.listTableViewRight1]) {
        headerLabel.text = @"  My Customer";
    }
    return headerLabel;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *newString = @"Statistics";
    NSString *newString1 = @"SALES";
    NSString *newString2 = @"$100,000"; //[[_statHeaderItems objectAtIndex:1] objectForKey:@"Amount"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.frame.size.width, 0)];
    self.listTableView.tableHeaderView = view; //makes header move with tablecell
    view.backgroundColor = BLOGNAVBARCOLOR;
    /*
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.frame.size.width, MAINHEADHEIGHT)];
    UIImage *image = [UIImage imageNamed:@"background"];
    imageHolder.image = image;
    imageHolder.contentMode = UIViewContentModeScaleAspectFill;
    imageHolder.clipsToBounds = true;
    [view addSubview:imageHolder]; */
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"WEEKLY", @"MONTHLY", @"YEARLY", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(tableView.frame.size.width /2 -125, 45, 250, 30);
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 1;
    [view addSubview:segmentedControl];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -47, 3, 95, 45)];
    [label setFont: [UIFont fontWithName:@"Avenir-Book" size:24]];//Avenir-Black];
    [label setTextColor:HEADTEXTCOLOR];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -25, 75, 50, 45)];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:[UIFont fontWithName:@"Avenir-Black" size:16]];
    [label1 setTextColor:[UIColor greenColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UILabel *textframe = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -70, 115, 140, 45)];
    self.label2 = textframe;
    self.label2.textAlignment = NSTextAlignmentCenter;
    [self.label2 setFont:[UIFont fontWithName:@"Avenir-Black" size:30]];
    [self.label2 setTextColor:HEADTEXTCOLOR];
    NSString *string2 = newString2;
    [self.label2 setText:string2];
    [view addSubview:self.label2];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -30, 110, 60, 1.9)];
    separatorLineView1.backgroundColor = [UIColor whiteColor];
    [view addSubview:separatorLineView1];
    
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
  //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    NSString *queryStringw1 = @"select * from weather.forecast where woeid=2446726";
    NSString *queryString2 = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\",\"SPY\",\"UUP\",\"VCSY\",\"GPRO\",\"VXX\",\"UPL\",\"UGAZ\",\"XLE\",\"^XOI\")";
    
    w1results = [yql query:queryStringw1];
    dayYQL = [w1results valueForKeyPath:@"query.results.channel.item.forecast.day"];
    textYQL = [w1results valueForKeyPath:@"query.results.channel.item.forecast.text"];
    
    resultsYQL = [yql query:queryString2];
    symYQL = [resultsYQL valueForKeyPath:@"query.results.quote.symbol"];
    fieldYQL = [resultsYQL valueForKeyPath:@"query.results.quote.LastTradePriceOnly"];
    changeYQL = [resultsYQL valueForKeyPath:@"query.results.quote.Change"];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
}

@end
