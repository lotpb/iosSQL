//
//  AppDelegate.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MainViewController.h"

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]]; //Nav textcolor
 // [[UIView appearance] setTintColor:[UIColor whiteColor]]; // TabBar textcolor
    
    
//| ------------------------Ipad storyBoard---------------------------------
    
    UIStoryboard *storyboard = [self grabStoryboard];
    
    // display storyboard
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
   /*
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
    } */
    
//| ------------------------parse Key---------------------------------
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parseKey"]) {
    
    //[Parse enableLocalDatastore];
 
    [Parse setApplicationId:@"lMUWcnNfBE2HcaGb2zhgfcTgDLKifbyi6dgmEK3M"
                  clientKey:@"UVyAQYRpcfZdkCa5Jzoza5fTIPdELFChJ7TVbSeX"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    }
    
//| -----------------------loginController Key------------------------
    NSString *storyboardIdentifier;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginKey"])
        storyboardIdentifier = @"loginViewController";
     else
        storyboardIdentifier = @"mainViewController";
    
    UIViewController *rootViewController = [[[[self window] rootViewController] storyboard] instantiateViewControllerWithIdentifier:storyboardIdentifier];
    [[self window] setRootViewController:rootViewController];

//| --------------register Notification Actions-----------------
    
    // First, create an action
    UIMutableUserNotificationAction *acceptAction = [self createAction];
    
    // Second, create a category and tie those actions to it (only the one action for now)
    UIMutableUserNotificationCategory *inviteCategory = [self createCategory:@[acceptAction]];
    
        [self registerSettings:inviteCategory];
    
//| -----------------------register Settings---------------------------
        [self populateRegistrationDomain];
    
    return YES;
}
//| --------------------------END--------------------------------------

- (UIStoryboard *)grabStoryboard {
    
    // determine screen size
    int screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIStoryboard *storyboard;
    
    switch (screenHeight) {
            
            // iPhone 4s
        case 480:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 5s
        case 568:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 6
        case 667:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
            // iPhone 6 Plus
        case 736:
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            break;
            
        default:
            // it's an iPad
            storyboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
            break;
    }
    
    return storyboard;
}

