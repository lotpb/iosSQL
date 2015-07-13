//
//  NotificationController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/23/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NotificationController.h"
#import "SWRevealViewController.h"

@interface NotificationController ()

@property (weak, nonatomic) IBOutlet UITextField *customMessage;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *frequencySegmentedControl;

@end

@implementation NotificationController

bool allowNotif;
bool allowsSound;
bool allowsBadge;
bool allowsAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self.customMessage setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.customMessage setFont:CELL_FONT(IPHONEFONT18) ];
     self.customMessage.placeholder = @"enter to send notification";
    
    [[UITextField appearance] setTintColor:[UIColor orangeColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Notification", nil);
    [self.customMessage becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.customMessage resignFirstResponder];
    return NO;
} */

- (void)showdone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveNotification:(id)sender {
    /*
    // New for iOS 8 - Register the notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
     
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
     
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings]; */
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [self setNotificationTypesAllowed];
    if (notification)
    {
        if (allowNotif)
        {
            notification.fireDate = _datePicker.date;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            
            switch (_frequencySegmentedControl.selectedSegmentIndex) {
                case 0:
                    notification.repeatInterval = NSCalendarUnitDay;
                    break;
                case 1:
                    notification.repeatInterval = NSCalendarUnitWeekOfYear;
                    break;
                case 2:
                    notification.repeatInterval = NSCalendarUnitYear;
                    break;
                default:
                    notification.repeatInterval = 0;
                    break;
            }
        }
        if (allowsAlert)
        {
            notification.alertBody = _customMessage.text;
            notification.category = MNOTIFCATEGORY; //INVITE_CATEGORY
            notification.alertAction = NSLocalizedString(MAINNOTIFACTION, nil);
            notification.alertTitle = NSLocalizedString(MAINNOTIFTITLE, nil);
        }
        if (allowsBadge)
        {
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] BADGENO;
        }
        if (allowsSound)
        {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }

              // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
              // this will fire the notification right away, it will still also fire at the date we set
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    //-----------------------------added---------------------------------
        _customMessage.text = @"";
  //---------------------------------------------------------------------

    }
    // we're creating a string of the date so we can log the time the notif is supposed to fire
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:NOTIDATE];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *notifDate = [formatter stringFromDate:_datePicker.date];
        NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate); }
}

- (void)setNotificationTypesAllowed
{
    NSLog(@"%s:", __PRETTY_FUNCTION__);
    // get the current notification settings
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    allowNotif = (currentSettings.types != UIUserNotificationTypeNone);
    allowsSound = (currentSettings.types & UIUserNotificationTypeSound) NSOUND;
    allowsBadge = (currentSettings.types & UIUserNotificationTypeBadge) NBADGE;
    allowsAlert = (currentSettings.types & UIUserNotificationTypeAlert) NALERT;
}

@end
