//
//  NewsController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsController : UIViewController <UITabBarControllerDelegate, UISearchBarDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (weak, nonatomic) IBOutlet UILabel *newstitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newssubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsreadmore;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@end
