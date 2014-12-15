//
//  BlogViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogModel.h"
//#import "BlogLocation.h"
#import "BlogEditDetailView.h"
#import "BlogNewViewController.h"

@interface BlogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, BlogModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}
@property (weak, nonatomic) IBOutlet UIImageView *blog2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *blogtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogmsgDateLabel;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *Like;
@end


