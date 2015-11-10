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
    NSMutableArray *_feedItems, *_feedItems2, *_feedItems3, *_feedItems4, *_feedItems5;
    UIRefreshControl *refreshControl;
    PFObject *imageObject;
    PFFile *imageFile;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation SnapshotController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Snapshot", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    //self.automaticallyAdjustsScrollViewInsets = NO; //fix dont work
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
        [parseConnection parseUser]; [parseConnection parseJobPhoto];
        [parseConnection parseNews]; [parseConnection parseSalesman];
        [parseConnection parseEmployee];
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
        [parseConnection parseUser]; [parseConnection parseJobPhoto];
        [parseConnection parseNews]; [parseConnection parseSalesman];
        [parseConnection parseEmployee];
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
        CGFloat result = 80;
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
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 2;
    } else if (section == 3) {
        return 3;
    } else if (section == 4) {
        return 2;
    } else if (section == 5) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0)
        return CGFLOAT_MIN;
    if (section == 1)
        return CGFLOAT_MIN;
    if (section == 2)
        return CGFLOAT_MIN;
    if (section == 3)
        return CGFLOAT_MIN;
    if (section == 4)
        return CGFLOAT_MIN;
    if (section == 5)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
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
    
    myCell.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; //fix
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_MEDFONT(IPADFONT18)];
    } else {
        [myCell.textLabel setFont:CELL_MEDFONT(IPHONEFONT18)];
    }
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
//------------------------------------------------------------------------------
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top News %ld", (unsigned long)_feedItems3.count];
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = 0;
            [myCell.collectionView setContentOffset:CGPointZero animated:NO];
            [myCell.collectionView reloadData];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;
            return myCell;
            
        } else if (indexPath.row == 2) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = @"myNews";
            myCell.accessoryType = NO;
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = @"Top News Story";
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, myCell.frame.size.width - 15, 20)];
            UILabel *datetitle = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, myCell.frame.size.width - 15, 20)];
            
            [title setFont:DETAILFONT(IPHONEFONT18)];
            [datetitle setFont:DETAILFONT(IPHONEFONT14)];
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;

            title.textColor = [UIColor blackColor];
            title.backgroundColor = [UIColor clearColor];
            title.numberOfLines = 2;
            title.tag = 1;
            [myCell.contentView addSubview:title];
            
            static NSDateFormatter *dateFormater = nil;
            if (dateFormater == nil) {
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:KEY_DATESQLFORMAT];
                dateFormater.timeZone = [NSTimeZone localTimeZone];
                NSDate *creationDate = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"createdAt"];
                NSDate *datetime1 = creationDate;
                NSDate *datetime2 = [NSDate date];
                double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
                NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
                
                datetitle.textColor = [UIColor lightGrayColor];
                datetitle.backgroundColor = [UIColor clearColor];
                datetitle.numberOfLines = 1;
                datetitle.tag = 2;
                [myCell.contentView addSubview:datetitle];

            UILabel *datetitle = (UILabel *)[myCell viewWithTag:2];
            datetitle.text = [NSString stringWithFormat:@"%@, %@",[[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsDetail"], resultDateDiff];
            
            UILabel *title = (UILabel *)[myCell viewWithTag:1];
            title.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
            }
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Jobs %ld", (unsigned long)_feedItems2.count];
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = 1;
           [myCell.collectionView setContentOffset:CGPointZero animated:NO];
           [myCell.collectionView reloadData];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 3) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Users %ld", (unsigned long)_feedItems.count];
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(100.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = 2;
            [myCell.collectionView setContentOffset:CGPointZero animated:NO];
            [myCell.collectionView reloadData];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;
            return myCell;
            
        } else if (indexPath.row == 2) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = @"myUser";
            myCell.accessoryType = NO;
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 4) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Salesman %ld", (unsigned long)_feedItems4.count];
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(80.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            
            UILabel *title = (UILabel *)[myCell viewWithTag:1];
            title.text = nil;
            UILabel *datetitle = (UILabel *)[myCell viewWithTag:2];
            datetitle.text = nil;
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = 3;
            [myCell.collectionView setContentOffset:CGPointZero animated:NO];
            [myCell.collectionView reloadData];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;
            
            return myCell;
            
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 5) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Employee %ld", (unsigned long)_feedItems5.count];
            myCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)myCell.collectionView.collectionViewLayout;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.itemSize = CGSizeMake(80.0, 120.0);
            [myCell.collectionView setCollectionViewLayout:flowLayout];
            
            UILabel *title = (UILabel *)[myCell viewWithTag:1];
            title.text = nil;
            UILabel *datetitle = (UILabel *)[myCell viewWithTag:2];
            datetitle.text = nil;
            myCell.collectionView.delegate = self;
            myCell.collectionView.dataSource = self;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.collectionView.tag = 4;
            [myCell.collectionView setContentOffset:CGPointZero animated:NO];
            [myCell.collectionView reloadData];
            myCell.textLabel.text = nil;
            myCell.accessoryType = NO;

            return myCell;
            
        }
    }
    return nil;
}
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // iPhone 6+ device width handler
    CGFloat multiplier = (screenWidth > kNumberOfCellsWidthThreshold) ? 4 : 3;
    CGFloat size = screenWidth / multiplier;
    return CGSizeMake(size, size);
} */

