//
//  MainWebController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "WebMainController.h"

@interface WebMainController ()

@end

@implementation WebMainController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
   [super viewDidLoad];
    //SegmentControl Names
    NSArray *names = [[NSArray alloc] initWithObjects:KEY_WEBNAME0, KEY_WEBNAME1, KEY_WEBNAME2, KEY_WEBNAME3, KEY_WEBNAME4, KEY_WEBNAME5, nil];
    [names enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [self.segControl setTitle:title forSegmentAtIndex:idx];
    }];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    
    // Add a script handler for the "observe" call. This is added to every frame
    // in the document (window.webkit.messageHandlers.NAME).
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;
    
    // This is the URL to be loaded into the WKWebView.
    NSURL *jsbin = [NSURL URLWithString:KEY_WEBPAGE0];
    
    // Initialize the WKWebView with the current frame and the configuration
    // setup above
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame
                                  configuration:configuration];
    
    // Load the jsbin URL into the WKWebView and then add it as a sub-view.
    [_webView loadRequest:[NSURLRequest requestWithURL:jsbin]];
    [self.view addSubview:_webView];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // Check to make sure the name is correct
    if ([message.name isEqualToString:@"observe"]) {
        // Log out the message received
        NSLog(@"Received event %@", message.body);
        
        // Then pull something from the device using the message body
        NSString *version = [[UIDevice currentDevice] valueForKey:message.body];
        
        // Execute some JavaScript using the result
        NSString *exec_template = @"set_headline(\"received: %@\");";
        NSString *exec = [NSString stringWithFormat:exec_template, version];
        [_webView evaluateJavaScript:exec completionHandler:nil];
    }
}

- (IBAction)WebTypeChanged:(id)sender {
    
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    NSURL *url ;
    if (segControl.selectedSegmentIndex == 0)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE0];
    
    else if (segControl.selectedSegmentIndex == 1)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE1];
    
    else if (segControl.selectedSegmentIndex == 2)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE2];
    
    else if (segControl.selectedSegmentIndex == 3)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE3];
    
    else if (segControl.selectedSegmentIndex == 4)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE4];
    
    else if (segControl.selectedSegmentIndex == 5)
        url = [[NSURL alloc] initWithString:KEY_WEBPAGE5];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

-(IBAction)backButtonPressed:(id)sender {
    [self.webView goBack];
}

-(IBAction)forwardButtonPressed:(id)sender{
    [self.webView goForward];
}

-(IBAction)stopButtonPressed:(id)sender{
    [self.webView stopLoading];
}

- (void)viewDidUnload {
     self.webView = nil;
     self.backButton = nil;
     self.forwardButton = nil;
   [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // we support rotation in this view controller
    return YES;
}

@end
