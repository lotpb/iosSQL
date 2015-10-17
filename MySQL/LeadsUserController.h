//
//  LeadsUserController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/11/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ParseConnection.h"
#import "CustomTableViewCell.h"
#import "BlogModel.h"
#import "BlogLocation.h"

@interface LeadsUserController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (strong, nonatomic) NSString *formController;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *leadDate;
@property (strong, nonatomic) NSString *postBy;
@property (strong, nonatomic) NSString *comments;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
