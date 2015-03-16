//
//  FacebookViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/9/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "FacebookViewController.h"
#import "SWRevealViewController.h"
//@import MessageUI;

@interface FacebookViewController ()
/*
-(void)toggleHiddenState:(BOOL)shouldHide;
*/
@end

@implementation FacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor whiteColor]; //[UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the gesture
    //    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
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
     
 if (result == SLComposeViewControllerResultCancelled)
 {
 NSLog(@"Cancelled");
 }
 else
 {
 NSLog(@"Done");
 }
 [controller dismissViewControllerAnimated:YES completion:nil];
 };
 controller.completionHandler =myBlock;
 //Adding the Text to the facebook post value from iOS
 [controller setInitialText:@"My test post"];
 //Adding the URL to the facebook post value from iOS
 [controller addURL:[NSURL URLWithString:@"http://www.test.com"]];
 //Adding the Text to the facebook post value from iOS
 [self presentViewController:controller animated:YES completion:nil];
 }
 
 -(IBAction)twitterPost:(id)sender{
 SLComposeViewController *tweetSheet = [SLComposeViewController
 composeViewControllerForServiceType:SLServiceTypeTwitter];
 [tweetSheet setInitialText:@"My test tweet"];
 [self presentViewController:tweetSheet animated:YES completion:nil];
 }

-(IBAction)messagePost:(id)sender{
  /*  MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.delegate = self;
    messageComposeViewController.recipients = @[@"mattt@nshipster•com"];
    messageComposeViewController.body = @"Lorem ipsum dolor sit amet";
    [navigationController presentViewController:messageComposeViewController animated:YES completion:^{
        // ...
    }];  */
}


@end
