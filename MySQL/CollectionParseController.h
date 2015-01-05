//
//  CollectionParseController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/26/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionHeaderView.h"
#import "JobViewCell.h"
#import "CollectionDetailController.h"
#import <Parse/Parse.h>
#import <Social/Social.h>
//#import "Constants.h"

@interface CollectionParseController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollection;
- (IBAction)shareButtonTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSString *workseg;

@end
