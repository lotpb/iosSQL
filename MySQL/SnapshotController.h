//
//  SnapshotController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/30/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseConnection.h"
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "JobViewCell.h"
//#import "UserDetailController.h"

@interface SnapshotController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

//@property (strong, nonatomic) UIImage *selectedImage;

@end

