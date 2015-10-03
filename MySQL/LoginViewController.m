//
//  LoginViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
{
    NSString *email, *finalEmail;
}
@property (strong, nonatomic) PFUser *user;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"registerKey"]) {
        NSLog(@"No user registered");
        [self.registerBtn setTitle: @"Sign in" forState: UIControlStateNormal];
        self.loginBtn.hidden = YES; //hide login button no user is regsitered
        self.forgotPassword.hidden = YES;
        self.authentButton.hidden = YES;
        self.emailField.hidden = NO;
        self.phoneField.hidden = NO;
    }
    else {
        NSLog(@"user is registered");
        self.usernameField.text = [defaults objectForKey:@"usernameKey"];
        self.reEnterPasswordField.hidden = YES;
        self.registerBtn.hidden = NO;
        self.emailField.hidden = YES;
        self.phoneField.hidden = YES;
        self.forgotPassword.hidden = NO;
        self.backloginBtn.hidden = YES;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.usernameField setFont:CELL_FONT(IPADFONT20)];
        [self.passwordField setFont:CELL_FONT(IPADFONT20)];
        [self.reEnterPasswordField setFont:CELL_FONT(IPADFONT20)];
        [self.emailField setFont:CELL_FONT(IPADFONT20)];
        [self.phoneField setFont:CELL_FONT(IPADFONT20)];
    } else {
        [self.usernameField setFont:CELL_FONT(IPADFONT18)];
        [self.passwordField setFont:CELL_FONT(IPADFONT18)];
        [self.reEnterPasswordField setFont:CELL_FONT(IPADFONT18)];
        [self.emailField setFont:CELL_FONT(IPADFONT18)];
        [self.phoneField setFont:CELL_FONT(IPADFONT18)];
    }
    
    if([PFUser currentUser])
    {
        self.user = [PFUser user];
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
            [self.user setObject:geoPoint forKey:@"currentLocation"];
            [self.user saveInBackground];
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
            
            [self refreshMap];
        }];
    }

     [[UITextField appearance] setTintColor:[UIColor grayColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"registerKey"])
        [self.usernameField becomeFirstResponder];
    else
        [self.passwordField becomeFirstResponder]; */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - map
- (void)refreshMap {
    
    PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.centerCoordinate.latitude longitude:self.mapView.centerCoordinate.longitude];
    PFQuery *query = [PFUser query];
    [query whereKey:@"currentLocation" nearGeoPoint:geoPoint withinMiles:100.0f];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if(error)
         {
             NSLog(@"%@",error);
         }
         for (id object in objects)
         {
             
             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
             annotation.title = [object objectForKey:@"username"];
             PFGeoPoint *geoPoint= [object objectForKey:@"currentLocation"];
             annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude,geoPoint.longitude);
             
             [self.mapView addAnnotation:annotation];
         }
     }];
}

#pragma mark - login
- (IBAction)LoginUser:(id)sender {
    //finalEmail = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
                    // NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
                    [user setObject:geoPoint forKey:@"currentLocation"];
                    [user saveInBackground];
                    //  [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
                    
                    //    [refreshMap:nil];
                    _usernameField.text = nil;
                    _passwordField.text = nil;
                    [self performSegueWithIdentifier:@"loginSegue" sender:self];
                }];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_usernameField.text forKey:@"usernameKey"];
                [defaults setObject:_passwordField.text forKey:@"passwordKey"];
                //[defaults setObject:_emailField.text forKey:@"emailKey"];
                [defaults setBool:YES forKey:@"registerKey"];
                [defaults synchronize];
                
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"Your username and password does not match" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                NSLog(@"User Failed");
            }
        }];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (([_usernameField.text isEqualToString:[defaults objectForKey:@"usernameKey"]] || [_usernameField.text isEqualToString:[defaults objectForKey:@"emailKey"]]) && [_passwordField.text isEqualToString:[defaults objectForKey:@"passwordKey"]]) {
            _usernameField.text = nil;
            _passwordField.text = nil;
            [self performSegueWithIdentifier:@"loginSegue" sender:self]; //perform segue to next view controller
        }
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"Your username and password does not match" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)returnLogin:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.registerBtn setTitle: @"Create an Account" forState: UIControlStateNormal];
    self.usernameField.text = [defaults objectForKey:@"usernameKey"];
    self.passwordField.hidden = NO;
    self.usernameField.hidden = NO;
    self.loginBtn.hidden = NO;
    self.registerBtn.hidden = NO;
    self.forgotPassword.hidden = NO;
    self.authentButton.hidden = NO;
    self.backloginBtn.hidden = YES;
    self.reEnterPasswordField.hidden = YES;
    self.emailField.hidden = YES;
    self.phoneField.hidden = YES;
    
}

