//
//  NewsController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"

@interface NewsController : UIViewController <UITabBarControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wallScroll;
//-(IBAction)logoutPressed:(id)sender;

@end
