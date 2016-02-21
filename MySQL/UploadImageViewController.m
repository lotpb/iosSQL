//
//  UploadImageViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "UploadImageViewController.h"


@interface UploadImageViewController ()
{
    UIImage *pickImage;
    NSData *pictureData;
    NSURL *videoURL, *moviePath;
}

-(void)showErrorView:(NSString *)errorMsg;
@property (strong, nonatomic) MPMoviePlayerController *videoController;

@end

@implementation UploadImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;//fix
    self.mainView.backgroundColor = LIGHTGRAYCOLOR;
    //[self.commentTitle becomeFirstResponder];
    
    self.navigationController.navigationBar.barTintColor = DARKGRAYCOLOR; //[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = YES;
    
    if (self.progressView.progress == 0) {
        self.progressView.hidden = true;
    } else {
        self.progressView.hidden = false;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.commentTitle.font = DETAILFONT(IPADFONT18);
        self.commentSorce.font = DETAILFONT(IPADFONT18);
        self.commentDetail.font = DETAILFONT(IPADFONT18);
    } else {
        self.commentTitle.font = DETAILFONT(IPHONEFONT16);
        self.commentSorce.font = DETAILFONT(IPHONEFONT16);
        self.commentDetail.font = DETAILFONT(IPHONEFONT16);
    }
    
    if ([self.formStat isEqual:@"Update"]) {
        self.commentTitle.text = self.newstitle;
        self.commentDetail.text = self.newsStory;
        self.commentSorce.text = self.newsdetail;
        self.imgToUpload.image = self.newsImage;
    } else {
        self.commentDetail.text = textviewText;
    }
    
    self.imgToUpload.backgroundColor = [UIColor whiteColor];
    self.imgToUpload.userInteractionEnabled = YES;

    [self.clearButton setTitle:@"clear" forState:UIControlStateNormal];
     self.clearButton.tintColor = DARKGRAYCOLOR;
     self.selectPic.tintColor = DARKGRAYCOLOR;
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.commentTitle = nil;
    self.commentSorce = nil;
    self.commentDetail = nil;
    self.username = nil;
    self.videoController = nil;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark IB Actions

-(IBAction)selectPicturePressed:(id)sender
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

-(IBAction)activeButton:(id)sender {
    
    if ([self.clearButton.titleLabel.text isEqualToString:@"clear"])   {
        self.commentDetail.text = @"";
        [self.clearButton setTitle: @"add text" forState: UIControlStateNormal];
        [self.clearButton sizeToFit];
    } else {
        self.commentDetail.text = textviewText;
        [self.clearButton setTitle: @"clear" forState: UIControlStateNormal];
        [self.clearButton sizeToFit];
    }
}

-(IBAction)sendPressed:(id)sender {
    [self.commentTitle resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingSpinner.center = self.imgToUpload.center;
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];
    
    if ([self.formStat isEqual:@"Update"]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
        [query whereKey:@"objectId" equalTo:self.objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * imageObject, NSError *error) {
            if (!error) {
                //[imageObject setObject:self.imgToUpload.image forKey:@"imageFile"];
                [imageObject setObject:self.commentTitle.text forKey:@"newsTitle"];
                [imageObject setObject:self.commentSorce.text forKey:@"newsDetail"];
                [imageObject setObject:self.commentDetail.text forKey:@"storyText"];
                [imageObject setObject:[PFUser currentUser].username forKey:@"username"];
                [imageObject saveInBackground];
                //[imageObject saveEventually];
                
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Upload Complete" message:@"Successfully updated the data" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         GOBACK; //GOHOME;
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [self showErrorView:errorString];
            }
        }];
    } else {
        
        PFFile *file;
        if (pickImage) {
            pictureData = UIImageJPEGRepresentation(self.imgToUpload.image, 0.9f);
            file = [PFFile fileWithName:@"img" data:pictureData];
        } else {
            pictureData = [NSData dataWithContentsOfURL:videoURL];
            file = [PFFile fileWithName:@"movie.mp4" data:pictureData];
        }
        NSLog(@"Size of Image(bytes):%lu",(unsigned long)[pictureData length]);
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded){
                PFObject *imageObject = [PFObject objectWithClassName:@"Newsios"];
                [imageObject setObject:file forKey:@"imageFile"];
                [imageObject setObject:self.commentTitle.text forKey:@"newsTitle"];
                [imageObject setObject:self.commentSorce.text forKey:@"newsDetail"];
                [imageObject setObject:self.commentDetail.text forKey:@"storyText"];
                [imageObject setObject:[PFUser currentUser].username forKey:@"username"];
                [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded)
                        //Go back to the wall
                        GOBACK;
                    else {
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        [self showErrorView:errorString];
                    }
                }];
            } else {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [self showErrorView:errorString];
                }
            
            [loadingSpinner stopAnimating];
            [loadingSpinner removeFromSuperview];
            
        } progressBlock:^(int percentDone) {
            [self.progressView setProgress:(float)percentDone/100.0f];
        }];
    }
}
/*
- (UIImage *)firstFrame:(NSURL *)videoURL {
    
    // courtesy of null0pointer and Javi Campaña
    // http://stackoverflow.com/questions/10221242/first-frame-of-a-video-using-avfoundation
    
    AVURLAsset* asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    AVAssetImageGenerator* generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    UIImage* image = [UIImage imageWithCGImage:[generator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
    
    return image;
} */

#pragma mark UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        pictureData = [NSData dataWithContentsOfURL:videoURL];
        pickImage = nil;

    } else {
        moviePath = nil;
        pickImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
     NSLog(@"Size of Image(bytes):%lu",(unsigned long)[pictureData length]);
    [self refreshSolutionView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerVideo delegate
- (void) refreshSolutionView {
    /*
    if ((pictureData.length/1024) >= 1024) {
        NSLog(@"Size of Image(bytes):%lu",(unsigned long)[pictureData length]);
    } */
    
    self.imgToUpload.image = nil;
    [self.videoController stop];
    self.videoController = nil;
    [self.videoController.view removeFromSuperview];
    
    if (pickImage) { //it's image
        [self.imgToUpload setContentMode:UIViewContentModeScaleToFill];
        self.imgToUpload.image = pickImage;
        self.imgToUpload.clipsToBounds = YES; //added
        
    } else { //it's video
        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController setContentURL:videoURL];
        [self.videoController.view setFrame:self.imgToUpload.bounds];
        self.videoController.view.backgroundColor = [UIColor clearColor];
        self.videoController.view.clipsToBounds = YES;
        [self.videoController prepareToPlay];
        self.videoController.scalingMode = MPMovieScalingModeFill; 
        self.videoController.controlStyle = MPMovieControlStyleDefault;
        self.videoController.shouldAutoplay = NO;
        [self.imgToUpload addSubview:self.videoController.view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:)
                name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController];
    }
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    // Display a message
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Video Playback" message:@"Just finished the video playback. The video is now removed." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
/*
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
      //  [player.view removeFromSuperview];
    } */
}

#pragma mark Error View
-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                     message:errorMsg
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
