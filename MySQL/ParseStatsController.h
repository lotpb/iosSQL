//
//  ParseStatsController.h
//  MySQL
//
//  Created by Peter Balsamo on 7/3/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "YQL.h"
//#import "CustLocation.h"
//#import "StatCustModel.h"
//#import "StatLeadModel.h"

@interface ParseStatsController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
     YQL *yql;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic)  UILabel *label2;

@end
