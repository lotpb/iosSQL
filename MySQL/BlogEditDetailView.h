//
//  BlogEditDetailView.h
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogLocation.h"
#import "BlogViewController.h"
#import "Constants.h"

@interface BlogEditDetailView : UIViewController

@property (strong, nonatomic) UILabel *msgNo;
@property (strong, nonatomic) UILabel *postby;
@property (strong, nonatomic) UITextField *msgDate;
@property (strong, nonatomic) UILabel *subject;
@property (strong, nonatomic) UILabel *rating;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *Like;
@property (weak, nonatomic) IBOutlet UIButton *update;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) BlogLocation *selectedLocation;

@end
