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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(id)sender {
    [UIApplication.sharedApplication openURL:self.webView.request.URL];
}

- (void)viewDidLoad {
   [super viewDidLoad];
    // www.eunitedws.wordpress.com
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.cnn.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    self.webView.scalesPageToFit = YES;
   [self.webView loadRequest:request];
}

- (IBAction)WebTypeChanged:(id)sender {
    
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    NSURL *url ;
    if (segControl.selectedSegmentIndex == 0) {
        url = [[NSURL alloc] initWithString:@"http://www.cnn.com"];
    }
    if (segControl.selectedSegmentIndex == 1) {
        url = [[NSURL alloc] initWithString:@"http://www.Drudgereport.com"];
    }
    if (segControl.selectedSegmentIndex == 2) {
        url = [[NSURL alloc] initWithString:@"http://www.cnet.com"];
    }
    if (segControl.selectedSegmentIndex == 3) {
        url = [[NSURL alloc] initWithString:@"http://www.theblaze.com"];
    }
    if (segControl.selectedSegmentIndex == 4) {
        url = [[NSURL alloc] initWithString:@"http://finance.yahoo.com/mb/GTATQ/"];
    }
    if (segControl.selectedSegmentIndex == 5) {
        url = [[NSURL alloc] initWithString:@"http://stocktwits.com/symbol/FB"];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
     self.webView.scalesPageToFit = YES;
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

- (void)viewWillAppear:(BOOL)animated {
    self.webView.delegate = self;	// setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.webView stopLoading]; // in case the web view is still loading its content
     self.webView.delegate = nil;	// disconnect the delegate as the webview is hidden
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // turn off the twirly
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // we support rotation in this view controller
    return YES;
}

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
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self.webView loadHTMLString:errorString baseURL:nil];
    }


@end
