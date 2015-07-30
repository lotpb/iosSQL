//
//  StatisticsiPhoneController.h
//  MySQL
//
//  Created by Peter Balsamo on 4/19/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ConstantMain.h"
#import "YQL.h"
#import "ParseStatConnection.h"
#import "CustLocation.h"
#import "StatCustModel.h"
#import "StatLeadModel.h"
//#import "StatHeaderModel.h"

@interface StatisticsiPhoneController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, StatCustModelProtocol, StatLeadModelProtocol>
{
    NSMutableArray *tableLeadData, *tableCustData, *filteredString;
    BOOL isFilltered;
    YQL *yql;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollWall;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic)  UILabel *label2;

@end
