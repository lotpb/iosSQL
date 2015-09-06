//
//  LoginViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    NSString *email, *finalEmail;
}

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //create instance of NSUSerDefaults
    
    //if statement to check if there is a registered user or not
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        _loginBtn.hidden = YES; //hide login button because no user is regsitered
    }
    else {
        NSLog(@"user is registered");
        _reEnterPasswordField.hidden = YES;
        _registerBtn.hidden = YES;
    }
     self.usernameField.text = @"eunitedws@verizon.net";
    // self.passwordField.text = @"3911";
     [[UITextField appearance] setTintColor:[UIColor grayColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.passwordField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    
    //check if all text fields are completed
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    
    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"passwords match!");
        [self registerNewUser];
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

- (void) registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //write the username and password and set BOOL value in NSUserDefaults
    [defaults setObject:_usernameField.text forKey:@"usernameKey"];
    [defaults setObject:_passwordField.text forKey:@"passwordKey"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (IBAction)LoginUser:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //check that username and password match stored values
    if (([_usernameField.text isEqualToString:[defaults objectForKey:@"usernameKey"]] || [_usernameField.text isEqualToString:[defaults objectForKey:@"emailKey"]]) && [_passwordField.text isEqualToString:[defaults objectForKey:@"passwordKey"]]) {
        _usernameField.text = nil;
        _passwordField.text = nil;
        [self performSegueWithIdentifier:@"loginSegue" sender:self]; //perform segue to next view controller
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your username and password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
}

- (IBAction)passwordReset:(id)sender {
    
     email = self.emailField.text;
    finalEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [PFUser requestPasswordResetForEmailInBackground:finalEmail block:^(BOOL succeeded,NSError *error) {
        
        if (!error) {
            
            UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Link to reset the password has been send to specified email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warning show];
            return;
        } else {
            
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat: @"Password reset failed: %@",errorString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warning show];
            return;
        }
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }];
}
//--------------------------------------------------------------------------------------------
- (IBAction)authenticateButtonTapped:(id)sender {
    [self.passwordField resignFirstResponder];
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Authenticate using your finger";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                
                                if (success) {
                                    
                                   
                                    //NSLog(@"User authenticated");
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                    [self didAuthenticateWithTouchId];
                                    //[self showMessage:@"Authentication is successful" withTitle:@"Success"];

                                    });
                       
                                }  else {
                                    
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            [self showMessage:@"Authentication is failed" withTitle:@"Error"];
                                            NSLog(@"Authentication Failed");
                                            break;
                                            
                                        case LAErrorUserCancel:
                                            [self showMessage:@"You clicked on Cancel" withTitle:@"Error"];
                                            NSLog(@"User pressed Cancel button");
                                            break;
                                            
                                        case LAErrorUserFallback:
                                            [self showMessage:@"You clicked on \"Enter Password\"" withTitle:@"Error"];
                                            NSLog(@"User pressed \"Enter Password\"");
                                            break;
                                            
                                        default:
                                            [self showMessage:@"Touch ID is not configured" withTitle:@"Error"];
                                            NSLog(@"Touch ID is not configured");
                                            break;
                                    }
                                    
                                    NSLog(@"Authentication Fails");
                                } 
                            }];
    } else {
        [self showMessage:@"Your device doesn't support this feature." withTitle:@"Error"];
        
    }
}

- (void)didAuthenticateWithTouchId {
    _usernameField.text = nil;
    _passwordField.text = nil;
   [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void) showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
 
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
