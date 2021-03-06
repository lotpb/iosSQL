//
//  BlogViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ParseConnection.h"
//#import "CustomTableViewCell.h"
#import "BlogEditDetailView.h"
#import "BlogNewViewController.h"
#import "BlogUserController.h"
#import "BlogModel.h"
#import "BlogLocation.h"



@interface BlogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, BlogModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end


