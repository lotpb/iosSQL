//
//  SidebarViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/7/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "PhotoViewController.h"

@interface SidebarViewController ()

@end

@implementation SidebarViewController {
NSArray *menuItems;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor redColor];
    self.tableView.backgroundColor = BACKGROUNDCOLOR;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    menuItems = @[@"title", @"home", @"settings", @"map", @"photo", @"email", @"contacts", @"social", @"notification", @"calender", @"profile"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table
//| ----------------------------------------------------------------------------
// Peter Balsamo added this mail Controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5)
    {
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        
        NSString *emailTitle = SIDEEMAILTITLE;
        NSString *messageBody = SIDEEMAILMESSAGE;
        NSArray *toRecipents =  [NSArray arrayWithObject:[standardDefaults objectForKey:@"emailKey"]];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}
//| ----------------------------------------------------------------------------
// Peter Balsamo added this mail Controller
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
//| ----------------------------------------------------------------------------

  //tried estimateheight but didnt work this logiIn
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ROW_HEIGHT;
}

#pragma mark tableview data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* const userNameKey = KEY_USER;
    NSString* const EmailKey = KEY_EMAIL;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(65, 4, 110, 14)];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(65, 18, 110, 14)];
    UIImageView *activeImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 1, 29, 27)];
    
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0){
 
        activeImage.image = [UIImage imageNamed:SIDEIMAGETITLE];
        activeImage.backgroundColor = SIDEIMAGEBACKCOLOR;
        //[activeImage setTintColor:[UIColor whiteColor]];
        activeImage.contentMode = UIViewContentModeScaleAspectFit;
        activeImage.layer.cornerRadius = activeImage.frame.size.width / 2.2;
        activeImage.layer.borderWidth = 1.5f;
        activeImage.layer.borderColor = [UIColor whiteColor].CGColor;
        activeImage.clipsToBounds = YES;
       [Cell.contentView addSubview:activeImage];
    
        label2.text = [defaults objectForKey:userNameKey];
       [label2 setFont:CELL_FONT(CELL_FONTSIZE)];
        label2.textAlignment = NSTextAlignmentCenter;
       [label2 setTextColor:[UIColor whiteColor]];
       [Cell.contentView addSubview:label2];
        
        label3.text = [defaults objectForKey:EmailKey];
       [label3 setFont:CELL_FONT(CELL_FONTSIZE - 4)];
        label3.textAlignment = NSTextAlignmentCenter;
       [label3 setTextColor:[UIColor lightGrayColor]];
       [Cell.contentView addSubview:label3];
    }
    Cell.backgroundColor = [UIColor darkGrayColor];
    return Cell;
}

#pragma mark - segue

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
