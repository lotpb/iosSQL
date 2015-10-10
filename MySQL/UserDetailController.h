//
//  UserDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface UserDetailController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *create;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;

@property (weak, nonatomic) IBOutlet UILabel *createLabel;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UIButton *pickFile;
@property (weak, nonatomic) IBOutlet UIButton *pickUpload;
@property (weak, nonatomic) IBOutlet UIButton *update;

@property (weak, nonatomic) IBOutlet UIImageView *userimageView;
@property (strong, nonatomic) UIImage *userimage;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end
