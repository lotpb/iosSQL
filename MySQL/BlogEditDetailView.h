//
//  BlogEditDetailView.h
//  MySQL
//
//  Created by Peter Balsamo on 10/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogViewController.h"
#import "BlogLocation.h"
#import "BlogModel.h"

@interface BlogEditDetailView : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *msgNo;
@property (strong, nonatomic) IBOutlet UILabel *postby;
@property (strong, nonatomic) IBOutlet UITextField *msgDate;
@property (strong, nonatomic) IBOutlet UILabel *subject;
@property (strong, nonatomic) IBOutlet UILabel *rating;
//@property (weak, nonatomic) IBOutlet UILabel *Like;
@property (weak, nonatomic) IBOutlet UIButton *update;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) BlogLocation *selectedLocation;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
