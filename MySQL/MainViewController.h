//
//  MainViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import "SWRevealViewController.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate> 
{
    NSMutableArray *tableData, *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
