//
//  UserDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/4/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "UserDetailController.h"

@interface UserDetailController ()

@end

@implementation UserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"User Detail", nil);
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    
    self.usernameField.text = self.username;
    self.emailField.text = self.email;
    self.phoneField.text = self.phone;
    //self.passwordField.text = self.password;
    self.userimageView.image = self.userimage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
