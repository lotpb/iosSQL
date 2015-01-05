//
//  WebViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/11/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController < UIWebViewDelegate>

- (IBAction)actionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;


@property (strong, nonatomic) NSDictionary *feedItem;


@end
