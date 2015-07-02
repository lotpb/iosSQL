//
//  FacebookViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/9/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "FacebookViewController.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = SIDEBARTINTCOLOR; //[UIColor colorWithWhite:0.1f alpha:0.9f];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showdone{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
 -(IBAction)facebookPost:(id)sender{
 SLComposeViewController *controller = [SLComposeViewController
 composeViewControllerForServiceType:SLServiceTypeFacebook];
 SLComposeViewControllerCompletionHandler myBlock =
 ^(SLComposeViewControllerResult result){
     
 if (result == SLComposeViewControllerResultCancelled) {
 NSLog(@"Cancelled");
 } else {
 NSLog(@"Done");
 }
 [controller dismissViewControllerAnimated:YES completion:nil];
 };
 controller.completionHandler =myBlock;
 //Adding the Text to the facebook post value from iOS
 [controller setInitialText:FBMESSAGE];
 //Adding the URL to the facebook post value from iOS
 [controller addURL:[NSURL URLWithString:FMMESSAGEURL]];
 //Adding the Text to the facebook post value from iOS
 [self presentViewController:controller animated:YES completion:nil];
 }
 
 -(IBAction)twitterPost:(id)sender{
 SLComposeViewController *tweetSheet = [SLComposeViewController
 composeViewControllerForServiceType:SLServiceTypeTwitter];
 [tweetSheet setInitialText:TWEETMESSAGE];
 [self presentViewController:tweetSheet animated:YES completion:nil];
 }


#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
}

#pragma mark - IBAction methods
-(IBAction)sendSMS:(id)sender {
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device cannot send text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //set receipients
    NSArray *recipients = [NSArray arrayWithObjects:@"(516)241-4786", nil];
    
    //set message text
    NSString * message = @"This is a simple SMS sent from my demo app :)";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

@end
