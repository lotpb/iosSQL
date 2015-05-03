//
//  StatisticsViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 4/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustLocation.h"
#import "LeadTodayModel.h"

@interface StatisticsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, LeadTodayModelProtocol>
{
    NSMutableArray *tableData, *tableData1, *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic)  UILabel *label2;

@end
