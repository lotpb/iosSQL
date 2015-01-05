//
//  AppPrefViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/17/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "AppPrefViewController.h"
#import "SWRevealViewController.h"
#import "Constants.h"

// The value for the 'Text Color' setting is stored as an integer between
// one and three inclusive.  This enumeration provides a mapping between
// the integer value, and color.
typedef NS_ENUM(NSUInteger, TextColor) {
    blue = 1,
    red,
    green
};

// It's best practice to define constant strings for each preference's key.
// These constants should be defined in a location that is visible to all
// source files that will be accessing the preferences.

//Root.plist
NSString* const kFontKey	        	= @"fontKey";
NSString* const kFontSizeKey		   	= @"fontsizeKey";
NSString* const kFontColorKey	       	= @"nameColorKey";
//NSString* const kiCloudKey	    	   	= @"icloudKey";
NSString* const kLoginKey	    	   	= @"loginKey";
NSString* const kRegKey	            	= @"registered";
//NSString* const kLatitudeKey	   	   	= @"latitudeKey";
//NSString* const kLongtitudeKey	   	   	= @"longtitudeKey";

//EditProfile.plist
NSString* const kFirstNameKey			= @"firstNameKey";
NSString* const kLastNameKey			= @"lastNameKey";
NSString* const kWebSiteKey			    = @"websiteKey";
NSString* const kEmailKey		    	= @"emailKey";
NSString* const kUserNameKey			= @"username";
NSString* const kPasswordKey		    = @"password";

//Notification.plist
NSString* const kVerseKey		    	= @"verseKey";
NSString* const kParseKey	     	    = @"parseKey";
//NSString* const kProductNewsKey	    	= @"productNewsKey";

@interface AppPrefViewController ()

// Values from the app's preferences
@property (strong) NSString *firstName;
@property (strong) NSString *lastName;
@property (strong) NSString *Font;
@property (strong) NSString *FontSize;
@property (strong) UIColor *nameColor;

@end


@implementation AppPrefViewController

//| ----------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    // Only iOS 8 and above supports the UIApplicationOpenSettingsURLString
    // used to launch the Settings app from your application.  If the
    // UIApplicationOpenSettingsURLString is not present, we're running on an
    // old version of iOS.  Remove the Settings button from the navigation bar
    // since it won't be able to do anything.
    
/*     if (&UIApplicationOpenSettingsURLString == NULL) {
        self.navigationItem.leftBarButtonItem = nil;
    } */
}

- (void)showdone{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//| ----------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load our preferences.  Preloading the relevant preferences here will
    // prevent possible diskIO latency from stalling our code in more time
    // critical areas, such as tableView:cellForRowAtIndexPath:, where the
    // values associated with these preferences are actually needed.
    [self onDefaultsChanged:nil];
    
    // Begin listening for changes to our preferences when the Settings app does
    // so, when we are resumed from the backround, this will give us a chance to
    // update our UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDefaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}


//| ----------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Stop listening for the NSUserDefaultsDidChangeNotification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}


//| ----------------------------------------------------------------------------
//! Unwind action for the Done button on the Info screen.
//
- (IBAction)unwindFromInfoScreen:(UIStoryboardSegue *)sender
{ }

#pragma mark -
#pragma mark Preferences

//| ----------------------------------------------------------------------------
//! Launches the Settings app.  The Settings app will automatically navigate to
//! to the settings page for this app.
//
- (IBAction)openApplicationSettings:(id)sender
{
    // UIApplicationOpenSettingsURLString is only availiable in iOS 8 and above.
    // The following code will crash if run on a prior version of iOS.  See the
    // check in -viewDidLoad.
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}


//| ----------------------------------------------------------------------------
//  Handler for the NSUserDefaultsDidChangeNotification.  Loads the preferences
//  from the defaults database into the holding properies, then asks the
//  tableView to reload itself.
//
- (void)onDefaultsChanged:(NSNotification *)aNotification
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    self.firstName = [standardDefaults objectForKey:kFirstNameKey];
    self.lastName = [standardDefaults objectForKey:kLastNameKey];
    self.Font = [standardDefaults objectForKey:kFontKey];
    self.FontSize = [standardDefaults objectForKey:kFontSizeKey];
    // The value for the 'Text Color' setting is stored as an integer between
    // one and three inclusive.  Convert the integer into a UIColor object.
    TextColor textColor = [standardDefaults integerForKey:kFontColorKey];
    switch (textColor) {
        case blue:
            self.nameColor = [UIColor blueColor];
            break;
        case red:
            self.nameColor = [UIColor redColor];
            break;
        case green:
            self.nameColor = [UIColor orangeColor];
            break;
        default:
            NSAssert(NO, @"Got an unexpected value %@ for %@", @(textColor), kNameColorKey);
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


//| ----------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}


//| ----------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NameCell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
    cell.textLabel.textColor = self.nameColor;
    cell.detailTextLabel.textColor = self.nameColor;
    
    return cell;
}
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontCell"];
        
        cell.textLabel.text = self.Font;
        cell.detailTextLabel.text = self.Font;
        
        return cell;
    }
return nil;
    }

@end
