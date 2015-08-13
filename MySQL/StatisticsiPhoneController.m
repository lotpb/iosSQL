//
//  StatisticsiPhoneController.m
//  MySQL
//
//  Created by Peter Balsamo on 4/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "StatisticsiPhoneController.h"

@interface StatisticsiPhoneController ()
{
    StatCustModel *_StatCustModel; StatLeadModel *_StatLeadModel;
    NSMutableArray *_statHeaderItems, *_feedCustItems, *_feedLeadItems, *_feedItems, *_feedLeadActive, *_feedCustActive, *_feedAppToday, *_feedWinSold, *symYQL, *fieldYQL, *changeYQL, *dayYQL, *textYQL, *humidityYQL;
    NSDictionary *dict, *w1results, *resultsYQL;
    NSString *amount;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation StatisticsiPhoneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//fix
    self.title = NSLocalizedString(@"Statistics", nil);
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.backgroundColor = STATBACKCOLOR;
    self.listTableView.rowHeight = 30;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     //   self.listTableViewLeft.rowHeight = 30;
     //   self.listTableViewRight.rowHeight = 30;
     //   self.listTableViewLeft1.rowHeight = 30;
     //   self.listTableViewRight1.rowHeight = 30;
    }
 // UITableViewAutomaticDimension;
 //[self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
  //self.listTableView.estimatedRowHeight = 44.0;
    
    [self YahooFinanceLoad];
    
    //| -------------------------Timer----------------------------------
    /*[NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(reloadDatas:) userInfo:nil repeats: YES];*/
    
    //| ---------------------------end----------------------------------
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseStatConnection *parseConnection = [[ParseStatConnection alloc]init];
        parseConnection.delegate = (id)self;
        
        [parseConnection parseTodayLeads]; [parseConnection parseActiveLeads];
        [parseConnection parseActiveCust]; [parseConnection parseApptTodayLeads];
        [parseConnection parseWindowSold];
    } else {
        [self itemsStatHeaderDownloaded];
        
        _feedCustItems = [[NSMutableArray alloc] init]; _StatCustModel = [[StatCustModel alloc] init];
        _StatCustModel.delegate = self; [_StatCustModel downloadItems];
        
        _feedLeadItems = [[NSMutableArray alloc] init]; _StatLeadModel = [[StatLeadModel alloc] init];
        _StatLeadModel.delegate = self; [_StatLeadModel downloadItems];
        
        tableLeadData = [[NSMutableArray alloc]initWithObjects:SLNAME1, SLNAME2, SLNAME3, SLNAME4, SLNAME5, SLNAME6, SLNAME7, SLNAME8, nil];
        tableCustData = [[NSMutableArray alloc]initWithObjects:SCNAME1, SCNAME2, SCNAME3, SCNAME4, SCNAME5, SCNAME6, SCNAME7, SCNAME8, nil];
    }
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - mySQL Delegate
-(void)itemsStatHeaderDownloaded {
    amount = @"Amount";
    _statHeaderItems = [[NSMutableArray alloc] init];
    NSData *jsonData = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:@"http://localhost:8888/iosStatisticHeader.php"]];
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dataDict in jsonObjects) {
        NSString *strAmount = [dataDict objectForKey:@"Amount"];
        dict = [NSDictionary dictionaryWithObjectsAndKeys:
                strAmount, amount, nil];
        [_statHeaderItems addObject:dict];
    }
}

-(void)itemsCustDownloaded:(NSMutableArray *)itemsCust {
    _feedCustItems = itemsCust;
    [self.listTableView reloadData];
}

-(void)itemsLeadDownloaded:(NSMutableArray *)itemsLead {
    _feedLeadItems = itemsLead;
    [self.listTableView reloadData];
}

#pragma mark - Parse Delegate
- (void)parseLeadTodayloaded:(NSMutableArray *)leadItem {
    _feedItems = leadItem;
    [self.listTableView reloadData];
}

- (void)parseLeadActiveloaded:(NSMutableArray *)leadItem {
    _feedLeadActive = leadItem;
    [self.listTableView reloadData];
}

- (void)parseCustActiveloaded:(NSMutableArray *)leadItem {
    _feedCustActive = leadItem;
    [self.listTableView reloadData];
}

- (void)parseLeadApptTodayloaded:(NSMutableArray *)leadItem {
    _feedAppToday = leadItem;
    [self.listTableView reloadData];
}

