//
//  LookupProduct.h
//  MySQL
//
//  Created by Peter Balsamo on 1/15/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewDataViewController.h"
#import "EditDataViewController.h"

@protocol LookupProductDelegate <NSObject>

@required
- (void)productFromController:(NSString *)passedData;
- (void)productNameFromController:(NSString *)passedData;

@end
@interface LookupProduct : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (strong, nonatomic) id<LookupProductDelegate> delegate;
@property (strong, nonatomic) NSString *formController;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
