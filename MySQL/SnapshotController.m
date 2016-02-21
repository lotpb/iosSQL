//
//  SnapshotController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/30/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//


#import "SnapshotController.h"
//#import <EventKit/EventKit.h>
//#import <EventKitUI/EventKitUI.h>

@interface SnapshotController () //<EKEventEditViewDelegate>
{
    PFObject *imageObject;
    PFFile *imageFile;
    //UIButton *playButton;
    NSString *resultDateDiff;
    UILabel *title, *datetitle;
    NSMutableArray *_feedItems, *_feedItems2, *_feedItems3, *_feedItems4, *_feedItems5, *_feedItems6;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic) EKEventStore *eventStore;
//@property (strong, nonatomic) EKCalendar *defaultCalendar;
@property (strong, nonatomic) NSMutableArray *eventsList;

@end

@implementation SnapshotController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Snapshot", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = ROW_HEIGHT;
    self.listTableView.backgroundColor = LIGHTGRAYCOLOR;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//fix
    
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //AudioServicesPlayAlertSound(1352);
    
    //[self addEvent:self];

/*
*******************************************************************************************
Parse.com
*******************************************************************************************
*/
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseUser]; [parseConnection parseJobPhoto];
        [parseConnection parseNews]; [parseConnection parseSalesman];
        [parseConnection parseEmployee]; [parseConnection parseBlog];
    }
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];;
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = LIGHTGRAYCOLOR;
    [refreshControl setTintColor:DARKGRAYCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = DARKGRAYCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;

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
        [parseConnection parseUser]; [parseConnection parseJobPhoto];
        [parseConnection parseNews]; [parseConnection parseSalesman];
        [parseConnection parseEmployee]; [parseConnection parseBlog];
    }

    [self.listTableView reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:KEY_DATEREFRESH];
            NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:DARKGRAYCOLOR forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }
        [refreshControl endRefreshing];
    }
}

#pragma mark - ParseDelegate
- (void)parseUserloaded:(NSMutableArray *)userItem {
    _feedItems = userItem;
    [self.listTableView reloadData];
}

- (void)parseJobPhotoloaded:(NSMutableArray *)jobphotoItem {
    _feedItems2 = jobphotoItem;
    [self.listTableView reloadData];
}

- (void)parseNewsloaded:(NSMutableArray *)newsItem {
    _feedItems3 = newsItem;
    [self.listTableView reloadData];
}

- (void)parseSalesmanloaded:(NSMutableArray *)saleItem {
    _feedItems4 = saleItem;
    [self.listTableView reloadData];
}

- (void)parseEmployeeloaded:(NSMutableArray *)employItem {
    _feedItems5 = employItem;
    [self.listTableView reloadData];
}

