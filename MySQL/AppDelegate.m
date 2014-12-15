//
//  AppDelegate.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MyTableController.h"

@implementation AppDelegate

//@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    [Parse setApplicationId:@"lMUWcnNfBE2HcaGb2zhgfcTgDLKifbyi6dgmEK3M"
                  clientKey:@"UVyAQYRpcfZdkCa5Jzoza5fTIPdELFChJ7TVbSeX"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
 /*
    MyTableController *controller = [[MyTableController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    
    // Let's make an object each launch, so there's definitely something to display.
    
    PFObject *object = [PFObject objectWithClassName:@"Customer"];
    [object setObject:@"Sample Text" forKey:@"text"];
    [object setObject:@1 forKey:@"priority"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Refresh the table when the object is done saving.
        [controller loadObjects];
    }]; */
    
    return YES;
}
// Peter Balsamo added this
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
   // application.applicationIconBadgeNumber = 0;
}

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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
