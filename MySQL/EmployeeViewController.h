//
//  EmployeeViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"
#import "LeadDetailViewControler.h"

@interface EmployeeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, EmployeeModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
