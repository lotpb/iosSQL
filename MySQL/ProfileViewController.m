//
//  ProfileViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/11/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.layer.borderWidth = 3.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.clipsToBounds = YES;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
}

- (void)showdone{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
