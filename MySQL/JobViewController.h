//
//  JobViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantMain.h"
#import "JobModel.h"
#import "JobLocation.h"
#import "ParseConnection.h"
#import "NewDataDetail.h"

@interface JobViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, JobModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered, isFormStat;
    
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
