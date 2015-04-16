//
//  LookupCity.h
//  MySQL
//
//  Created by Peter Balsamo on 1/7/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseConnection.h"
#import "NewData.h"
#import "EditData.h"

@protocol LookupCityDelegate <NSObject>

@required
- (void)cityFromController:(NSString *)passedData;
- (void)stateFromController:(NSString *)passedData;
- (void)zipFromController:(NSString *)passedData;

@end

@interface LookupCity : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}
@property (strong, nonatomic) id<LookupCityDelegate> delegate;
@property (strong, nonatomic) NSString *formController;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
