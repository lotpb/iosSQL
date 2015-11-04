//
//  SnapshotController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/30/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "SnapshotController.h"

@interface SnapshotController ()
{
    NSMutableArray *_feedItems, *_feedItems2, *_feedItems3;
    UIRefreshControl *refreshControl;
    PFObject *imageObject;
    PFFile *imageFile;
}
@property (nonatomic, strong) UISearchController *searchController;
//@property (strong, nonatomic) PFUser *user;
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

/*
 *******************************************************************************************
 Parse.com
 *******************************************************************************************
 */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseUser]; [parseConnection parseJobPhoto]; [parseConnection parseNews];
    }
    
    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];;
    
    //UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = DARKGRAYCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;

}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseUser]; [parseConnection parseJobPhoto]; [parseConnection parseNews];
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

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat result = 141;
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
            case 3:
            {
                result = 16;
                break;
            }
        }
        return result;
        
    } else if (indexPath.section == 1) {
        CGFloat result = 80;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
            case 2:
            {
                result = 16;
                break;
            }

        }
        return result;
    } else if (indexPath.section == 2) {
        CGFloat result = 141;
        switch ([indexPath row])
        {
            case 0:
            {
                result = 44;
                break;
            }
            case 2:
            {
                result = 16;
                break;
            }

        }
        return result;
    } else if (indexPath.section == 3) {
        CGFloat result = 141;
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
            case 3:
            {
                result = 16;
                break;
            }
        }
        return result;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    UILabel *title, *datetitle;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_MEDFONT(IPADFONT18)];
        [title setFont:CELL_MEDFONT(IPADFONT18)];
        [datetitle setFont:DETAILFONT(IPADFONT12)];
    } else {
        [myCell.textLabel setFont:CELL_MEDFONT(IPHONEFONT18)];
        [title setFont:CELL_MEDFONT(IPHONEFONT18)];
        [datetitle setFont:DETAILFONT(IPHONEFONT10)];
    }
    
//------------------------------------------------------------------------------
    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = [NSString stringWithFormat:@"Top News %ld", (unsigned long)_feedItems3.count];
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 1) {
            myCell.textLabel.text = @"";
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = indexPath.row;
            [myCell.collectionView reloadData];
            return myCell;
            
        } else if (indexPath.row == 2) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = @"myNews";
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"";
            myCell.collectionView.backgroundColor = LIGHTGRAYCOLOR;
            myCell.backgroundColor = LIGHTGRAYCOLOR;
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = @"Top News Story";
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 1) {
            
             static NSDateFormatter *dateFormater = nil;
             if (dateFormater == nil) {
             NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
             [dateFormater setDateFormat:KEY_DATESQLFORMAT];
             dateFormater.timeZone = [NSTimeZone localTimeZone];
             NSDate *creationDate = [dateFormater dateFromString:[[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"createdAt"]];
             NSDate *datetime1 = creationDate;
             NSDate *datetime2 = [NSDate date];
             double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
             NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
            
            datetitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, myCell.frame.size.width - 20, 20)];
            datetitle.text = [NSString stringWithFormat:@"%@, %@",[[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsDetail"], resultDateDiff];
            datetitle.textColor = [UIColor lightGrayColor];
            datetitle.backgroundColor = [UIColor whiteColor];
            datetitle.numberOfLines = 1;
            [myCell.contentView addSubview:datetitle];
             }
            
            title = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, myCell.frame.size.width - 20, 20)];
            title.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
            title.textColor = [UIColor blackColor];
            title.backgroundColor = [UIColor whiteColor];
            title.numberOfLines = 2;
            [myCell.contentView addSubview:title];
            
            myCell.textLabel.text = @"";
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 2) {

            myCell.textLabel.text = @"";
            myCell.collectionView.backgroundColor = LIGHTGRAYCOLOR;
            myCell.backgroundColor = LIGHTGRAYCOLOR;
            return myCell;
            
        }
        
//------------------------------------------------------------------------------
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Jobs %ld", (unsigned long)_feedItems2.count];
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 1) {
            myCell.textLabel.text = @"";
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = indexPath.row;
            [myCell.collectionView reloadData];
            return myCell;
            
        } else if (indexPath.row == 2) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = @"";
            myCell.collectionView.backgroundColor = LIGHTGRAYCOLOR;
            myCell.backgroundColor = LIGHTGRAYCOLOR;
            return myCell;
            
        }
        
