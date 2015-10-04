//
//  UserDetailController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailController : UIViewController

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *username;
//@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *create;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;


@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *createField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *pickFile;
@property (weak, nonatomic) IBOutlet UIButton *pickUpload;
@property (weak, nonatomic) IBOutlet UIButton *update;
@property (weak, nonatomic) IBOutlet UIImageView *userimageView;
@property (strong, nonatomic) UIImage *userimage;

@end
