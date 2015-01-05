//
//  VendorViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendorModel.h"
#import "LeadDetailViewControler.h"

@interface VendorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, VendorModelProtocol>
{
   // NSMutableArray *_feedItems;
 NSMutableArray *filteredString;
 BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
