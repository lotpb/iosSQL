//
//  NewsController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h> //added to use PFImageView
#import "Constants.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSOperationQueue+SharedQueue.h" //added to remove warning on thread
#import "NewsdetailController.h"

@interface NewsController : UIViewController <UITabBarControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wallScroll;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (nonatomic, retain) NSArray *imageFilesArray;
- (IBAction)playVideo:(id)sender;

@end
