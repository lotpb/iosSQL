//
//  WallNewsViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallNewsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *wallScroll;

-(IBAction)logoutPressed:(id)sender;

@end
