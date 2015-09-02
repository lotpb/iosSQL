//
//  NewsDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 8/20/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "NewsDetailController.h"

@interface NewsDetailController () {
    UIButton *playButton;//
    PFFile *imageParse;
    PFObject *wallObject;
}

@end

@implementation NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NEWSNAVLOGO]];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
     self.newsImageview.backgroundColor = BACKGROUNDCOLOR;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.newsImageview.contentMode = UIViewContentModeScaleToFill;
        self.titleLabel.font = DETAILFONT(IPADFONT26);
        self.detailLabel.font = DETAILFONT(IPADFONT16);
        self.newsTextview.font = CELL_LIGHTFONT(IPADFONT18);
    } else {
        self.titleLabel.font = DETAILFONT(IPHONEFONT20);
        self.detailLabel.font = DETAILFONT(IPHONEFONT14);
        self.newsTextview.font = CELL_LIGHTFONT(IPHONEFONT16);
    }
    
    self.newsImageview.image = self.image;
    self.titleLabel.text = self.newsTitle;
    self.titleLabel.numberOfLines = 2;
    
    self.detailLabel.text = self.newsDetail;
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabel sizeToFit];
    
    self.newsTextview.text = self.newsStory; //textviewText;
    
    imageParse = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
    
    //if([imageParse.url containsString:@"movie.mp4"]) {
        
        playButton = [[UIButton alloc] init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            playButton.frame = CGRectMake(self.newsImageview.frame.size.width / 2 - 25 , self.newsImageview.frame.origin.y + 145, 50, 50);
        } else {
            playButton.frame = CGRectMake(self.newsImageview.frame.size.width / 2 -130, self.newsImageview.frame.origin.y + 90, 50, 50);
        }
        playButton.alpha = 1.0f;
        //playButton.center = self.newsImageview.center;
        UIImage *playbutton = [[UIImage imageNamed:@"play_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [playButton setImage:playbutton forState:UIControlStateNormal];
         playButton.userInteractionEnabled = YES;
        //self.newsImageview.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
        [playButton addGestureRecognizer:tap];
        [self.newsImageview addSubview:playButton];
        
        self.videoURL = [NSURL URLWithString:imageParse.url];
        //NSLog(@"Peter url...%@", _videoURL);
        
   // }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.newsImageview;
}

#pragma mark - play video
- (IBAction) playVideo:(id)sender { //(NSURL*) _videoURL{

    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlayingVideo:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:self.videoController];
    
    self.videoController.view.frame = self.view.bounds;
    [self.videoController prepareToPlay];
    [self.videoController setContentURL:self.videoURL];
    [self.view addSubview:self.videoController.view];
    [self.videoController play];
    [self.videoController setFullscreen:YES animated:YES];
    
}

- (void) stopPlayingVideo:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
}


@end
