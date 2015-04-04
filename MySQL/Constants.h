//
//  Constants.h
//  TutorialParse
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define KEY_DATESQLFORMAT @"yyyy-MM-dd" //new dataView

//All Storybooks
#define MAINNAVCOLOR   [UIColor blackColor]
#define NAVTRANSLUCENT  YES
#define NAVTINTCOLOR   [UIColor grayColor]

#define CURSERCOLOR       [UIColor grayColor]
#define LIKEFONTSIZE      9
#define LIKEFONT(s)       [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define LIKECOLORTEXT     [UIColor whiteColor]
#define LIKECOLORBACK     [UIColor redColor]

// NEWS
#define SCROLLBACKCOLOR  [UIColor lightGrayColor]
#define VIEWBACKCOLOR    [UIColor whiteColor]
#define SEPARATORCOLOR   [UIColor lightGrayColor]
#define KEY_IMAGE         @"imageFile" //news
#define KEY_CREATION_DATE @"createdAt" //news
#define KEY_DATETIME      @"yyyy-MM-dd HH:mm:ss" //news
#define TITLEFONTSIZE     18
#define KEY_FONTSIZE      11
#define DETAILFONT(s)    [UIFont fontWithName:@"HelveticaNeue" size:s] //ArialMT
#define NEWSTITLECOLOR   [UIColor blackColor] //darkGrayColor
#define NEWSDETAILCOLOR  [UIColor grayColor]
#define NEWSREADCOLOR    [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];//[UIColor magentaColor]
#define READLABEL        @"News" //Read more

//EDITDATA
#define HEADERTITLE @"Info"
#define FOOTERTITLE @"MySQL"
#define TEXT_FIELD_TAG_OFFSET 1000
#define NUM_TEXT_FIELD 5

// BLOG
#define KEY_USER  @"username"  // BogNew
#define KEY_EMAIL @"emailKey"  // BogNew
//#define NAVBARCOLOR [UIColor blackColor]
#define BLOGNAVCOLOR [UIColor redColor]
#define BLOG_FONTSIZE   12

//Photo Collection
#define PHOTOHEADER @"Job Pictures #%li"  // CollectionParse

//LEADDETAIL
#define DETAILFONTSIZE   9
#define DETAILNEWS       12
#define DETAILTITLECOLOR [UIColor blackColor]
#define DETAILSUBCOLOR   [UIColor grayColor]
#define DETAILCOLOR      [UIColor darkGrayColor]
#define DIVIDERCOLOR     [UIColor redColor]

//TABLEHEADER
//#define HEADTITLE1  @"NASDAQ \n4,727.35"
#define HEADTITLE2    @"NASDAQ \n4,727.35"
#define HEADTITLE3    @"DOW \n17,776.80"
#define HEADCOLOR     [UIColor whiteColor]
#define HEADFONTSIZE   13
#define HEADHEIGHT     55.0

//TABBAR
#define TABTINTCOLOR     [UIColor whiteColor]

//REFRESH
#define KEY_DATEREFRESH  @"MMM d, h:mm a"
#define REFRESHCOLOR     [UIColor blackColor]
#define REFRESHTEXTCOLOR [UIColor whiteColor]

// For TABLEVIEWCELL
#define ROW_HEIGHT        44.0f
#define CELL_FONTSIZE     14
#define CELL_FONT(s)      [UIFont fontWithName:@"HelveticaNeue" size:s]
#define CELL_THINFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
#define CELL_LIGHTFONT(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define CELL_MEDFONT(s)   [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
#define CELL_BOLDFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define DATECOLORTEXT     [UIColor whiteColor]
#define DATECOLORBACK     [UIColor redColor]

//MAPCONTROLLER
#define MAPTITLE  @"Map of New York"
#define NY_LATITUDE    42.37 //40.714353
#define NY_LONGTITUDE -71.03//74.005973

//WebMainController
#define KEY_WEBNAME0 @"CNN"
#define KEY_WEBNAME1 @"Drudge"
#define KEY_WEBNAME2 @"cnet"
#define KEY_WEBNAME3 @"Blaze"
#define KEY_WEBNAME4 @"Yahoo"
#define KEY_WEBNAME5 @"Twits"

#define KEY_WEBPAGE0 @"http://www.cnn.com"
#define KEY_WEBPAGE1 @"http://www.Drudgereport.com"
#define KEY_WEBPAGE2 @"http://www.cnet.com"
#define KEY_WEBPAGE3 @"http://www.theblaze.com"
#define KEY_WEBPAGE4 @"http://finance.yahoo.com/mb/UPL/"
#define KEY_WEBPAGE5 @"http://stocktwits.com/symbol/UPL"


//#define KEY_UPDATE  @"updateAt"
//#define KEY_GEOLOC  @"location"
//#define WALL_OBJECT @"WallImageObject"
//#define KEY_COMMENT @"comment"

@end