#pragma mark - register User
- (IBAction)registerUser:(id)sender {
    
    if ([self.registerBtn.titleLabel.text isEqualToString: @"Create an Account"]) {
        [self.registerBtn setTitle: @"Sign in" forState: UIControlStateNormal];
        self.usernameField.text = @"";
        self.loginBtn.hidden = YES;
        self.forgotPassword.hidden = YES;
        self.authentButton.hidden = YES;
        self.backloginBtn.hidden = NO;
        self.reEnterPasswordField.hidden = NO;
        self.emailField.hidden = NO;
        self.phoneField.hidden = NO;
        
    } else {
        //check if all text fields are completed
        if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"You must complete all fields" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [self checkPasswordsMatch];
        }
    }
}

- (void) registerNewUser {
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
        PFUser *user = [PFUser user];
        user.username = _usernameField.text;
        user.password = _passwordField.text;
        user.email = _emailField.text;
        user[@"phone"] = _phoneField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {   // Hooray! Let them use the app now.
                _usernameField.text = nil;
                _passwordField.text = nil;
                [self performSegueWithIdentifier:@"loginSegue" sender:self];
                
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_usernameField.text forKey:@"usernameKey"];
    [defaults setObject:_passwordField.text forKey:@"passwordKey"];
    [defaults setObject:_emailField.text forKey:@"emailKey"];
    [defaults setBool:YES forKey:@"registerKey"];
    [defaults synchronize];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"You have registered a new user" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
    
}

#pragma mark - passsword
- (void) checkPasswordsMatch {
    
    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"passwords match!");
        [self registerNewUser];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oooops" message:@"Your entered passwords do not match" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)passwordReset:(id)sender {
    self.emailField.hidden = NO;
    self.backloginBtn.hidden = NO;
    self.passwordField.hidden = YES;
    self.usernameField.hidden = YES;
    self.loginBtn.hidden = YES;
    self.registerBtn.hidden = YES;
    self.authentButton.hidden = YES;
    email = self.emailField.text;
    finalEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [PFUser requestPasswordResetForEmailInBackground:finalEmail block:^(BOOL succeeded,NSError *error) {
        
        if (!error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Link to reset the password has been send to specified email" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        } else {
            
            NSString *errorString = [error userInfo][@"error"];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:[NSString stringWithFormat: @"Enter email in field: %@",errorString] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        //[self dismissViewControllerAnimated:YES completion:NULL];
    }];
}
//--------------------------------------------------------------------------------------------

#pragma mark - authenticate
- (IBAction)authenticateButtonTapped:(id)sender {
    [self.passwordField resignFirstResponder];
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *reason = @"Authenticate using your finger";
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reason
                            reply:^(BOOL success, NSError *error) {
                                
                                if (success) {
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_usernameField.text forKey:@"usernameKey"];
    [defaults setObject:@"3911" forKey:@"passwordKey"];
    //[defaults setObject:_emailField.text forKey:@"emailKey"];
    [defaults setBool:YES forKey:@"registerKey"];
    [defaults synchronize];
   [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

-(void) showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
