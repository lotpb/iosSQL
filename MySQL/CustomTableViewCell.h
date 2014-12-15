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

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newstitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newssubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsreadmore;


@property (weak, nonatomic) IBOutlet UIImageView *leadImageView;
@property (weak, nonatomic) IBOutlet UILabel *leadtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadreadmore;
@property (weak, nonatomic) IBOutlet UILabel *leadnews;

@property (weak, nonatomic) IBOutlet UIImageView *vendImageView;
@property (weak, nonatomic) IBOutlet UILabel *vendtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *vendreadmore;
@property (weak, nonatomic) IBOutlet UILabel *vendnews;

@property (weak, nonatomic) IBOutlet UIImageView *employImageView;
@property (weak, nonatomic) IBOutlet UILabel *employtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *employsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *employreadmore;
@property (weak, nonatomic) IBOutlet UILabel *employnews;
@end
