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
#import <AVFoundation/AVFoundation.h> //video thumbnail

@interface UploadImageViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSString *formStat;

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *newstitle;
@property (strong, nonatomic) NSString *newsdetail;
@property (strong, nonatomic) NSString *newsStory;
@property (strong, nonatomic) NSString *imageDetailurl;
@property (strong, nonatomic) UIImage *newsImage;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imgToUpload;
@property (weak, nonatomic) IBOutlet UITextField *commentTitle;
@property (weak, nonatomic) IBOutlet UITextField *commentSorce;
@property (weak, nonatomic) IBOutlet UITextView *commentDetail;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *selectPic;

@property (nonatomic, strong) NSString *username;
-(IBAction)selectPicturePressed:(id)sender;
@end
