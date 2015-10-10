//
//  BlogUserController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/10/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ParseConnection.h"
#import "CustomTableViewCell.h"
#import "BlogModel.h"
#import "BlogLocation.h"
//#import "BlogEditDetailView.h"
//#import "BlogNewViewController.h"

@interface BlogUserController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

//@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *postBy;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
