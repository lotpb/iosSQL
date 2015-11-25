//
//  SalesmanViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Constants.h"
#import "ConstantMain.h"
#import "SalesLocation.h"
#import "SalesModel.h"
#import "ParseConnection.h"
#import "NewDataDetail.h"

@interface SalesmanViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, SalesModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered, isFormStat;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIImage *selectedImage;

@end
