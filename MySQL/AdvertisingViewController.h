//
//  AdvertisingViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdModel.h"
#import "NewDataDetail.h"

@interface AdvertisingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AdModelProtocol>
{
    // NSMutableArray *_feedItems;
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