/*
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//-----Fix not sure if it works
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
} */

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
//------------------------------------------------------------------------------
    if (collectionView.tag == 0) {
    
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
        UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
        celltitle.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
        celltitle.font = [UIFont systemFontOfSize:12];
        //title.adjustsFontSizeToFitWidth = YES;
        celltitle.clipsToBounds = YES;
        celltitle.textColor = [UIColor blackColor];
        celltitle.backgroundColor = [UIColor whiteColor];
        celltitle.textAlignment = NSTextAlignmentCenter;
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
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [[_feedItems2 objectAtIndex:indexPath.row] objectForKey:@"imageGroup"];
         celltitle.font = [UIFont systemFontOfSize:12];
         celltitle.adjustsFontSizeToFitWidth = YES;
         celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
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
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
         celltitle.font = [UIFont systemFontOfSize:12];
         celltitle.adjustsFontSizeToFitWidth = YES;
         celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
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
         
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [[_feedItems4 objectAtIndex:indexPath.row] objectForKey:@"Salesman"];
         celltitle.font = [UIFont systemFontOfSize:12];
         //celltitle.adjustsFontSizeToFitWidth = YES;
         //celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
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
         UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
         celltitle.text = [NSString stringWithFormat:@"%@ %@ %@",[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"First"],[[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Last"], [[_feedItems5 objectAtIndex:indexPath.row] objectForKey:@"Company"]];
         celltitle.font = [UIFont systemFontOfSize:12];
         //celltitle.adjustsFontSizeToFitWidth = YES;
         //celltitle.clipsToBounds = YES;
         celltitle.textColor = [UIColor blackColor];
         celltitle.backgroundColor = [UIColor whiteColor];
         celltitle.textAlignment = NSTextAlignmentCenter;
         [cell.contentView addSubview:celltitle];
         
         return cell;
     }
    return nil;
}

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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 0) {
        
        imageObject = [_feedItems3 objectAtIndex:indexPath.row];
        imageFile = [imageObject objectForKey:@"imageFile"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.selectedImage = [UIImage imageWithData:data];
                self.selectedObjectId = [[_feedItems3 objectAtIndex:indexPath.row] objectId];
                //self.selectedName = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"username"];
                self.selectedTitle = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
                self.selectedEmail = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsDetail"];
                self.selectedPhone = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"storyText"];
                [self performSegueWithIdentifier:@"newssnapSegue" sender:self];
            }
        }];
        
    } else if (collectionView.tag == 1) {
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
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"newssnapSegue"]) {
        NewsDetailController *detailVC = segue.destinationViewController;
        detailVC.objectId = self.selectedObjectId;
        detailVC.newsTitle = self.selectedTitle;
        detailVC.newsDetail = self.selectedEmail;
        detailVC.newsStory = self.selectedPhone;
        detailVC.image = self.selectedImage;
      //detailVC.username = self.selectedName;
        
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
        //detailVC.jobImageView = self.selectedObjectId;
        detailVC.image = self.selectedImage;

    }
} 

@end
