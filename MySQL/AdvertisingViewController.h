//
//  AdvertisingViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdModel.h"
#import "AdLocation.h"
#import <Parse/Parse.h>
#import "NewDataDetail.h"

@interface AdvertisingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, AdModelProtocol>
{
    // NSMutableArray *_feedItems;
    NSMutableArray *filteredString;
    BOOL isFilltered, isFormStat;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
