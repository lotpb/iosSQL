//
//  NewsDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 8/20/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "NewsDetailController.h"

@interface NewsDetailController () {
    UIButton *playButton;
    PFImageView *userImage;
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
        self.newsTextview.editable = YES; //bug fix
        self.newsTextview.font = CELL_LIGHTFONT(IPADFONT18);
        self.newsTextview.editable = NO; //bug fix
    } else {
        self.titleLabel.font = DETAILFONT(IPHONEFONT20);
        self.detailLabel.font = DETAILFONT(IPHONEFONT14);
        self.newsTextview.editable = YES; //bug fix
        self.newsTextview.font = CELL_LIGHTFONT(IPHONEFONT16);
        self.newsTextview.editable = NO; //bug fix
    }
    
    self.newsImageview.image = self.image;
    
    self.titleLabel.text = self.newsTitle;
    self.titleLabel.numberOfLines = 2;
    
    self.detailLabel.text = self.newsDetail;
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabel sizeToFit];
    
    self.newsTextview.text = self.newsStory;
    
    imageParse = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
    userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:imageParse.getData]];

    if([self.imageDetailurl containsString:@"movie.mp4"]) {
        
    playButton = [[UIButton alloc] init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        playButton.frame = CGRectMake(self.newsImageview.frame.size.width / 2 +150, self.newsImageview.frame.origin.y + 145, 50, 50);
    } else {
        playButton.frame = CGRectMake(self.newsImageview.frame.size.width / 2 -130, self.newsImageview.frame.origin.y + 100, 50, 50);
    }
    playButton.alpha = 1.0f;
    UIImage *playbutton = [[UIImage imageNamed:@"play_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [playButton setImage:playbutton forState:UIControlStateNormal];
     playButton.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    [playButton addGestureRecognizer:tap];
    
    [self.scrollView addSubview:playButton];
    
    _videoURL = [NSURL URLWithString:self.imageDetailurl];
 
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.newsImageview = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.newsImageview;
}

#pragma mark - play video
- (IBAction) playVideo:(id)sender {

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
