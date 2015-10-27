//
//  BlogEditDetailView.h
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import "CustomTableViewCell.h"
#import "BlogViewController.h"
#import "BlogLocation.h"

@interface BlogEditDetailView : UIViewController

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *msgNo;
@property (strong, nonatomic) NSString *postby;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *msgDate;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *liked;
@property (strong, nonatomic) NSString *replyId;

@property (weak, nonatomic) IBOutlet UIButton *Like;
@property (weak, nonatomic) IBOutlet UIButton *update;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITableView *listTableView1;
@property (weak, nonatomic) BlogLocation *selectedLocation;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@end
