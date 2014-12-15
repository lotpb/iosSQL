//
//  AddressViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 11/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AddressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *dictContactDetails;

@property (nonatomic, weak) IBOutlet UILabel *lblContactName;
@property (nonatomic, weak) IBOutlet UIImageView *imgContactImage;
@property (nonatomic, weak) IBOutlet UITableView *tblContactDetails;

-(IBAction)makeCall:(id)sender;
-(IBAction)sendSMS:(id)sender;
@end
