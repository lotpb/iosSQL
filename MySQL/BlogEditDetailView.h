//
//  BlogEditDetailView.h
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "BlogViewController.h"

@interface BlogEditDetailView : UIViewController

@property (strong, nonatomic) NSString *msgNo;
@property (strong, nonatomic) NSString *postby;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *msgDate;
@property (strong, nonatomic) NSString *rating;

@property (weak, nonatomic) IBOutlet UIButton *Like;
@property (weak, nonatomic) IBOutlet UIButton *update;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) BlogLocation *selectedLocation;

@end
