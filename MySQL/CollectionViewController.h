//
//  CollectionViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/25/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionHeaderView.h"
#import "JobViewCell.h"
#import "CollectionDetailController.h"
#import <Parse/Parse.h>
//#import "Constants.h"

#import <Social/Social.h>

@interface CollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
- (IBAction)shareButtonTouched:(id)sender;

@end
