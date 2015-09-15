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
#import "Constants.h"
#import <MessageUI/MessageUI.h>
#import "SWRevealViewController.h"

@interface SocialController : UIViewController <MFMessageComposeViewControllerDelegate, UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITextView *socialText;
@property (weak, nonatomic) IBOutlet UILabel *placeholderlabel;

-(IBAction)twitterPost:(id)sender;
-(IBAction)facebookPost:(id)sender;
-(IBAction)sendSMS :(id)sender;

@end