- (void)parseWindowSoldloaded:(NSMutableArray *)leadItem {
    _feedWinSold = leadItem;
    [self.listTableView reloadData];
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
    } else {
        [_StatLeadModel downloadItems];
        [_StatCustModel downloadItems];
    }
    [self.listTableView reloadData];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    //    [self.listTableViewLeft reloadData]; [self.listTableViewRight reloadData];
    //    [self.listTableViewLeft1 reloadData]; [self.listTableViewRight1 reloadData];

    }
    
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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 1;
    } else {
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {

            if (section == 0)
                return 10;
            else if (section == 1)
                return 6;
            else if (section == 2)
                return 6;
            else if (section == 3)
                return 8;
            else if (section == 4)
                return 8;
        } else {
            if (section == 3)
                return _feedLeadItems.count;
            else if (section == 4)
                return _feedCustItems.count;
        }
    return 0;
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width -155, 8, 77, 17)];
    [label1 setBackgroundColor:[UIColor whiteColor]];
    label1.textAlignment = NSTextAlignmentRight;
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    myCell.accessoryType = UITableViewCellAccessoryNone;
    
    [myCell.textLabel setFont:CELL_FONT(IPHONEFONT12)];
    [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT12)];
    [myCell.detailTextLabel setTextColor:STATTEXTCOLOR];
    [label1 setFont:CELL_FONT(IPHONEFONT14)];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if (([[changeYQL objectAtIndex:0] containsString:@"-"]) || ([[changeYQL objectAtIndex:0] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:100.0 blue:0.0 alpha:1.0]];//LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:0];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:0];
           [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
           [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:0];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 1) {
            
            if (([[changeYQL objectAtIndex:1] containsString:@"-"]) || ([[changeYQL objectAtIndex:1] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:1];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:1];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
           [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:1];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 2) {
            
            if (([[changeYQL objectAtIndex:2] containsString:@"-"]) || ([[changeYQL objectAtIndex:2] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:2] ;
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:2];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:2] ;
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 3) {
            
            if (([[changeYQL objectAtIndex:3] containsString:@"-"]) || ([[changeYQL objectAtIndex:3] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:3];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:3];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:3];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 4) {
            
            if (([[changeYQL objectAtIndex:4] containsString:@"-"]) || ([[changeYQL objectAtIndex:4] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:4];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:4];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:4];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 5) {
            
            if (([[changeYQL objectAtIndex:5] containsString:@"-"]) || ([[changeYQL objectAtIndex:5] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:5];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:5];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:5];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 6) {
            
            if (([[changeYQL objectAtIndex:6] containsString:@"-"]) || ([[changeYQL objectAtIndex:6] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:6];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:6];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:6];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 7) {
            
            if (([[changeYQL objectAtIndex:7] containsString:@"-"]) || ([[changeYQL objectAtIndex:7] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:7];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:7];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:7];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 8) {
            
            if (([[changeYQL objectAtIndex:8] containsString:@"-"]) || ([[changeYQL objectAtIndex:8] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:8];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:8];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:8];
            [myCell.contentView addSubview:label1];
            return myCell;
        } else if (indexPath.row == 9) {
            
            if (([[changeYQL objectAtIndex:9] containsString:@"-"]) || ([[changeYQL objectAtIndex:9] isEqual:[NSNull null]] )) {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR3];
            } else {
                [myCell.detailTextLabel setBackgroundColor:LINECOLOR1];
            }
            myCell.textLabel.text = [symYQL objectAtIndex:9];
            myCell.detailTextLabel.text = [changeYQL objectAtIndex:9];
            [myCell.detailTextLabel setFont:CELL_MEDFONT(IPHONEFONT14)];
            [myCell.detailTextLabel setTextColor:[UIColor whiteColor]];
            label1.text = [fieldYQL objectAtIndex:9];
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
            
            myCell.textLabel.text = @"Humidity";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.atmosphere"] objectForKey:@"humidity"];
            return myCell;
        } else if (indexPath.row == 5) {
            
            myCell.textLabel.text = @"City";
            myCell.detailTextLabel.text = [[w1results valueForKeyPath:@"query.results.channel.location"] objectForKey:@"city"];
            return myCell;
        }
        
     } else if (indexPath.section == 2) {
         
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
         
     }  else if (indexPath.section == 3) {
         /*
          CustLocation *item;
          item = _feedLeadItems[indexPath.row];
          
          myCell.textLabel.text = [tableLeadData objectAtIndex:indexPath.row];
          myCell.detailTextLabel.text = item.leadNo;
          
          return myCell; */
         
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

     } else if (indexPath.section == 4) {
         
         /*
          CustLocation *item;
          item = _feedCustItems[indexPath.row];
          
          myCell.textLabel.text = [tableCustData objectAtIndex:indexPath.row];
          myCell.detailTextLabel.text = item.custNo;
          
          return myCell; */
         
         if (indexPath.row == 0) {
             
             myCell.textLabel.text = @"Customers Today";
             myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
             return myCell;
         } else if (indexPath.row == 1) {
             
             myCell.textLabel.text = @"Customers Yesterday";
             myCell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) _feedItems.count];
             return myCell;
         } else if (indexPath.row == 2) {
             
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
    if (section == 0)
        return MAINHEADHEIGHT;
    else if (section == 1)
        return 5;
    else if (section == 2)
        return 5;
    else if (section == 3)
        return 5;
    else if (section == 4)
        return 5;
    
    return 0;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:
(NSInteger)section {
    NSString *footerTitle;
    if (section == 0)
        footerTitle = @"*";
    
    return footerTitle;
} */

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = @"Statistics";
    NSString *newString1 = @"SALES";
    NSString *newString2 = @"$100,000";//[[_statHeaderItems objectAtIndex:1] objectForKey:@"Amount"];
    
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

#pragma mark - Yahoo Finance
-(void)YahooFinanceLoad {
    
    yql = [[YQL alloc] init];
    //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    NSString *queryString1 = @"select * from weather.forecast where woeid=2446726";
    NSString *queryString2 = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\",\"SPY\",\"UUP\",\"VCSY\",\"GPRO\",\"VXX\",\"UPL\",\"UGAZ\",\"XLE\",\"^XOI\")";
    
    w1results = [yql query:queryString1];
    dayYQL = [w1results valueForKeyPath:@"query.results.channel.item.forecast.day"];  //5 day forcast Array
    textYQL = [w1results valueForKeyPath:@"query.results.channel.item.forecast.text"]; //5 day forcast Array
    
    resultsYQL = [yql query:queryString2];
    symYQL = [resultsYQL valueForKeyPath:@"query.results.quote.symbol"];
    fieldYQL = [resultsYQL valueForKeyPath:@"query.results.quote.LastTradePriceOnly"]; //Array
    changeYQL = [resultsYQL valueForKeyPath:@"query.results.quote.Change"]; //Array
    //NSLog(@"%@ %@", fieldYQL, symYQL );
}

@end
