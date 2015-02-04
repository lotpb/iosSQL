//
//  MainWebController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>

@interface WebMainController : UIViewController <WKScriptMessageHandler>

//- (IBAction)actionButton:(id)sender;
@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;

@end
