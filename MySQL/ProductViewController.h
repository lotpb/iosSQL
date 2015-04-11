//
//  ProductViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"
#import "ProductLocation.h"
#import <Parse/Parse.h>
#import "NewDataDetail.h"

@interface ProductViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, ProductModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered, isFormStat;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
