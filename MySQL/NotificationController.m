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
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone:)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showedit:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = editButton;

    [self.customMessage setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.customMessage setFont:CELL_FONT(IPHONEFONT18) ];
     self.customMessage.placeholder = @"enter notification";
    
    [[UITextField appearance] setTintColor:[UIColor orangeColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"Notification", nil);
    self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
    self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    //[self.customMessage becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button
- (void)showdone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showedit:(id)sender {
    [self performSegueWithIdentifier:@"notificationdetailsegue" sender:self];
}


#pragma mark - textfield
-(IBAction)textFieldReturn:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - notification
- (IBAction)saveNotification:(id)sender {
    
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
                    notification.repeatInterval = 0;
                    break;
                case 1:
                    notification.repeatInterval = NSCalendarUnitDay;
                    break;
                case 2:
                    notification.repeatInterval = NSCalendarUnitWeekOfYear;
                    break;
                case 3:
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
            notification.category = NOTIFICATION_CATEGORY; //INVITE_CATEGORY
            notification.alertAction = NSLocalizedString(NOTIFICATION_ACTION, nil);
            notification.alertTitle = NSLocalizedString(NOTIFICATION_TITLE, nil);
        }
        if (allowsBadge)
        {
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] BADGENO;
        }
        if (allowsSound)
        {
            notification.soundName = @"Tornado.caf";//UILocalNotificationDefaultSoundName;
        }

              // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
              // this will fire the notification right away, it will still also fire at the date we set
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    //-----------------------------added---------------------------------
        self.customMessage.text = @"";
  //---------------------------------------------------------------------

    }
    // we're creating a string of the date so we can log the time the notif is supposed to fire
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        
    NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
    [DateFormatter setDateFormat:NOTIDATE];
    [DateFormatter setTimeZone:[NSTimeZone defaultTimeZone]]; //[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString *notifDate = [DateFormatter stringFromDate:_datePicker.date];
    NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
    }
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
