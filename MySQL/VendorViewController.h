//
//  VendorViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VendLocation.h"
#import "VendorModel.h"
#import "VendorDetailController.h"
#import "NewData.h"
#import "LeadDetailViewControler.h"

@interface VendorViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, VendorModelProtocol>
{
 NSMutableArray *filteredString;
 BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
