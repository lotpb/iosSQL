//
//  CustomTableViewCell.m
//  MySQL
//
//  Created by Peter Balsamo on 11/7/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "CustomTableViewCell.h"

@interface CustomTableViewCell ()
{ /*
    UILabel *titleLabel;
    UILabel *timeLabel;
    UILabel *commentsLabel;
    UILabel *likesLabel;
    UILabel *solutionsLabel;
    UILabel *descriptionLabel; */
}

@end

@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      /*
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(descriptionLabel.frame), self.contentView.frame.size.width-20, 25)];
        view.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:view];
        
        solutionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 15)];
        solutionsLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        //solutionsLabel.textColor = [Utils themeColor];
        [view addSubview:solutionsLabel];
        
        commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, 5, 60, 15)];
        commentsLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        //commentsLabel.textColor = [Utils themeColor];
        [view addSubview:commentsLabel];
        
        likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(127, 5, 58, 15)];
        likesLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        //likesLabel.textColor = [Utils themeColor];
        [view addSubview:likesLabel];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, screenWidth-210, 15)];
        timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [view addSubview:timeLabel]; */
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
