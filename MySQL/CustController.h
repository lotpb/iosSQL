//
//  CustController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/1/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustLocation.h"
#import "CustModel.h"
#import "LeadDetailViewControler.h"
#import "NewData.h"
#import "MapViewController.h"

@interface CustController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, CustModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
