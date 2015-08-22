//
//  NewsDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 8/20/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@interface NewsDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageview;
@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSString *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) NSString *newsDetail;

@end
