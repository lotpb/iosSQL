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
    PFObject *imageObject;
    PFFile *imageFile;
    UIButton *playButton;
    NSString *resultDateDiff;
    NSMutableArray *_feedItems, *_feedItems2, *_feedItems3, *_feedItems4, *_feedItems5;
    UIRefreshControl *refreshControl;
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
    
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //AudioServicesPlayAlertSound(1352);

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
            myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            //myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return myCell;
            
        } else if (indexPath.row == 1) {
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 23, myCell.frame.size.width - 15, 50)];
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
            
            datetitle.textColor = [UIColor lightGrayColor];
            datetitle.backgroundColor = [UIColor clearColor];
            datetitle.numberOfLines = 1;
            datetitle.tag = 2;
            [myCell.contentView addSubview:datetitle];
            
            NSDate *creationDate = [[_feedItems3 objectAtIndex:indexPath.row] createdAt];
            NSDate *datetime1 = creationDate;
            NSDate *datetime2 = [NSDate date];
            double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
            resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];

            datetitle = (UILabel *)[myCell viewWithTag:2];
            datetitle.text = [NSString stringWithFormat:@"%@, %@",[[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsDetail"], resultDateDiff];
            
            title = (UILabel *)[myCell viewWithTag:1];
            title.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
            
            
            return myCell;
        }
//------------------------------------------------------------------------------
    } else if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
            myCell.collectionView.delegate = nil;
            myCell.collectionView.dataSource = nil;
            myCell.collectionView.backgroundColor = [UIColor whiteColor];
            myCell.textLabel.text = [NSString stringWithFormat:@"Top Jobs %ld", (unsigned long)_feedItems2.count];
            myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            myCell.collectionView.tag = 14;
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
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryNone;
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
            //myCell.selectionStyle = UITableViewCellSelectionStyleGray;
            myCell.accessoryType = UITableViewCellAccessoryNone;
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
                
                if([imageFile.url containsString:@"movie.mp4"]) {
                    NSString *localPath = imageFile.url;
                    NSURL *localURL = [NSURL URLWithString:localPath];
                    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:localURL options:nil];
                    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
                    generator.appliesPreferredTrackTransform = YES;
                    UIImage* thumbnail = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
                    cell.user2ImageView.image = thumbnail;
                    
                    playButton.alpha = 1.0f;
                    //playButton.userInteractionEnabled = YES;
                    //playButton.center = cell.user2ImageView.center;
                    UIImage *button = [[UIImage imageNamed:@"play_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    [playButton setImage:button forState:UIControlStateNormal];
                    //[playButton setTitle:@"play_button" forState:UIControlStateNormal];
                    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
                    //[playButton addGestureRecognizer:tap];
                    [cell.contentView addSubview:playButton];
                }
                
               [cell.loadingSpinner stopAnimating];
                cell.loadingSpinner.hidden = YES;
            }
        }];
        
        UILabel *celltitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, cell.bounds.size.width, 20)];
        celltitle.text = [[_feedItems3 objectAtIndex:indexPath.row] objectForKey:@"newsTitle"];
        celltitle.font = [UIFont systemFontOfSize:12];
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
