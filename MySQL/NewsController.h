//
//  NewsController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h> //added to use PFImageView
#import <MediaPlayer/MediaPlayer.h>
//#import <AVFoundation/AVFoundation.h>
#import "NSOperationQueue+SharedQueue.h" //added to remove warning on thread
#import "NewsdetailController.h"

@interface NewsController : UIViewController <UITabBarControllerDelegate, UISearchControllerDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *wallScroll;
@property (nonatomic, retain) NSArray *imageFilesArray;

//@property (strong, nonatomic) NSString *imageurl;
@property (strong, nonatomic) NSString *imageDetailurl;

@property (strong, nonatomic) MPMoviePlayerController *videoController;
- (IBAction)playVideo:(id)sender;

@end
