//
//  ConstantMain.h
//  MySQL
//
//  Created by Peter Balsamo on 4/26/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantMain : NSObject

// MAINVIEW
#define IPADFONT20         20
#define IPADFONT18         18
#define IPADFONT16         16
#define IPHONEFONT20       20
#define IPHONEFONT14       14

#define CELL_FONT(s)      [UIFont fontWithName:@"Avenir-Book" size:s]//Avenir-Black
#define CELL_FONTBOLD(s)  [UIFont fontWithName:@"Avenir-Heavy" size:s]//Avenir-Black
#define HEADTEXTCOLOR     [UIColor whiteColor]
#define LINECOLOR1        [UIColor greenColor]
#define LINECOLOR3        [UIColor redColor]
#define SEDGEINSERT           44, 0, 0, 0
#define SDIM                 YES //dimsBackgroundDuringPresentation
#define SHIDE                YES //hidesNavigationBarDuringPresentation
#define SDEFINE              YES //definesPresentationContext
#define SHIDEBAR             YES //hidesBottomBarWhenPushed
#define SEARCHBARSTYLE       UIBarStyleBlack

#define IDCELL           @"BasicCell"
#define KEY_DATEREFRESH  @"MMM d, h:mm a"
#define UPDATETEXT       @"Last update: %@"
#define REFRESHCOLOR     [UIColor blackColor]
#define REFRESHTEXTCOLOR [UIColor whiteColor]
#define TABTINTCOLOR     [UIColor whiteColor]
#define MAINNAVLOGO      @"mySQLHOME.png"
#define BACKGROUNDCOLOR  [UIColor blackColor]
#define MAINNAVCOLOR     [UIColor blackColor]
#define NAVTRANSLUCENT   YES

#define SOUNDFILE     @"%@/03 A Whiter Shade Of Pale.mp3"
//------notification-------------------------------
#define MAIN_BODY         @"Lord give me wisdom, ask for wisdom and it will be given!"
#define MAIN_CATEGORY     @"INVITE_CATEGORY"
#define MAIN_ACTION       @"View Details"
#define MAIN_ALERTTITLE   @"Item Due"
//------searchbar-------------------------------
#define SEARCHTINTCOLORMAIN  [UIColor redColor]
#define MHIDE                 NO //hidesNavigationBarDuringPresentation
//------sidebar revealViewController-------------------------------
#define SIDEBARTINTCOLOR     [UIColor whiteColor]
//------tableheader-------------------------------

#define MAINHEADHEIGHT     175.0
#define PMAINHEADHEIGHT    225.0

#define MAINLABELSIZE1     12, 124, tableView.frame.size.width, 50
#define MAINLABELSIZE2     90, 124, tableView.frame.size.width, 50
#define MAINLABELSIZE3     163, 124, tableView.frame.size.width, 50
#define MAINLABELSIZE4     12, 5, tableView.frame.size.width, 20

#define PMAINLABELSIZE1    12, 165, tableView.frame.size.width, 50
#define PMAINLABELSIZE2    112, 165, tableView.frame.size.width, 50
#define PMAINLABELSIZE3    210, 165, tableView.frame.size.width, 50
#define PMAINLABELSIZE4    12, 120, tableView.frame.size.width, 20 //ipad

#define MAINLINESIZE1      12, 169, 60, 2.5
#define MAINLINESIZE2      90, 169, 60, 2.5
#define MAINLINESIZE3      163, 169, 60, 2.5

#define PMAINLINESIZE1     12, 215, 64, 3.0
#define PMAINLINESIZE2     112, 215, 64, 3.0
#define PMAINLINESIZE3     210, 215, 64, 3.0

//------table names-------------------------------
#define TNAME1             @"Leads"
#define TNAME2             @"Customers"
#define TNAME3             @"Vendors"
#define TNAME4             @"Employee"
#define TNAME5             @"Advertising"
#define TNAME6             @"Product"
#define TNAME7             @"Job"
#define TNAME8             @"Salesman"
#define TNAME9             @"Blog"

//------segue-------------------------------
#define MAINVIEWSEGUE1   @"leadDetailSegue"
#define MAINVIEWSEGUE2   @"custDetailSegue"
#define MAINVIEWSEGUE3   @"vendDetailSegue"
#define MAINVIEWSEGUE4   @"employeeSegue"
#define MAINVIEWSEGUE5   @"adSegue"
#define MAINVIEWSEGUE6   @"prodSegue"
#define MAINVIEWSEGUE7   @"jobSegue"
#define MAINVIEWSEGUE8   @"saleSegue"
#define MAINVIEWSEGUE9   @"blogSegue"
//-----------------------END-------------------------------

@end
//#endif
