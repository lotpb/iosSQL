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

@synthesize imgToUpload = _imgToUpload;
@synthesize commentTitle = _commentTitle;
@synthesize commentDetail = _commentDetail;
@synthesize username = _username;

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
    self.imgToUpload.backgroundColor = [UIColor whiteColor];
    self.imgToUpload.userInteractionEnabled = YES;
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [self.commentTitle becomeFirstResponder];
    
    if (self.progressView.progress == 0) {
        self.progressView.hidden = NO;
    } else {
        self.progressView.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.commentTitle = nil;
    self.commentDetail = nil;
    self.username = nil;
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
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    
    /*
    NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imgPicker setMediaTypes:mediaTypesAllowed]; */
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

-(IBAction)sendPressed:(id)sender
{
    [self.commentTitle resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    loadingSpinner.center = self.imgToUpload.center;
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];
    
    PFFile *file;
    if (pickImage) {
        pictureData = UIImageJPEGRepresentation(self.imgToUpload.image, 0.9f);
        file = [PFFile fileWithName:@"img" data:pictureData];
    } else {
        pictureData = [NSData dataWithContentsOfURL:videoURL];
        file = [PFFile fileWithName:@"movie.mp4" data:pictureData];
    }
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* const userNameKey = KEY_USER;
            
            PFObject *imageObject = [PFObject objectWithClassName:@"Newsios"];
            [imageObject setObject:file forKey:@"imageFile"];
            [imageObject setObject:self.commentTitle.text forKey:@"newsTitle"];
            [imageObject setObject:self.commentDetail.text forKey:@"newsDetail"];
            
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
                [imageObject setObject:[PFUser currentUser].username forKey:@"username"];
            } else {
                [imageObject setObject:[defaults objectForKey:userNameKey]forKey:@"usernameKey"];
            }

            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded)
                    //Go back to the wall
                    GOBACK;
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [self showErrorView:errorString];
                    }
            }];
        }
        else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
             }
        
        [loadingSpinner stopAnimating];
        [loadingSpinner removeFromSuperview];
        
    } progressBlock:^(int percentDone) {
     [self.progressView setProgress:(float)percentDone/100.0f];
    }];
}

#pragma mark UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        pictureData = [NSData dataWithContentsOfURL:videoURL];
        /*
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        CGSize size = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
        NSTimeInterval durationInSeconds = 0.0;
        if (asset) durationInSeconds = CMTimeGetSeconds(asset.duration);
        
        if (size.width>640 || size.height>480) {
        //    [self showIndeterminateProgressWithTitle:@"processing video..."];
            [self cropVideoAtURL:videoURL toWidth:480 height:360 completion:^(NSURL *resultURL, NSError *error) {
                if (error) {
                  //  DLOG(@"crop error %@", error);
                  //  [self hideIndeterminateProgress];
                } else {
                    moviePath = resultURL;
                    
                    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:moviePath options:nil];
                    CGSize size = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize];
                 //   DLOG(@"video size after %@", NSStringFromCGSize(size));
                    
                    NSData *data = [NSData dataWithContentsOfURL:moviePath];
                //    DLOG(@"VIDEO SIZE %.2f",(float)data.length/1024.0f/1024.0f);
                    
                    [self hideIndeterminateProgress];

                }
            }]; */
        
        pickImage = nil;
        [self refreshSolutionView];
    } else {
        moviePath = nil;
        pickImage = info[UIImagePickerControllerEditedImage];
        [self refreshSolutionView];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerVideo delegate
- (void) refreshSolutionView {
  //  [catchLabel removeFromSuperview];
    self.imgToUpload.image = nil;
    [self.videoController stop];
    self.videoController = nil;
    [self.videoController.view removeFromSuperview];
    
    if (pickImage) { //it's image
        self.imgToUpload.image = pickImage;
    } else { //it's video
        
        self.videoController = [[MPMoviePlayerController alloc] init];
        [self.videoController setContentURL:videoURL];
        [self.videoController.view setFrame:self.imgToUpload.bounds];
        self.videoController.view.backgroundColor = [UIColor clearColor];
        self.videoController.view.clipsToBounds = YES;
        [self.videoController prepareToPlay];
        self.videoController.controlStyle = MPMovieControlStyleDefault;
        self.videoController.shouldAutoplay = NO;
        [self.imgToUpload addSubview:self.videoController.view];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.videoController];

    }
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
      //  [player.view removeFromSuperview];
    }
}

#pragma mark Error View
-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

@end
