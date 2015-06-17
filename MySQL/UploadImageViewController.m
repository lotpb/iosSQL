//
//  UploadImageViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "UploadImageViewController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface UploadImageViewController ()

-(void)showErrorView:(NSString *)errorMsg;

@end

@implementation UploadImageViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize commentTitle = _commentTitle;
@synthesize commentDetail = _commentDetail;
//@synthesize username = _username;

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
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [self.commentTitle becomeFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.imgToUpload = nil;
    self.commentTitle = nil;
    self.commentDetail = nil;
   // self.username = nil;
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
} */

#pragma mark IB Actions

-(IBAction)selectPicturePressed:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imgPicker animated:YES completion:nil];
}

-(IBAction)sendPressed:(id)sender
{
    [self.commentTitle resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [loadingSpinner startAnimating];
    
    [self.view addSubview:loadingSpinner];
    
    //Upload a new picture
    NSData *pictureData = UIImagePNGRepresentation(self.imgToUpload.image);
    
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* const userNameKey = KEY_USER;
            
            //Add the image to the object, and add the comments, the user, and the geolocation (fake)
            PFObject *imageObject = [PFObject objectWithClassName:@"Newsios"];
            [imageObject setObject:file forKey:@"imageFile"];
            [imageObject setObject:self.commentTitle.text forKey:@"newsTitle"];
            [imageObject setObject:self.commentDetail.text forKey:@"newsDetail"];
            [imageObject setObject:[defaults objectForKey:userNameKey]forKey:@"usernameKey"];
            
            //[imageObject setObject:[PFUser currentUser].username forKey:@"username"];
            
           // PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:52 longitude:-4];
            //[imageObject setObject:point forKey:KEY_GEOLOC];
            
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
        
    }];
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Place the image in the imageview
    self.imgToUpload.image = img;
}

#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

@end
