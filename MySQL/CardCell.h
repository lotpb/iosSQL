//
//  CardCell.h
//  MySQL
//
//  Created by Peter Balsamo on 11/7/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIImageView *twImage;
@property (weak, nonatomic) IBOutlet UIButton *twButton;
@property (weak, nonatomic) IBOutlet UIImageView *fbImage;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;


- (void)setupWithDictionary:(NSDictionary *)dictionary;

@end
