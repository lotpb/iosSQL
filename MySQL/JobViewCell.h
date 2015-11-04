//
//  JobViewCell.h
//  MySQL
//
//  Created by Peter Balsamo on 12/25/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobViewCell : UICollectionViewCell 

@property (weak, nonatomic) IBOutlet UIImageView *user2ImageView;
//@property (weak, nonatomic) IBOutlet UILabel *usertitleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *usersubtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *jobImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
