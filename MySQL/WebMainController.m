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
/*
- (IBAction)actionButton:(id)sender {
    [UIApplication.sharedApplication openURL:self.webView.request.URL];
} */

- (void)viewDidLoad {
   [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]
                                             init];
    WKUserContentController *controller = [[WKUserContentController alloc]
                                           init];
    
    // Add a script handler for the "observe" call. This is added to every frame
    // in the document (window.webkit.messageHandlers.NAME).
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;
    
    // This is the URL to be loaded into the WKWebView.
    NSURL *jsbin = [NSURL URLWithString:@"http://www.cnn.com"];
    
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
/*
- (IBAction)loadHtmlAction:(id)sender
{
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"];
    NSLog(@"%@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}

- (IBAction)loadDataAction:(id)sender
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sampleWord" withExtension:@"docx"];
    NSLog(@"%@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
} */

- (IBAction)WebTypeChanged:(id)sender {
    
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    NSURL *url ;
    if (segControl.selectedSegmentIndex == 0)
        url = [[NSURL alloc] initWithString:@"http://www.cnn.com"];
    
    else if (segControl.selectedSegmentIndex == 1)
        url = [[NSURL alloc] initWithString:@"http://www.Drudgereport.com"];
    
    else if (segControl.selectedSegmentIndex == 2)
        url = [[NSURL alloc] initWithString:@"http://www.cnet.com"];
    
    else if (segControl.selectedSegmentIndex == 3)
        url = [[NSURL alloc] initWithString:@"http://www.theblaze.com"];
    
    else if (segControl.selectedSegmentIndex == 4)
        url = [[NSURL alloc] initWithString:@"http://finance.yahoo.com/mb/GTATQ/"];
    
    else if (segControl.selectedSegmentIndex == 5)
        url = [[NSURL alloc] initWithString:@"http://stocktwits.com/symbol/FB"];
    
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
/*
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    // starting the load, show the activity indicator (twirly) in the status bar
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;
    self.stop.enabled = self.webView.loading;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // finished loading, hide the activity indicator in the status bar
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
   // below made title on TabBar
   // self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
    } */

@end
