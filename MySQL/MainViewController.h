//
//  MainViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Parse/Parse.h>
//#import "ConstantMain.h"
#import "Constants.h"
#import "SWRevealViewController.h"
//#import <iAd/iAd.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate> 
{
    NSMutableArray *tableData, *filteredString;
    BOOL isFilltered;
   // ADBannerView *bannerView;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