#pragma mark - Notification
#pragma mark Register
- (void)registerSettings:(UIMutableUserNotificationCategory *)category {
    
    UIUserNotificationType types = (UIUserNotificationTypeAlert |
                                    UIUserNotificationTypeBadge |
                                    UIUserNotificationTypeSound);
    
    NSSet *categories = [NSSet setWithObjects:category, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

/*
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
// Get the notifications types that have been allowed, do whatever with them
    UIUserNotificationType allowedTypes = [notificationSettings types];
    NSLog(@"Registered for notification types: %lu",(unsigned long)allowedTypes);
    
    // You can get this setting anywhere in your app by using this:
    // UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
} */

#pragma mark Notification didReceiveLocalNotification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Notification Received" message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
    application.applicationIconBadgeNumber = 0;
}

//| -----------------------notification Actions-----------------------------
#pragma mark Notification Action
- (UIMutableUserNotificationAction *)createAction {
    
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    acceptAction.destructive = YES;  // If YES the actions is red
    acceptAction.authenticationRequired = NO;
 /*
    UIMutableUserNotificationAction* deleteAction = [[UIMutableUserNotificationAction alloc] init];
    [deleteAction setIdentifier:@"delete_action_id"];
    [deleteAction setTitle:@"Delete"];
    [deleteAction setDestructive:YES];
   
    UIMutableUserNotificationAction* replyAction = [[UIMutableUserNotificationAction alloc] init];
    [replyAction setIdentifier:@"reply_action_id"];
    [replyAction setTitle:@"Reply"];
    [replyAction setActivationMode:UIUserNotificationActivationModeForeground];
    [replyAction setDestructive:NO];
    
    UIMutableUserNotificationCategory* deleteReplyCategory = [[UIMutableUserNotificationCategory alloc] init];
    [deleteReplyCategory setIdentifier:@"custom_category_id"];
    [deleteReplyCategory setActions:@[replyAction, deleteAction] forContext:UIUserNotificationActionContextDefault]; */
    
    return acceptAction;
}

- (UIMutableUserNotificationCategory *)createCategory:(NSArray *)actions {
    
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:actions forContext:UIUserNotificationActionContextDefault];
    
    // Add the actions to the category and set the action context
 //   [inviteCategory setActions:@[acceptAction, maybeAction, declineAction] forContext:UIUserNotificationActionContextDefault];
    
    // Set the actions to present in a minimal context
  //  [inviteCategory setActions:@[acceptAction, declineAction]forContext:UIUserNotificationActionContextMinimal];
    
    return inviteCategory;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"])
    {
        NSLog(@"Invite accepted! Handle that somehow...");
    }
    else if([identifier isEqualToString:@"INVITE_CATEGORY"])
    {
        NSLog(@"Reply was pressed");
    }

    completionHandler();
}
//| -----------------------END------------------------------------------

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
  //  NSLog(@"%s", __PRETTY_FUNCTION__);
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
   // NSLog(@"%s", __PRETTY_FUNCTION__);
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//| -------------------register SETTINGS--------------------------------
#pragma mark - Settings
- (void)populateRegistrationDomain
{
    NSURL *settingsBundleURL = [[NSBundle mainBundle] URLForResource:@"Settings" withExtension:@"bundle"];
    
    // Invoke loadDefaultsFromSettingsPage:inSettingsBundleAtURL: on the property
    // list file for the root settings page (always named Root.plist).
    NSDictionary *appDefaults = [self loadDefaultsFromSettingsPage:@"Root.plist" inSettingsBundleAtURL:settingsBundleURL];
    
    // appDefaults is now populated with the preferences and their default values.
    // Add these to the registration domain.
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//| -------------------SETTINGS---------------------------------------

- (NSDictionary*)loadDefaultsFromSettingsPage:(NSString*)plistName inSettingsBundleAtURL:(NSURL*)settingsBundleURL
{
    // Each page of settings is represented by a property-list file that follows
    // the Settings Application Schema:
    // <https://developer.apple.com/library/ios/#documentation/PreferenceSettings/Conceptual/SettingsApplicationSchemaReference/Introduction/Introduction.html>.
    
    // Create an NSDictionary from the plist file.
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfURL:[settingsBundleURL URLByAppendingPathComponent:plistName]];
    
    // The elements defined in a settings page are contained within an array
    // that is associated with the root-level PreferenceSpecifiers key.
    NSArray *prefSpecifierArray = settingsDict[@"PreferenceSpecifiers"];
    
    // If prefSpecifierArray is nil, something wen't wrong.  Either the
    // specified plist does ot exist or is malformed.
    if (prefSpecifierArray == nil)
        return nil;
    
    // Create a dictionary to hold the parsed results.
    NSMutableDictionary *keyValuePairs = [NSMutableDictionary dictionary];
    
    for (NSDictionary *prefItem in prefSpecifierArray)
        // Each element is itself a dictionary.
    {
        // What kind of control is used to represent the preference element in the
        // Settings app.
        NSString *prefItemType = prefItem[@"Type"];
        // How this preference element maps to the defaults database for the app.
        NSString *prefItemKey = prefItem[@"Key"];
        // The default value for the preference key.
        NSString *prefItemDefaultValue = prefItem[@"DefaultValue"];
        
        if ([prefItemType isEqualToString:@"PSChildPaneSpecifier"])
            // If this is a 'Child Pane Element'.  That is, a reference to another
            // page.
        {
            // There must be a value associated with the 'File' key in this preference
            // element's dictionary.  Its value is the name of the plist file in the
            // Settings bundle for the referenced page.
            NSString *prefItemFile = prefItem[@"File"];
            
            // Recurs on the referenced page.
            NSDictionary *childPageKeyValuePairs = [self loadDefaultsFromSettingsPage:prefItemFile inSettingsBundleAtURL:settingsBundleURL];
            
            // Add the results to our dictionary
            [keyValuePairs addEntriesFromDictionary:childPageKeyValuePairs];
        }
        else if (prefItemKey != nil && prefItemDefaultValue != nil)
            // Some elements, such as 'Group' or 'Text Field' elements do not contain
            // a key and default value.  Skip those.
        {
            keyValuePairs[prefItemKey] = prefItemDefaultValue;
        }
    }
    
    return keyValuePairs;
}

@end
