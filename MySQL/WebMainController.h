//
//  MainWebController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "Constants.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
@import SafariServices;
#endif
//#import "SafariServices/SafariServices.h"

@interface WebMainController : UIViewController <WKScriptMessageHandler, SFSafariViewControllerDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stop;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refresh;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *action;

@end
