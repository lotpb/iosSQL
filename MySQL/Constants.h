//
//  Constants.h
//  TutorialParse
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

//Keys of the object "Image"
#define KEY_IMAGE @"imageFile" //news
#define KEY_CREATION_DATE @"createdAt" //news
#define KEY_FONT @"ArialMT" //news

#define NAVBARCOLOR [UIColor redColor] //blog

     // For text, messages, etc
//#define DEFAULT_FONTSIZE    14
//#define DEFAULT_FONT(s)     [UIFont fontWithName:@"HelveticaNeue" size:s]
//#define DEFAULT_BOLDFONT(s) [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]

     // For table cells
#define CELL_FONTSIZE    14
#define CELL_FONT(s)     [UIFont fontWithName:@"HelveticaNeue" size:s]
#define CELL_THINFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
#define CELL_LIGHTFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define CELL_MEDFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
#define CELL_BOLDFONT(s) [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]

#define KEY_DATESQLFORMAT @"yyyy-MM-dd" //new dataView
#define KEY_DATETIME @"yyyy-MM-dd HH:mm:ss" //news
#define KEY_DATEREFRESH @"MMM d, h:mm a"
#define KEY_USER @"username"  // BogNew
#define KEY_EMAIL @"emailKey"  // BogNew
#define NY_LATITUDE 40.714353  //  MapController.h
#define NY_LONGTITUDE -74.005973
#define ROW_HEIGHT 44.0f

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
#define KEY_WEBPAGE4 @"http://finance.yahoo.com/mb/GTATQ/"
#define KEY_WEBPAGE5 @"http://stocktwits.com/symbol/FB"


//#define KEY_UPDATE @"updateAt"
//#define KEY_GEOLOC @"location"
//#define WALL_OBJECT @"WallImageObject"
//#define KEY_COMMENT @"comment"

@end
