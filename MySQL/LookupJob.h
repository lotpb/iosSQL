//
//  LookupJob.h
//  MySQL
//
//  Created by Peter Balsamo on 1/6/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewData.h"
#import "EditData.h"

@protocol LookupJobDelegate <NSObject>

@required
- (void)jobFromController:(NSString *)passedData;
- (void)jobNameFromController:(NSString *)passedData;

@end

@interface LookupJob : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>

{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (strong, nonatomic) id<LookupJobDelegate> delegate;
@property (strong, nonatomic) NSString *formController;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
