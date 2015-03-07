//
//  EmployeeViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeeModel.h"
#import "EmployeeDetailController.h"
#import "NewData.h"
#import "LeadDetailViewControler.h"

@interface EmployeeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, EmployeeModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
