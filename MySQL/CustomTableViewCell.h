//
//  CustomTableViewCell.h
//  MySQL
//
//  Created by Peter Balsamo on 11/7/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell

//BUser Controller
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usertitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usersubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDateLabel;

//BlogEditView
@property (weak, nonatomic) IBOutlet UIImageView *blogImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;
@property (weak, nonatomic) IBOutlet UILabel *replytitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *replysubtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *replylikeButton;
@property (weak, nonatomic) IBOutlet UILabel *replynumLabel;
@property (weak, nonatomic) IBOutlet UILabel *replydateLabel;

//Blog Controller
@property (weak, nonatomic) IBOutlet UIImageView *blog2ImageView;
@property (weak, nonatomic) IBOutlet UILabel *blogtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogmsgDateLabel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

//Lead Controller
@property (weak, nonatomic) IBOutlet UIImageView *leadImageView;
@property (weak, nonatomic) IBOutlet UILabel *leadtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadsubtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leadreadmore;
@property (weak, nonatomic) IBOutlet UILabel *leadnews;

@end
