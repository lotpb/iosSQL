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
//#import <MediaPlayer/MediaPlayer.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    BOOL _isFullScreen;
}
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]]; //Nav textcolor
  //[[UIView appearance] setTintColor:[UIColor whiteColor]]; // TabBar textcolor
    
    // Handle launching from a notification
    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
    }

//| ------------------------parse Key---------------------------------
    
    if ([defaults boolForKey:@"parseKey"]) {
        //Registers current device to Parse
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            [Parse setApplicationId:@"lMUWcnNfBE2HcaGb2zhgfcTgDLKifbyi6dgmEK3M"
                          clientKey:@"UVyAQYRpcfZdkCa5Jzoza5fTIPdELFChJ7TVbSeX"];
            
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
            
            //[PFFacebookUtils initializeFacebook];
            //[Parse enableLocalDatastore];
        });
    }
    
//| ------------------------ipad storyBoard----------------------------
    
    UIStoryboard *storyboard = [self grabStoryboard];
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    
//| -----------------------register login Key------------------------
    
    NSString *storyboardIdentifier;
    if ((![defaults boolForKey:@"registerKey"]) || ([defaults boolForKey:@"loginKey"]))
        storyboardIdentifier = @"loginViewController";
    
    else if ([defaults boolForKey:@"snapshotKey"])
        storyboardIdentifier = @"snapshotController";
    
    else
        storyboardIdentifier = @"mainViewController";
    
    UIViewController *rootViewController = [[[[self window] rootViewController] storyboard] instantiateViewControllerWithIdentifier:storyboardIdentifier];
    
    [[self window] setRootViewController:rootViewController];

     //| ----------------register Notification Actions--------------
    
        [self registerForNotification];

     //| -------------------register Settings-----------------------
    
        [self populateRegistrationDomain];


    //| -----------------------prevent Autolock---------------------
    
    if ([defaults boolForKey:@"autolockKey"]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    
    //| --------------------Background Fetch-------------------------
    
    if ([defaults boolForKey:@"fetchKey"]) {
        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    }
    
     //| ------------movie players to rotate in fullscreen-------------------------
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterFullScreen:)
                                                 name:MPMoviePlayerWillEnterFullscreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willExitFullScreen:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    
    return YES;
}
//| --------------------------END--------------------------------------

#pragma mark - movie players to rotate in fullscreen
- (void)willEnterFullScreen:(NSNotification *)notification
{
    _isFullScreen = YES;
}

- (void)willExitFullScreen:(NSNotification *)notification
{
    _isFullScreen = NO;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_isFullScreen) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    } else {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return UIInterfaceOrientationMaskPortrait;
        }
        return 0;
    }
}

#pragma mark - Storyboard ipad or iphone
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

//| --------------------------END--------------------------------------

#pragma mark - Background Refresh
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"fetchKey"]) {
        
        NSLog(@"########### Received Background Fetch ###########");
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.alertBody = @"Background transfer service: Download complete!";
        localNotification.alertAction = @"Background transfer service download!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //increase the badge number of application plus 1
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        
        //Cleanup
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

#pragma mark - Notification
#pragma mark Register
- (void)registerForNotification {
    
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Accept";
    notificationAction1.title = @"Accept";
    notificationAction1.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction1.destructive = YES;
    notificationAction1.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction2.identifier = @"Reject";
    notificationAction2.title = @"Reject";
    notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction2.destructive = NO;
    notificationAction2.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction3 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction3.identifier = @"Reply";
    notificationAction3.title = @"Reply";
    notificationAction3.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction3.destructive = YES;
    notificationAction3.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Email";
    
    [notificationCategory setActions:@[notificationAction1,notificationAction2,notificationAction3] forContext:UIUserNotificationActionContextDefault];
    
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if([notification.category isEqualToString:@"Email"])
    {
        if ([identifier isEqualToString:@"Accept"])
        {
            NSLog(@"Invite accepted! Handle that somehow...");
        }
        else if([identifier isEqualToString:@"Reject"])
        {
            NSLog(@"Reply was pressed");
        }
    }
    
    completionHandler();
}

#pragma mark Notification didReceiveLocalNotification
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notification Received"
                            message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    application.applicationIconBadgeNumber = 0;
}

#pragma mark RemoteNotification
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

//| -----------------------END------------------------------------------

#pragma mark - application
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
