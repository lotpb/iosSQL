//
//  UploadImageViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
//#import <AVFoundation/AVFoundation.h>

@interface UploadImageViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imgToUpload;
@property (weak, nonatomic) IBOutlet UITextField *commentTitle;
@property (weak, nonatomic) IBOutlet UITextField *commentSorce;
@property (weak, nonatomic) IBOutlet UITextView *commentDetail;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

@property (nonatomic, strong) NSString *username;
-(IBAction)selectPicturePressed:(id)sender;
@end
