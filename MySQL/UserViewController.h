//
//  UserViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseConnection.h"
#import <MapKit/MapKit.h>
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "JobViewCell.h"
#import "UserDetailController.h"

@interface UserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (strong, nonatomic) NSString *formController;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