- (void)parseBlogloaded:(NSMutableArray *)blogItem {
    _feedItems6 = blogItem;
    [self.listTableView reloadData];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 140;
    if (indexPath.section == 0) {
        //CGFloat result = 140;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
            case 2:
            {
                result = 44;
                break;
            }
        }
        return result;
        
    } else if (indexPath.section == 1) {
        CGFloat result = 85;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 2) {
      
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 3) {
        
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
            case 2:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 4) {
     
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 5) {
  
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 6) {
        
        CGFloat result = 85;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 7) {
        
        CGFloat result = 85;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    } else if (indexPath.section == 8) {
        
        CGFloat result = 85;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
        }
        return result;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 9;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else if (section == 3) {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(120.0, 120.0);
    [myCell.collectionView setCollectionViewLayout:flowLayout];
    

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_MEDFONT(IPADFONT18)];
    } else {
        [myCell.textLabel setFont:CELL_MEDFONT(IPHONEFONT18)];
    }
    
    [title setFont:DETAILFONT(IPHONEFONT18)];
    [datetitle setFont:DETAILFONT(IPHONEFONT14)];
    
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(15, 23, myCell.frame.size.width - 15, 50)];
    datetitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, myCell.frame.size.width - 15, 20)];
    
    myCell.collectionView.delegate = nil;
    myCell.collectionView.dataSource = nil;
    myCell.collectionView.backgroundColor = [UIColor whiteColor];
    [myCell.collectionView setContentOffset:CGPointZero animated:NO];
    myCell.accessoryType = UITableViewCellAccessoryNone;
    myCell.textLabel.text = nil;
 
    title.text = nil;
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    
    datetitle.text = nil;
    datetitle.textColor = [UIColor lightGrayColor];
    datetitle.backgroundColor = [UIColor clearColor];
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
//------------------------------------------------------------------------------
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {

            myCell.textLabel.text = [NSString stringWithFormat:@"Top News %ld", (unsigned long)_feedItems3.count];
            myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.tag = 0;
            
            [myCell.collectionView reloadData];

            return myCell;
            
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"myNews";

            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 1) {

        if (indexPath.row == 0) {

            myCell.textLabel.text = @"Top News Story";

            return myCell;
            
        } else if (indexPath.row == 1) {

            [myCell.collectionView reloadData];

            title.numberOfLines = 2;
            title.tag = 1;
            [myCell.contentView addSubview:title];
            
            datetitle.numberOfLines = 1;
            datetitle.tag = 2;
            //[myCell bringSubviewToFront:datetitle];
            [myCell.contentView addSubview:datetitle];

            NSDate *creationDate = [[_feedItems3 objectAtIndex:0] createdAt];
            NSDate *datetime1 = creationDate;
            NSDate *datetime2 = [NSDate date];
            double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
            resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];

            title = (UILabel *)[myCell viewWithTag:1];
            datetitle = (UILabel *)[myCell viewWithTag:2];
            
            title.text = [[_feedItems3 firstObject] objectForKey:@"newsTitle"];
            datetitle.text = [NSString stringWithFormat:@"%@, %@",[[_feedItems3 firstObject] objectForKey:@"newsDetail"], resultDateDiff];
            
            return myCell;
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {

            myCell.textLabel.text = [NSString stringWithFormat:@"Top Jobs %ld", (unsigned long)_feedItems2.count];
            myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.tag = 1;
          
           [myCell.collectionView reloadData];
 
            title.tag = 61;
            datetitle.tag = 62;
            title = (UILabel *)[myCell viewWithTag:61];
            datetitle = (UILabel *)[myCell viewWithTag:62];

            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Users %ld", (unsigned long)_feedItems.count];
            myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(100.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.tag = 2;

            [myCell.collectionView reloadData];
            
            return myCell;
            
        } else if (indexPath.row == 2) {
            
            myCell.textLabel.text = @"myUser";
            
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Salesman %ld", (unsigned long)_feedItems4.count];
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(80.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            
            title.tag = 81;
            datetitle.tag = 82;
            title = (UILabel *)[myCell viewWithTag:81];
            datetitle = (UILabel *)[myCell viewWithTag:82];
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.tag = 3;
            [myCell.collectionView reloadData];

            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 5) {
        
        if (indexPath.row == 0) {
            
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Employee %ld", (unsigned long)_feedItems5.count];
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryNone;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(80.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            
            title = (UILabel *)[myCell viewWithTag:1];
            datetitle = (UILabel *)[myCell viewWithTag:2];
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;

            myCell.collectionView.tag = 4;
            [myCell.collectionView reloadData];

            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 6) {
        
        if (indexPath.row == 0) {

            myCell.textLabel.text = @"Top Blog Story";
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            //myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            title.numberOfLines = 2;
            title.tag = 61;
            [myCell.contentView addSubview:title];
            
            datetitle.numberOfLines = 1;
            datetitle.tag = 62;
            [myCell.contentView addSubview:datetitle];
            
            NSDate *creationDate = [[_feedItems6 objectAtIndex:0] createdAt];
            NSDate *datetime1 = creationDate;
            NSDate *datetime2 = [NSDate date];
            double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
            resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
            
            datetitle = (UILabel *)[myCell viewWithTag:62];
            datetitle.text = [NSString stringWithFormat:@"%@, %@",[[_feedItems6 firstObject] objectForKey:@"PostBy"], resultDateDiff];
            
            title = (UILabel *)[myCell viewWithTag:61];
            title.text = [[_feedItems6 firstObject] objectForKey:@"Subject"];
            
            return myCell;
        }
        //------------------------------------------------------------------------------
    } else if (indexPath.section == 7) {
        
        if (indexPath.row == 0) {

            myCell.textLabel.text = @"Top Notification";
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            //myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
            UILocalNotification *localNotification = [localNotifications firstObject];
            
            title.numberOfLines = 2;
            title.tag = 81;
            [myCell.contentView addSubview:title];
            
            datetitle.numberOfLines = 1;
            datetitle.tag = 82;
            [myCell.contentView addSubview:datetitle];
            
            title = (UILabel *)[myCell viewWithTag:81];
            datetitle = (UILabel *)[myCell viewWithTag:82];
            
            if ([[[UIApplication sharedApplication] scheduledLocalNotifications] count] == 0) {
                datetitle.text = @"";
                title.text = @"You have no pending notifications :)";
            } else {
                datetitle.text = [localNotification.fireDate description];
                title.text = localNotification.alertBody;
            }
            
            return myCell;
        }
        //------------------------------------------------------------------------------
    } else if (indexPath.section == 8) {
        
        if (indexPath.row == 0) {

            myCell.textLabel.text = @"Top Calander Event";
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            //myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            //self.eventStore = [[EKEventStore alloc] init];
            self.eventsList = [[NSMutableArray alloc] initWithCapacity:0];

            title.numberOfLines = 2;
            title.tag = 91;
            [myCell.contentView addSubview:title];
            
            datetitle.numberOfLines = 1;
            datetitle.tag = 92;
            [myCell.contentView addSubview:datetitle];
            
            title = (UILabel *)[myCell viewWithTag:91];
            datetitle = (UILabel *)[myCell viewWithTag:92];
            datetitle.text = [[self.eventsList firstObject] title];
            
            if (self.eventsList.count == 0) {
                title.text = @"You have no pending events :)";
            } else {
                title.text = [[self.eventsList firstObject] title];
            }
            
            return myCell;
        }
        //------------------------------------------------------------------------------
    }
    return 0;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == 0) {
        return [_feedItems3 count];
    } else if (collectionView.tag == 1) {
        return [_feedItems2 count];
    } else if (collectionView.tag == 2) {
        return [_feedItems count];
    } else if (collectionView.tag == 3) {
        return [_feedItems4 count];
    } else if (collectionView.tag == 4) {
        return [_feedItems5 count];
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    JobViewCell *cell = (JobViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
    celltitle.font = [UIFont systemFontOfSize:12];
    //celltitle.adjustsFontSizeToFitWidth = YES;
    celltitle.clipsToBounds = YES;
    celltitle.textColor = [UIColor blackColor];
    celltitle.backgroundColor = [UIColor whiteColor];
    celltitle.textAlignment = NSTextAlignmentCenter;
//------------------------------------------------------------------------------
    if (collectionView.tag == 0) {

        imageObject = [_feedItems3 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        
        cell.loadingSpinner.hidden = NO;
        [cell.loadingSpinner startAnimating];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                
                cell.user2ImageView.backgroundColor = [UIColor blackColor];
                cell.user2ImageView.image = [UIImage imageWithData:data];
                
                [cell.loadingSpinner stopAnimating];
                cell.loadingSpinner.hidden = YES;
            }
        }];
        
        celltitle.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
        [cell.contentView addSubview:celltitle];
        
        return cell;
        
        //------------------------------------------------------------------------------
    } else if (collectionView.tag == 1) {
       
         imageObject = [_feedItems2 objectAtIndex:indexPath.row];
         imageFile = [imageObject objectForKey:@"imageFile"];
         
         cell.loadingSpinner.hidden = NO;
        [cell.loadingSpinner startAnimating];
         
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
             if (!error) {
                 cell.user2ImageView.image = [UIImage imageWithData:data];
                [cell.loadingSpinner stopAnimating];
                 cell.loadingSpinner.hidden = YES;
             }
         }];

         celltitle.text = [[_feedItems2 objectAtIndex:indexPath.row] objectForKey:@"imageGroup"];
         [cell.contentView addSubview:celltitle];
         
         return cell;
//------------------------------------------------------------------------------
     } else if (collectionView.tag == 2) {
         
         imageObject = [_feedItems objectAtIndex:indexPath.row];
         imageFile = [imageObject objectForKey:@"imageFile"];
         
         cell.loadingSpinner.hidden = NO;
        [cell.loadingSpinner startAnimating];
         
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
             if (!error) {
                 cell.user2ImageView.image = [UIImage imageWithData:data];
                [cell.loadingSpinner stopAnimating];
                 cell.loadingSpinner.hidden = YES;
             }
         }];

         celltitle.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
         [cell.contentView addSubview:celltitle];
         
         return cell;
     } else if (collectionView.tag == 3) {
         
         imageObject = [_feedItems4 objectAtIndex:indexPath.row];
         imageFile = [imageObject objectForKey:@"imageFile"];
         
         cell.loadingSpinner.hidden = NO;
         [cell.loadingSpinner startAnimating];
         
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
             if (!error) {
                 cell.user2ImageView.image = [UIImage imageWithData:data];
                 [cell.loadingSpinner stopAnimating];
                 cell.loadingSpinner.hidden = YES;
             }
         }];
         
         celltitle.text = [[_feedItems4 objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
         [cell.contentView addSubview:celltitle];
         
         return cell;
     } else if (collectionView.tag == 4) {
         
         imageObject = [_feedItems5 objectAtIndex:indexPath.row];
         imageFile = [imageObject objectForKey:@"imageFile"];
         
         cell.loadingSpinner.hidden = NO;
         [cell.loadingSpinner startAnimating];
         
         [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
             if (!error) {
                 
                 cell.user2ImageView.image = [UIImage imageWithData:data];
                 [cell.loadingSpinner stopAnimating];
                 cell.loadingSpinner.hidden = YES;
             }
         }];

         celltitle.text = [NSString stringWithFormat:@"%@ %@ %@",[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"First"],[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Last"], [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Company"]];
         [cell.contentView addSubview:celltitle];
         
         return cell;
     } else if (collectionView.tag == 13) {
            [self performSegueWithIdentifier:@"newssnapSegue" sender:self];
         
         return cell;
     }
    return nil;
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
    self.searchController.searchBar.scopeButtonTitles = @[USERSCOPE];
    self.searchController.hidesBottomBarWhenPushed = SHIDEBAR;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active){
        
        return;
    }
    
    NSString *searchText = searchController.searchBar.text;
    if(searchText.length == 0)
        isFilltered = NO;
    else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(PFObject *string in _feedItems)
            
        {
            NSRange stringRange;
            if (self.searchController.searchBar.selectedScopeButtonIndex == 0) {
                stringRange = [[string objectForKey:@"username"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 1) {
                stringRange = [[string objectForKey:@"email"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            }
            
            if (self.searchController.searchBar.selectedScopeButtonIndex == 2) {
                stringRange = [[string objectForKey:@"phone"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            }
            
            if(stringRange.location != NSNotFound)
                [filteredString addObject:string];
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            [self performSegueWithIdentifier:@"topnewsSegue" sender:self];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"topuserSegue" sender:self];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"topjobsegue" sender:self];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        if (collectionView.tag == 0) {
        
        imageObject = [_feedItems3 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.selectedImage = [UIImage imageWithData:data];
                //self.selectedImage = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"imageFile"];

                self.imageDetailurl = imageFile.url;
                self.selectedObjectId = [[_feedItems3 objectAtIndex:indexPath.row] objectId];
                
                NSDate *creationDate = [[_feedItems3 objectAtIndex:indexPath.row] createdAt];;
                NSDate *datetime1 = creationDate;
                NSDate *datetime2 = [NSDate date];
                double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
                resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
                self.selectedCreate = resultDateDiff;
                
                self.selectedTitle = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
                self.selectedEmail = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsDetail"];
                self.selectedPhone = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"storyText"];
                [self performSegueWithIdentifier:@"newssnapSegue" sender:self];
            }
        }];
    }
 else if (collectionView.tag == 1) {
        
        imageObject = [_feedItems2 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.selectedImage = [UIImage imageWithData:data];
                [self performSegueWithIdentifier:@"showsnapSegue" sender:self];
            }
        }];
    } else if (collectionView.tag == 2) {
        
        imageObject = [_feedItems objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.selectedImage = [UIImage imageWithData:data];
                static NSDateFormatter *formatter = nil;
                if (formatter == nil) {
                    NSDate *updated = [[_feedItems objectAtIndex:indexPath.row] createdAt];
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MMM dd, yyyy"];
                    NSString *createAtString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updated]];
                    self.selectedCreate = createAtString; }
                self.selectedObjectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
                self.selectedName = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
                self.selectedEmail = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"email"];
                self.selectedPhone = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"phone"];
                [self performSegueWithIdentifier:@"userdetailSegue" sender:self];
            }
        }];
    } else if (collectionView.tag == 3) {
        
        imageObject = [_feedItems4 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.selectedImage = [UIImage imageWithData:data];
                
                self.selectedObjectId = [[_feedItems4 objectAtIndex:indexPath.row] objectId];
                self.selectedCreate = [[_feedItems4 objectAtIndex:indexPath.row] objectForKey:@"Active"];
                self.selectedPhone = [[_feedItems4 objectAtIndex:indexPath.row] objectForKey:@"SalesNo"];
                self.selectedName = [[_feedItems4 objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
                [self performSegueWithIdentifier:@"snapsalesSegue" sender:self];
            }
        }];
        
    } else if (collectionView.tag == 4) {
        
        self.selectedObjectId = [[_feedItems5 objectAtIndex:indexPath.row] objectId];
        self.selectedPhone = [[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"EmployeeNo"]stringValue];
        self.selectedCreate = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Email"];
        self.selectedName = [NSString stringWithFormat:@"%@ %@ %@",[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"First"],[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Last"], [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Company"]];
        self.selectedTitle = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Last"];
        self.selectedEmail = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Street"];
        self.imageDetailurl = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"City"];
        
        self.selectedState = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"State"];
        self.selectedZip = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Zip"];
        self.selectedAmount = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Title"];
        self.selected11 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"HomePhone"];
        self.selected12 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"WorkPhone"];
        self.selected13 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"CellPhone"];
        self.selected14 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"SS"];
        self.selected15 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Middle"];
        self.selected21 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Email"];
        self.selected22 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Department"];
        self.selected23 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Title"];
        self.selected24 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Manager"];
        self.selected25 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Country"];
        self.selected16 = [NSString stringWithFormat:@"%@",[[_feedItems5 objectAtIndex:indexPath.row] updatedAt]];
        self.selected26 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"First"];
        self.selected27 = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Company"];
        self.selectedComments = [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Comments"];
        self.selectedActive = [[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Active"]stringValue];
        
        [self performSegueWithIdentifier:@"snapemploySegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"newssnapSegue"]) {
        NewsDetailController *detailVC = segue.destinationViewController;
        detailVC.objectId = self.selectedObjectId;
        detailVC.newsTitle = self.selectedTitle;
        detailVC.newsDetail = self.selectedEmail;
        detailVC.newsDate = self.selectedCreate;
        detailVC.newsStory = self.selectedPhone;
        detailVC.image = self.selectedImage;
        detailVC.imageDetailurl = self.imageDetailurl;
        
    } else if ([[segue identifier] isEqualToString:@"userdetailSegue"]) {
        UserDetailController *detailVC = segue.destinationViewController;
        detailVC.objectId = self.selectedObjectId;
        detailVC.username = self.selectedName;
        detailVC.create = self.selectedCreate;
        detailVC.email = self.selectedEmail;
        detailVC.phone = self.selectedPhone;
        detailVC.userimage = self.selectedImage;
        
    } else if ([[segue identifier] isEqualToString:@"showsnapSegue"]) {
        CollectionDetailController *detailVC = segue.destinationViewController;
        detailVC.image = self.selectedImage;

    } else if ([[segue identifier] isEqualToString:@"snapsalesSegue"]) {
         NewDataDetail *detailVC = segue.destinationViewController;
         detailVC.formController = TNAME8;
         detailVC.formStatus = @"Edit";
         detailVC.objectId = self.selectedObjectId;
         detailVC.frm11 = self.selectedCreate;
         detailVC.frm12 = self.selectedPhone;
         detailVC.frm13 = self.selectedName;
         detailVC.image = self.selectedImage;
        
    } else if ([[segue identifier] isEqualToString:@"snapemploySegue"]) {
        LeadDetailViewControler *detailVC = segue.destinationViewController;
        detailVC.formController = TNAME4;
        detailVC.objectId = self.selectedObjectId;
        detailVC.leadNo = self.selectedPhone;
        detailVC.date = self.selectedCreate;
        detailVC.name = self.selectedName;
        detailVC.custNo = self.selectedTitle;
        detailVC.address = self.selectedEmail;
        detailVC.city = self.imageDetailurl;
        detailVC.state = self.selectedState;
        detailVC.zip = self.selectedZip;
        detailVC.amount = self.selectedAmount;
        detailVC.tbl11 = self.selected11;
        detailVC.tbl12 = self.selected12;
        detailVC.tbl13 = self.selected13;
        detailVC.tbl14 = self.selected14;
        detailVC.tbl15 = self.selected15;
        detailVC.tbl21 = self.selected21;
        detailVC.tbl22 = self.selected22;
        detailVC.tbl23 = self.selected23;
        detailVC.tbl24 = self.selected24;
        detailVC.tbl25 = self.selected25;
        detailVC.tbl16 = self.selected16;
        detailVC.tbl26 = self.selected26;
        detailVC.tbl27 = self.selected27;
        detailVC.comments = self.selectedComments;
        detailVC.active = self.selectedActive;
        
        detailVC.l11 = @"Home"; detailVC.l12 = @"Work";
        detailVC.l13 = @"Mobile"; detailVC.l14 = @"Social";
        detailVC.l15 = @"Middle "; detailVC.l21 = @"Email";
        detailVC.l22 = @"Department"; detailVC.l23 = @"Title";
        detailVC.l24 = @"Manager"; detailVC.l25 = @"Country";
        detailVC.l16 = @"Last Updated"; detailVC.l26 = @"First";
        detailVC.l1datetext = @"Email:";
        detailVC.lnewsTitle = EMPLOYEENEWSTITLE;
    }
}

@end
