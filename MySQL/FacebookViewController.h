//
//  FacebookViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/9/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
//#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController : UIViewController //<FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

-(IBAction)twitterPost:(id)sender;
-(IBAction)facebookPost:(id)sender;
-(IBAction)messagePost:(id)sender;

//@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

//@property (weak, nonatomic) IBOutlet UILabel *lblLoginStatus;

//@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

//@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

//@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;

@end
