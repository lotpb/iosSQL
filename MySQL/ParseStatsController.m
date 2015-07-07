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
    NSMutableArray *_statHeaderItems, *_feedItems, *_feedLeadActive, *_feedCustActive, *_feedAppToday, *_feedWinSold;
    NSDictionary *dict, *w1results, *results1, *results2, *results3, *results4, *results5, *results6, *results7, *results8, *results9, *results10, *results11;
    NSString *amount;
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
    self.listTableView.rowHeight = 30;
    self.listTableViewLeft.rowHeight = 30;
    self.listTableViewRight.rowHeight = 30;
    //UITableViewAutomaticDimension;
    //[self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
      /*[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(reloadDatas:) userInfo:nil repeats: YES];*/
    
    //| ---------------------------end----------------------------------
    
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseStatConnection *parseConnection = [[ParseStatConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseTodayLeads]; [parseConnection parseActiveLeads];
       [parseConnection parseActiveCust]; [parseConnection parseApptTodayLeads];
       [parseConnection parseWindowSold];
    }
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
    
    if ([tableView isEqual:self.listTableView])
    return 2;
    else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 10;
    else if (section == 1)
        return 6;
    else if ([tableView isEqual:self.listTableViewLeft])
        return 8;
    else if ([tableView isEqual:self.listTableViewRight])
        return 8;
    
    return 1;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     if ([tableView isEqual:self.listTableView]) {
         
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.accessoryType = UITableViewCellAccessoryNone;
    [myCell.textLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
    [myCell.detailTextLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
    [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
         
    if (indexPath.section == 0) {
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -155, 5, 77, 17)];
        [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
        [myCell.detailTextLabel setFont:CELL_MEDFONT(IPAD_FONTSIZE)];
        [label1 setFont:CELL_FONT(CELL_FONTSIZE)];
        [label1 setBackgroundColor:[UIColor whiteColor]];
        label1.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row == 0) {
            if (![[[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
            
        } else if (indexPath.row == 1) {
            if (![[[[results2 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results2 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results2 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results2 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
            
        } else if (indexPath.row == 2) {
            if (![[[[results3 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results3 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results3 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results3 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 3) {
            if (![[[[results4 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results4 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results4 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results4 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 4) {
            if (![[[[results5 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results5 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results5 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results5 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 5) {
            if (![[[[results6 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results6 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results6 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results6 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 6) {
            if (![[[[results7 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results7 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results7 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results7 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 7) {
            if (![[[[results8 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results8 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results8 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results8 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 8) {
            if (![[[[results9 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results9 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results9 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results9 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        } else if (indexPath.row == 9) {
            if (![[[[results10 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"] containsString:@"-"]) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            }
            myCell.textLabel.text = [[[results10 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"symbol"];
            myCell.detailTextLabel.text = [[[results10 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
            label1.text = [[[results10 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
            [myCell.contentView addSubview:label1];
            
            return myCell;
        }
        
    } else if (indexPath.section == 1) {
        
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
            
            myCell.textLabel.text = @"City";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.location"] objectForKey:@"city"];
            
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Last Update";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel"] objectForKey:@"lastBuildDate"];
            
            return myCell;
        }
    }
        
    } else if ([tableView isEqual:self.listTableViewLeft]) {
        
        static NSString *CellIdentifier1 = IDCELL;
        UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        
        if (myCell == nil)
            myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.textLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
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
        [myCell.textLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
        [myCell.detailTextLabel setFont:CELL_FONT(IPADSTATFONTSIZE)];
        [myCell.detailTextLabel setTextColor:[UIColor blackColor]];//STATTEXTCOLOR];
        
          if (indexPath.row == 0) {
            myCell.textLabel.text = @"Customers Today";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 1) {
            
            myCell.textLabel.text = @"Customers Yesterday";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"Customers Active";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedCustActive.count];
            return myCell;
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"Customers Year";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 4) {
            
            myCell.textLabel.text = @"Customers Avg";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"Customers High";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 6) {
            
            myCell.textLabel.text = @"Customers Low";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
            return myCell;
        } else if (indexPath.row == 7) {
            
            myCell.textLabel.text = @"Windows Sold";
            myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedWinSold.count];
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section {
    NSString *footerTitle;
    if ([tableView isEqual:self.listTableView]) {
    if (section == 0)
        footerTitle = @"Weather";
    if (section == 1)
        footerTitle = @"Customer Info";
    }
    return footerTitle;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSString *newString = @"Statistics";
    NSString *newString1 = @"SALES";
    NSString *newString2 = [[_statHeaderItems objectAtIndex:1] objectForKey:@"Amount"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.frame.size.width, 0)];
    self.listTableView.tableHeaderView = view; //makes header move with tablecell
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.frame.size.width, MAINHEADHEIGHT)];
    
    UIImage *image = [UIImage imageNamed:@"background"];
    imageHolder.image = image;
    imageHolder.contentMode = UIViewContentModeScaleAspectFill;
    imageHolder.clipsToBounds = true;
    [view addSubview:imageHolder];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -45, 3, 90, 45)];
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
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -25, 75, 50, 45)];
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:[UIFont fontWithName:@"Avenir-Black" size:16]];
    [label1 setTextColor:[UIColor greenColor]];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -30, 110, 60, 1.9)];
    separatorLineView1.backgroundColor = [UIColor whiteColor];
    [view addSubview:separatorLineView1];
    
    UILabel *textframe = [[UILabel alloc] initWithFrame:CGRectMake(self.listTableView.frame.size.width /2 -70, 115, 140, 45)];
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
    NSString *queryStringw1 = @"select * from weather.forecast where woeid=2446726";
    NSString *queryString1 = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\")";
    NSString *queryString2 = @"select * from yahoo.finance.quote where symbol in (\"SPY\")";
    NSString *queryString3 = @"select * from yahoo.finance.quote where symbol in (\"UUP\")";
    NSString *queryString4 = @"select * from yahoo.finance.quote where symbol in (\"VCSY\")";
    NSString *queryString5 = @"select * from yahoo.finance.quote where symbol in (\"GPRO\")";
    NSString *queryString6 = @"select * from yahoo.finance.quote where symbol in (\"UPL\")";
    NSString *queryString7 = @"select * from yahoo.finance.quote where symbol in (\"XLE\")";
    NSString *queryString8 = @"select * from yahoo.finance.quote where symbol in (\"UGAZ\")";
    NSString *queryString9 = @"select * from yahoo.finance.quote where symbol in (\"VXX\")";
    NSString *queryString10 = @"select * from yahoo.finance.quote where symbol in (\"^XOI\")";
    //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    NSString *queryString11 = @"select * from yahoo.finance.quote where symbol in (\"YHOO\",\"AAPL\",\"GOOG\",\"SPY\")";
    
    w1results = [yql query:queryStringw1];
    results1 = [yql query:queryString1]; //nasdaq
    results2 = [yql query:queryString2]; //spy
    results3 = [yql query:queryString3]; //uup
    results4 = [yql query:queryString4]; //vcsy
    results5 = [yql query:queryString5]; //GPRO
    results6 = [yql query:queryString6]; //UPL
    results7 = [yql query:queryString7]; //UPL
    results8 = [yql query:queryString8]; //UPL
    results9 = [yql query:queryString9]; //UPL
    results10 = [yql query:queryString10]; //UPL
    
    results11 = [yql query:queryString11]; //Many
    //NSLog(@"%@", results11);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
}

@end
