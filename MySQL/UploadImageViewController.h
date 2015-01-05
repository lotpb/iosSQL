//
//  UploadImageViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadImageViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *imgToUpload;
@property (weak, nonatomic) IBOutlet UITextField *commentTitle;
@property (weak, nonatomic) IBOutlet UITextField *commentDetail;
//@property (nonatomic, strong) NSString *username;
-(IBAction)selectPicturePressed:(id)sender;
@end
