//
//  SalesmanViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SalesModel.h"

@interface SalesmanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SalesModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
