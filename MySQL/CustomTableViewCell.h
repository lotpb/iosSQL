//
//  CustomTableViewCell.h
//  MySQL
//
//  Created by Peter Balsamo on 11/7/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *blogImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *blog2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *blogtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogmsgDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leadImageView;
@property (weak, nonatomic) IBOutlet UILabel *leadtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadreadmore;
@property (weak, nonatomic) IBOutlet UILabel *leadnews;

@end
