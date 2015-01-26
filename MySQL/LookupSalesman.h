//
//  LookupSalesman.h
//  MySQL
//
//  Created by Peter Balsamo on 1/25/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDataViewController.h"
#import "EditDataViewController.h"

@protocol LookupSalesmanDelegate <NSObject>

@required
- (void)salesFromController:(NSString *)passedData;
- (void)salesNameFromController:(NSString *)passedData;

@end
@interface LookupSalesman : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (strong, nonatomic) id<LookupSalesmanDelegate> delegate;
@property (strong, nonatomic) NSString *formController;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
