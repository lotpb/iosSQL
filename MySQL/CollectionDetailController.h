//
//  CollectionDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/25/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionController.h"
#import "Constants.h"

@interface CollectionDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *jobImageView;
@property (strong, nonatomic) UIImage *image;

@end