//------------------------------------------------------------------------------
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Users %ld", (unsigned long)_feedItems.count];
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 1) {
            myCell.textLabel.text = @"";
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = indexPath.row;
           [myCell.collectionView reloadData];
            return myCell;
            
        } else if (indexPath.row == 2) {
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.textLabel.text = @"myUser";
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.backgroundColor = [UIColor whiteColor];
            return myCell;
            
        } else if (indexPath.row == 3) {
            
            myCell.textLabel.text = @"";
            myCell.collectionView.backgroundColor = LIGHTGRAYCOLOR;
            myCell.backgroundColor = LIGHTGRAYCOLOR;
            return myCell;
            
        }
    }
    return nil;
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //if (section == 0) {
        return [_feedItems3 count];
    /*}  else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return [_feedItems2 count];
    } else if (section == 3) {
        return [_feedItems count];
    } */
    //return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    JobViewCell *cell = (JobViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//------------------------------------------------------------------------------
  //  if (indexPath.section == 0) {
        
        UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
        celltitle.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
        celltitle.font = [UIFont systemFontOfSize:12];
        //title.adjustsFontSizeToFitWidth = YES;
        celltitle.clipsToBounds = YES;
        celltitle.textColor = [UIColor blackColor];
        celltitle.backgroundColor = [UIColor whiteColor];
        celltitle.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:celltitle];
    
        imageObject = [_feedItems3 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        
        cell.loadingSpinner.hidden = NO;
       [cell.loadingSpinner startAnimating];
        
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                
                cell.user2ImageView.image = [UIImage imageWithData:data];
                cell.user2ImageView.backgroundColor = [UIColor blackColor];
               [cell.loadingSpinner stopAnimating];
                cell.loadingSpinner.hidden = YES;
            }
        }];
        
        return cell;
    
//------------------------------------------------------------------------------
     }
    /*
    else if (indexPath.section == 1) {
       
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [[_feedItems2 objectAtIndex:indexPath.row] objectForKey:@"imageGroup"];
         celltitle.font = [UIFont systemFontOfSize:12];
         //title.adjustsFontSizeToFitWidth = YES;
         celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
         [cell.contentView addSubview:celltitle];
         imageFile = nil;
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
         
         return cell;
//------------------------------------------------------------------------------         
     } else if (indexPath.section == 2) {
         
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
         celltitle.font = [UIFont systemFontOfSize:12];
         //title.adjustsFontSizeToFitWidth = YES;
         celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
         [cell.contentView addSubview:celltitle];
         imageFile = nil;
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
         
         return cell;
     }
    return nil;
} */




/*
 #pragma mark table header
 -(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
 return 50;
 }
 
 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
 [view setBackgroundColor:[UIColor whiteColor]];
 UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, tableView.frame.size.width -10, 20)];
 headerLabel.adjustsFontSizeToFitWidth = YES;
 headerLabel.clipsToBounds = YES;
 [headerLabel setFont:CELL_FONT(IPHONEFONT20)];
 headerLabel.textColor = [UIColor blackColor];
 headerLabel.text = [NSString stringWithFormat:@"Users %ld", (unsigned long)_feedItems.count];
 
 [view addSubview:headerLabel];
 
 return view;
 } */
/*
 #pragma mark table footer
 -(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
 return 50;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 
 UILabel *headerLabel = [[UILabel alloc]init];
 headerLabel.textColor = [UIColor darkGrayColor];
 [headerLabel setFont:CELL_FONT(IPHONEFONT20)];
 headerLabel.backgroundColor = [UIColor whiteColor];
 
 headerLabel.text = @"  My Users";
 return headerLabel;
 
 } */

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
    
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"userdetailSegue"]) {
        
        NSIndexPath *indexPath = [self.listTableView indexPathForSelectedRow];
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            NSDate *updated = [[_feedItems objectAtIndex:indexPath.row] createdAt];
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MMM dd, yyyy"];
            NSString *createAtString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updated]];
            
            UserDetailController *detailVC = segue.destinationViewController;
            detailVC.objectId = [[_feedItems objectAtIndex:indexPath.row] objectId];
            detailVC.username = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
            detailVC.create = createAtString;
            detailVC.email = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"email"];
            detailVC.phone = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"phone"];
            detailVC.userimage = self.selectedImage;
        }
    }
} */

@end
