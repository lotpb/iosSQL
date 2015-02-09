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
@property (strong, nonatomic) UIImageView *blog2ImageView;
@property (strong, nonatomic) UILabel *blogtitleLabel;
@property (strong, nonatomic) UILabel *blogsubtitleLabel;
@property (strong, nonatomic) UILabel *blogmsgDateLabel;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UILabel *Like;
@end


