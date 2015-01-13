//
//  CustController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/1/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustModel.h"
#import "LeadDetailViewControler.h"
#import "NewDataViewController.h"
#import "MapViewController.h"

@interface CustController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CustModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
