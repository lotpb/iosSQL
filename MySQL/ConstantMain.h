//
//  ConstantMain.h
//  MySQL
//
//  Created by Peter Balsamo on 4/26/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstantMain : NSObject

//#ifndef MySQL_ConstantMain_h
//#define MySQL_ConstantMain_h

// MAINVIEW
#define CELL_FONTSIZE     14
#define CELL_FONT(s)      [UIFont fontWithName:@"Avenir-Book" size:s]//Avenir-Black
#define HEADFONTSIZE    13
#define HEADTEXTCOLOR   [UIColor whiteColor]
#define LINECOLOR1     [UIColor greenColor]
#define LINECOLOR2     [UIColor redColor]
#define LINECOLOR3     [UIColor redColor]
#define SEDGEINSERT           44, 0, 0, 0
#define SDIM                 YES //dimsBackgroundDuringPresentation
#define SHIDE                YES //hidesNavigationBarDuringPresentation
#define SDEFINE              YES //definesPresentationContext
#define SHIDEBAR             YES //hidesBottomBarWhenPushed
#define SEARCHBARSTYLE      UIBarStyleBlack
//#define HEADTITLE1    @"NASDAQ \n4,727.35"
#define HEADTITLE2      @"NASDAQ \n4,727.35"
#define HEADTITLE3      @"DOW \n17,776.80"
#define IDCELL            @"BasicCell"
#define KEY_DATEREFRESH  @"MMM d, h:mm a"
#define UPDATETEXT       @"Last update: %@"
#define REFRESHCOLOR     [UIColor blackColor]
#define REFRESHTEXTCOLOR [UIColor whiteColor]
#define TABTINTCOLOR     [UIColor whiteColor]
#define MAINNAVLOGO           @"mySQLHOME.png"
#define BACKGROUNDCOLOR   [UIColor blackColor]
#define MAINNAVCOLOR       [UIColor blackColor]
#define NAVTRANSLUCENT     YES




#define SOUNDFILE     @"%@/03 A Whiter Shade Of Pale.mp3"
//------notification-------------------------------
#define MNOTIFTEXT         @"Lord give me wisdom, ask for wisdom and it will be given!"
#define MNOTIFCATEGORY     @"INVITE_CATEGORY"
#define MAINNOTIFACTION    @"View Details"
#define MAINNOTIFTITLE     @"Item Due"
//------searchbar-------------------------------
#define SEARCHTINTCOLORMAIN  [UIColor redColor]
#define MHIDE                 NO //hidesNavigationBarDuringPresentation
//------sidebar revealViewController-------------------------------
#define SIDEBARTINTCOLOR     [UIColor whiteColor]
//------tableheader-------------------------------
#define MAINHEADHEIGHT     175.0
#define HEADERIMAGE        @"IMG_1133NEW.jpg" //400x175
#define MAINLABELSIZE1     12, 122, tableView.frame.size.width, 45
#define MAINLABELSIZE2     85, 122, tableView.frame.size.width, 45
#define MAINLABELSIZE3     158, 122, tableView.frame.size.width, 45
#define MAINLINESIZE1      12, 162, 60, 1.5
#define MAINLINESIZE2      85, 162, 60, 1.5
#define MAINLINESIZE3      158, 162, 60, 1.5
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
//------pickerview-------------------------------
#define PICKCOLOR         [UIColor whiteColor]     //backgroundColor
#define PICKTOOLSTYLE     UIBarStyleBlackOpaque    //toolbar.barStyle
#define PICKTOOLTRANS     NO                       //toolbar.translucent
#define SHOWIND           YES                      //showsSelectionIndicator
#define DATEPKCOLOR       [UIColor lightGrayColor] //datepicker backgroundColor
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
