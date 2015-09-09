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
@synthesize commentSorce = _commentSorce;
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
    [self.commentTitle becomeFirstResponder];
    
    if (self.progressView.progress == 0) {
        self.progressView.hidden = NO;
    } else {
        self.progressView.hidden = YES;
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
    
    self.commentDetail.text = textviewText;
    self.imgToUpload.backgroundColor = [UIColor whiteColor];
    self.imgToUpload.userInteractionEnabled = YES;

    [self.clearButton setTitle:@"clear" forState:UIControlStateNormal];
    
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
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    /*
     NSArray *mediaTypesAllowed = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
     [imgPicker setMediaTypes:mediaTypesAllowed]; */
    
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
            [imageObject setObject:self.commentSorce.text forKey:@"newsDetail"];
            [imageObject setObject:self.commentDetail.text forKey:@"storyText"];
            
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
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo)
    {
        videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        pictureData = [NSData dataWithContentsOfURL:videoURL];
        pickImage = nil;

    } else {
        moviePath = nil;
        pickImage = info[UIImagePickerControllerEditedImage];
    }
    [self refreshSolutionView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIImagePickerVideo delegate
- (void) refreshSolutionView {

    self.imgToUpload.image = nil;
    [self.videoController stop];
    self.videoController = nil;
    [self.videoController.view removeFromSuperview];
    
    if (pickImage) { //it's image
        [self.imgToUpload setContentMode:UIViewContentModeScaleToFill];
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
    /*
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    // Stop the video player and remove it from view
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
    self.videoController = nil;
    
    // Display a message
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Video Playback" message:@"Just finished the video playback. The video is now removed." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okayAction];
    [self presentViewController:alertController animated:YES completion:nil]; */
    
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];

    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
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
