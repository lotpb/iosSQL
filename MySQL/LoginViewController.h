//
//  LoginViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 12/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;

- (IBAction)registerUser:(id)sender;
- (IBAction)LoginUser:(id)sender;
- (IBAction)authenticateButtonTapped:(id)sender;
@end
