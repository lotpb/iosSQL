//
//  LookupCity.h
//  MySQL
//
//  Created by Peter Balsamo on 1/7/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDataViewController.h"
#import "EditDataViewController.h"

@protocol LookupCityDelegate <NSObject>

@required
- (void)cityFromController:(NSString *)passedData;
- (void)stateFromController:(NSString *)passedData;
- (void)zipFromController:(NSString *)passedData;

@end

@interface LookupCity : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (nonatomic, strong) id<LookupCityDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
