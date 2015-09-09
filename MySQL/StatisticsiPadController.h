//
//  StatisticsiPadController.h
//  MySQL
//
//  Created by Peter Balsamo on 7/3/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
//#import "ConstantMain.h"
#import "YQL.h"
#import "ParseStatConnection.h"
//#import "CustLocation.h"
//#import "StatCustModel.h"
//#import "StatLeadModel.h"

@interface StatisticsiPadController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
     YQL *yql;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollWall;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableViewLeft;
@property (weak, nonatomic) IBOutlet UITableView *listTableViewRight;
@property (weak, nonatomic) IBOutlet UITableView *listTableViewLeft1;
@property (weak, nonatomic) IBOutlet UITableView *listTableViewRight1;
@property (weak, nonatomic)  UILabel *label2;

@end
