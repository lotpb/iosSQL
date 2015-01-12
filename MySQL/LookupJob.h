//
//  LookupJob.h
//  MySQL
//
//  Created by Peter Balsamo on 1/6/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDataViewController.h"
#import "EditDataViewController.h"

@protocol LookupJobDelegate <NSObject>

@required
- (void)jobFromController:(NSString *)passedData;

@end

@interface LookupJob : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (nonatomic, strong) id<LookupJobDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
