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
NSURL *url;

- (void)viewDidLoad {
   [super viewDidLoad];
    
    //SegmentControl Names
    NSArray *names = [[NSArray alloc] initWithObjects:KEY_WEBNAME0, KEY_WEBNAME1, KEY_WEBNAME2, KEY_WEBNAME3, KEY_WEBNAME4, KEY_WEBNAME5, nil];
    [names enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        [self.segControl setTitle:title forSegmentAtIndex:idx];
    }];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    [controller addScriptMessageHandler:self name:@"observe"];
    configuration.userContentController = controller;

    url = [NSURL URLWithString:KEY_WEBPAGE0];

    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 66,
                                                           self.view.bounds.size.width,
                                                           self.view.bounds.size.height - 155) configuration:configuration];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
     //self.navigationController.hidesBarsOnSwipe = true;
}

- (void)viewDidUnload {
    self.webView = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [self.webView evaluateJavaScript:exec completionHandler:nil];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UISegmentedControl
- (IBAction)WebTypeChanged:(id)sender {
    
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    //NSURL *url ;
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

#pragma mark - Button
-(IBAction)backButtonPressed:(id)sender {
    [self.webView goBack];
}

-(IBAction)forwardButtonPressed:(id)sender {
    [self.webView goForward];
}

-(IBAction)stopButtonPressed:(id)sender {
    [self.webView stopLoading];
}

-(IBAction)refreshButtonPressed:(id)sender {
    [self.webView reload];
}

#pragma mark - Activityview
- (IBAction)actionButton:(id)sender {
    NSString *message;
    message = @"Check out this web site";
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, url, image];
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        avc.popoverPresentationController.barButtonItem = self.action;
        avc.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:avc animated:YES completion:nil];
}

@end
