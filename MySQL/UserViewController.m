//
//  UserViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()
{
    NSMutableArray *_feedItems;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) PFUser *user;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Users", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 110; //ROW_HEIGHT;
    self.listTableView.backgroundColor = BACKGROUNDCOLOR;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//fix
    
    /*
    *******************************************************************************************
    Parse.com
    *******************************************************************************************
    */
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
        [parseConnection parseUser];
    }

    filteredString= [[NSMutableArray alloc] initWithArray:_feedItems];;
   
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[addItem, searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.mapView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([PFUser currentUser])
    {
        self.user = [PFUser user];
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            //NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            [self.user setObject:geoPoint forKey:@"currentLocation"];
            [self.user saveInBackground];
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.40, 0.40))];
            
            [self refreshMap];
        }];
    }
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        ParseConnection *parseConnection = [[ParseConnection alloc]init];
        parseConnection.delegate = (id)self;
       [parseConnection parseUser];
    }
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
- (void)parseUserloaded:(NSMutableArray *)UserItem {
    _feedItems = UserItem;
    [self.listTableView reloadData];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFilltered)
        return filteredString.count;
    else
        return _feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = IDCELL;
    CustomTableViewCell *myCell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [myCell.detailTextLabel setTextColor:[UIColor grayColor]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.usertitleLabel setFont:CELL_FONT(IPADFONT20)];
        [myCell.usersubtitleLabel setFont:CELL_FONT(IPADFONT16)];
    } else {
        [myCell.usertitleLabel setFont:CELL_FONT(IPHONEFONT18)];
        [myCell.usersubtitleLabel setFont:CELL_FONT(IPHONEFONT14)];
    }
    [myCell.usersubtitleLabel setTextColor:[UIColor grayColor]];
    
    if (myCell == nil)
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    /*
     *******************************************************************************************
     Parse.com
     *******************************************************************************************
     */
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"]];
    query.cachePolicy = kPFCACHEPOLICY;
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    [myCell.userImageView setImage:[UIImage imageWithData:data]];
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        if (!isFilltered) {
            
            static NSDateFormatter *formatter = nil;
            if (formatter == nil) {
                NSDate *updated = [[_feedItems objectAtIndex:indexPath.row] createdAt];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM-dd-yyyy"];
                NSString *createAtString = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:updated]];
                
                myCell.usertitleLabel.text = [[_feedItems objectAtIndex:indexPath.row] objectForKey:@"username"];
                myCell.usersubtitleLabel.text = createAtString;
            }
        } else {
            myCell.usertitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"username"];
            myCell.usersubtitleLabel.text = [[filteredString objectAtIndex:indexPath.row] objectForKey:@"email"];
        }
        return myCell;
    } else {
        return nil;
    }
}

#pragma mark table header
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.text = [NSString stringWithFormat:@"  User's \n%lu", (unsigned long) _feedItems.count];
   [headerLabel setFont:CELL_FONT(IPHONEFONT14)];
    NSLog(@"Object peter id %lu",(unsigned long) _feedItems.count);
    
    UIView* separatorLineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 25, self.listTableView.frame.size.width, 0.2)];
    separatorLineBottom.backgroundColor = [UIColor lightGrayColor];
    [self.listTableView addSubview:separatorLineBottom];
    
    return headerLabel;
}

#pragma mark - map
- (void)refreshMap {
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    PFQuery *query = [PFUser query];
    [query whereKey:@"currentLocation" nearGeoPoint:geoPoint withinMiles:100.0f];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
         if(error)
         {
             NSLog(@"%@",error);
         }
         for (id object in objects)
         {
             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
             annotation.title = [object objectForKey:@"username"];
             PFGeoPoint *geoPoint= [object objectForKey:@"currentLocation"];
             annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
             
             [self.mapView addAnnotation:annotation];
         }
     }];
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
    
    PFObject *imageObject = [_feedItems objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.selectedImage = [UIImage imageWithData:data];
           [self performSegueWithIdentifier:@"userdetailSegue" sender:self.listTableView];
        }
    }]; 
    
    /*
    if (!isFilltered)
        _selectedLocation = [_feedItems objectAtIndex:indexPath.row];
    else
        _selectedLocation = [filteredString objectAtIndex:indexPath.row]; */
}

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
}

@end

