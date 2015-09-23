//
//  FacebookViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/9/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "SocialController.h"

@interface SocialController ()

@end

@implementation SocialController
{
    UIBarButtonItem *doneButton, *shareItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.socialText.delegate = self;

    doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    shareItem.tintColor = [UIColor orangeColor];
    doneButton.tintColor = [UIColor orangeColor];
    NSArray *actionButtonItems = @[doneButton, shareItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

    self.socialText.layer.cornerRadius = 8.0;
    self.socialText.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
    self.socialText.layer.borderWidth = 1.2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.socialText setFont:DETAILFONT(IPADFONT16)];
    } else {
        [self.socialText setFont:DETAILFONT(IPHONEFONT14)];
    }
    
    self.placeholderlabel.text = @"whats on your mind?";
    self.placeholderlabel.textColor = [UIColor lightGrayColor];
    
    [[UITextView appearance] setTintColor:CURSERCOLOR];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView {
    // Provide a "Done" button for the user to select to signify completion with writing text in the text view.
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBarButtonItemClicked)];
    
    [self.navigationItem setLeftBarButtonItem:doneBarButtonItem animated:YES];
    
    
    self.placeholderlabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeholderlabel.hidden = ([textView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderlabel.hidden = ([textView.text length] > 0);
}

- (void)doneBarButtonItemClicked {
    // Dismiss the keyboard by removing it as the first responder.
    [self.socialText resignFirstResponder];
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - BarButton
#pragma mark done
- (void)showdone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark share
- (void)share:(id)sender {
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* facebook = [UIAlertAction
                         actionWithTitle:@"Share on Facebook"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                                   [self facebookPost:self];
                         }];
    
    UIAlertAction* twitter = [UIAlertAction
                               actionWithTitle:@"Share on Twitter"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [self twitterPost:self];
                               }];
    UIAlertAction* message = [UIAlertAction
                              actionWithTitle:@"Send Text Message"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                   [self sendSMS:self];    
                              }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:facebook];
    [view addAction:twitter];
    [view addAction:message];
    [view addAction:cancel];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.popoverPresentationController.barButtonItem = shareItem;
        view.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate methods
 -(IBAction)facebookPost:(id)sender {
     
     // Facebook
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
     {
         SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
         
         [tweet setInitialText:self.socialText.text];
         [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
          {
              if (result == SLComposeViewControllerResultCancelled)
              {
                  NSLog(@"The user cancelled.");
              }
              else if (result == SLComposeViewControllerResultDone)
              {
                  NSLog(@"The user posted to Facebook");
              }
          }];
         [self presentViewController:tweet animated:YES completion:nil];
     }
     else
     {
         UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Facebook"
                                                                          message:@"Facebook integration is not available.  A Facebook account must be set up on your device."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                              }];
         [alert addAction:ok];
         [self presentViewController:alert animated:YES completion:nil];
     }
     
 /*
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
 [self presentViewController:controller animated:YES completion:nil]; */
 }
 
 -(IBAction)twitterPost:(id)sender {

     // Twitter
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
     {
         SLComposeViewController *tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
         
         [tweet setInitialText:self.socialText.text];
         [tweet setCompletionHandler:^(SLComposeViewControllerResult result)
          {
              if (result == SLComposeViewControllerResultCancelled)
              {
                  NSLog(@"The user cancelled.");
              }
              else if (result == SLComposeViewControllerResultDone)
              {
                  NSLog(@"The user sent the tweet");
              }
          }];
         [self presentViewController:tweet animated:YES completion:nil];
     }
     else
     {
         UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Twitter"
                                                                          message:@"Twitter integration is not available.  A Twitter account must be set up on your device."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                              {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                              }];
         [alert addAction:ok];
         [self presentViewController:alert animated:YES completion:nil];
     }
     
/*
 SLComposeViewController *tweetSheet = [SLComposeViewController
 composeViewControllerForServiceType:SLServiceTypeTwitter];
 [tweetSheet setInitialText:TWEETMESSAGE];
 [self presentViewController:tweetSheet animated:YES completion:nil]; */
 }




#pragma mark sendSMS
-(IBAction)sendSMS:(id)sender {
    //check if the device can send text messages
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Error"
                                                                         message:@"Your device cannot send text messages"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    //set receipients
    NSArray *recipients = [NSArray arrayWithObjects:@"(516)241-4786", nil];
    
    //set message text
    NSString * message = self.socialText.text;
    //NSString * message = @"This is a simple SMS sent from my demo app :)";
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

@end
