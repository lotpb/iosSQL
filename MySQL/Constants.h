//
//  Constants.h
//  TutorialParse
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// Device Info
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) /** BOOL: Detect if device is an iPad **/

#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) /** BOOL: Detect if device is an iPhone or iPod **/

#define IS_IPHONE5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE /** BOOL: Detect if device is an iPhone5 or not **/

/** BOOL: IS_RETINA **/
#define IS_RETINA_DEVICE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] >= 2)

// Return "YES" or "NO" string based on boolean value
#define NSStringFromBool(b) (b ? @"YES" : @"NO")

// Colors
#define UA_RGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define UA_RGB(r,g,b)       UA_RGBA(r, g, b, 1.0f)

#define DATE_COMPONENTS         NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit /** Return date component**/
#define TIME_COMPONENTS         NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit /** Return time component**/

#define USER_DEFAULTS           [NSUserDefaults standardUserDefaults]
#define NOTIFICATION_CENTER     [NSNotificationCenter defaultCenter]
#define SHARED_APPLICATION      [UIApplication sharedApplication]

#define DATE_FORMAT_DD_MM_YYYY              @"dd-MM-yyyy"               //e.g. 24-07-1990
#define DATE_FORMAT_MM_DD_YYYY              @"MM-dd-yyyy"               //e.g. 07-24-1990
#define DATE_FORMAT_YYYY_MM_DD              @"yyyy-MM-dd"               //e.g. 1990-07-24
#define DATE_FORMAT_DD_MM_YYYY_HH_MM_12H    @"dd-MM-yyyy hh:mm a"       //e.g. 24-07-1990 05:20 AM
#define DATE_FORMAT_MMM_DD_YYYY             @"MMM dd, yyyy"             //e.g. Jul 24, 1990
#define DATE_FORMAT_MMMM_DD                 @"MMMM dd"                  //e.g. July 24
#define DATE_FORMAT_MMMM                    @"MMMM"                     //e.g. July, November
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_SS    @"MMM dd, yyyy hh:mm:ss a"  //e.g. Jul 24, 2014 05:20:50 AM
#define DATE_FORMAT_MMM_DD_YYYY_HH_MM_12H   @"MMM dd, yyyy hh:mm a"     //e.g. Jul 24, 2014 05:20 AM
#define DATE_FORMAT_HH_MM_SS                @"HH:mm:ss"                 //e.g. 05:20:50 AM
#define DATE_FORMAT_E                       @"E"                        //e.g. Tue
#define DATE_FORMAT_EEEE                    @"EEEE"                     //e.g. Tuesday
#define DATE_FORMAT_QQQ                     @"QQQ"                      //e.g. Q1,Q2,Q3,Q4
#define DATE_FORMAT_QQQQ                    @"QQQQ"                      //e.g. 4th quarter

// All STORYBOOKS
//Navigation - Go back - POP view controller **/
#define GOBACK [self.navigationController popViewControllerAnimated:YES]
//------searchbar-------------------------------
#define SEARCHBARSTYLE      UIBarStyleBlack
#define SEARCHTINTCOLOR     [UIColor whiteColor]
#define SEARCHBARTINTCOLOR  [UIColor clearColor]
#define SEDGEINSERT           44, 0, 0, 0
#define SDIM                 YES //dimsBackgroundDuringPresentation
#define SHIDE                YES //hidesNavigationBarDuringPresentation
#define SDEFINE              YES //definesPresentationContext
#define SHIDEBAR             YES //hidesBottomBarWhenPushed
//--------searchbar LookupControllers--------------
#define LDIM                 NO //dimsBackgroundDuringPresentation
#define LHIDE                NO //hidesNavigationBarDuringPresentation
//------navigationController-------------------------------
#define MAINNAVCOLOR       [UIColor blackColor]
#define NAVTRANSLUCENT     YES
#define NAVTINTCOLOR       [UIColor grayColor]
//------parse-------------------------------
#define kPFCACHEPOLICY    kPFCachePolicyNetworkElseCache
//kPFCachePolicyIgnoreCache //kPFCachePolicyCacheOnly// kPFCachePolicyNetworkOnly
//kPFCachePolicyCacheElseNetwork //kPFCachePolicyNetworkElseCache //kPFCachePolicyCacheThenNetwork
#define QACTIVE            @"Active" //Query Active
//------tableviewcell-------------------------------
#define IDCELL            @"BasicCell"
#define TABLECELLIMAGE    @"DemoCellImage"
#define BACKGROUNDCOLOR   [UIColor blackColor]
#define ROW_HEIGHT        44.0f
#define CELL_TITLEFONTSIZE 20
#define CELL_FONTSIZE     14
#define CELL_FONT(s)      [UIFont fontWithName:@"Avenir-Book" size:s]//Avenir-Black
#define CELL_FONT1(s)     [UIFont fontWithName:@"HelveticaNeue" size:s]//Avenir-Black
#define CELL_THINFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
#define CELL_LIGHTFONT(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define CELL_MEDFONT(s)   [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
#define CELL_BOLDFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define DATECOLORTEXT     [UIColor whiteColor]
#define DATECOLORBACK     [UIColor redColor]
#define NUMCOLORBACK      [UIColor darkGrayColor]
//------tableHeader-------------------------------
//#define HEADTITLE1    @"NASDAQ \n4,727.35"
#define HEADTITLE2      @"NASDAQ \n4,727.35"
#define HEADTITLE3      @"DOW \n17,776.80"
#define HEADTEXTCOLOR   [UIColor whiteColor]
#define HEADFONTSIZE    13
#define HEADHEIGHT      55.0
#define LABELSIZE1      12, 3, tableView.frame.size.width, 45
#define LABELSIZE2      85, 3, tableView.frame.size.width, 45
#define LABELSIZE3      158, 3, tableView.frame.size.width, 45
#define LINESIZE1       12, 45, 60, 1.5
#define LINESIZE2       85, 45, 60, 1.5
#define LINESIZE3       158, 45, 60, 1.5
#define LINECOLOR1     [UIColor greenColor]
#define LINECOLOR2     [UIColor greenColor]
#define LINECOLOR3     [UIColor redColor]
//------tabBar Controller-------------------------------
#define TABTINTCOLOR     [UIColor whiteColor]
//------refreshControl-------------------------------
#define KEY_DATEREFRESH  @"MMM d, h:mm a"
#define UPDATETEXT       @"Last update: %@"
#define REFRESHCOLOR     [UIColor blackColor]
#define REFRESHTEXTCOLOR [UIColor whiteColor]
//------navigationLogoimage-------------------------------
#define MAINNAVLOGO           @"mySQLHOME.png"
#define BLOGNAVLOGO           @"mySQLBLOG.png"
#define NEWSNAVLOGO           @"mySQLNEWS.png"
//------curser color-------------------------------
#define CURSERCOLOR        [UIColor grayColor]
//------buttons------------------------------------
#define LIKEFONTSIZE      9
#define LIKEFONT(s)       [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define LIKECOLORTEXT     [UIColor whiteColor]
#define LIKECOLORBACK     [UIColor redColor]
#define ACTIVEBUTTONYES   @"iosStar.png"
#define ACTIVEBUTTONNO    @"iosStarNA.png"
//------dates-------------------------------
#define KEY_DATESQLFORMAT     @"yyyy-MM-dd" //NewDataView, LeadDetail
//------timer-------------------------------
//#define MTIMER           5.0 //MainController
//#define MTIMERREP        NO  //repeats
//------textview border-------------------------------
#define TEXTBDSTYLE     UITextBorderStyleRoundedRect //borderStyle
#define TEXTBDCOLOR     [UIColor colorWithRed:151.0/255.0f green:193.0/255.0f blue:252.0/255.0f alpha:1.0f].CGColor  //layer.borderColor
#define TEXTBDWIDTH     2.0f //layer.borderWidth
#define TEXTBDRADIUS    7.0f //layer.cornerRadius
//------deletetable-------------------------------
#define DELMESSAGE1           @"Delete"
#define DELMESSAGE2           @"OK, Delete the selected record?"
//-----------------------END-------------------------------

// MAINVIEW
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
//#define HEADERIMAGE        @"IMG_1133NEW.jpg" //400x175
#define MAINLABELSIZE1     12, 125, tableView.frame.size.width, 45
#define MAINLABELSIZE2     85, 125, tableView.frame.size.width, 45
#define MAINLABELSIZE3     158, 125, tableView.frame.size.width, 45
#define MAINLABELSIZE4     12, 5, tableView.frame.size.width, 20
#define MAINLINESIZE1      12, 166, 60, 1.5
#define MAINLINESIZE2      85, 166, 60, 1.5
#define MAINLINESIZE3      158, 166, 60, 1.5
#define MAINWEATHERSIZE1   12, 50, 60, 1.5
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

//STATISTIC
#define STATFONTSIZE       11
#define STATTEXTCOLOR      [UIColor orangeColor]
#define STATBACKCOLOR      [UIColor lightGrayColor]
#define SLNAME1             @"Appointment's Today"
#define SLNAME2             @"Appointment's Tomorrow"
#define SLNAME3             @"Leads Today"
#define SLNAME4             @"Leads Active"
#define SLNAME5             @"Leads Year"
#define SLNAME6             @"Leads Avg"
#define SLNAME7             @"Leads High"
#define SLNAME8             @"Leads Low"

#define SCNAME1             @"Customers Today"
#define SCNAME2             @"Customers Yesterday"
#define SCNAME3             @"Customers Active"
#define SCNAME4             @"Customers Year"
#define SCNAME5             @"Customer Avg"
#define SCNAME6             @"Customer High"
#define SCNAME7             @"Customer Low"
#define SCNAME8             @"Windows Sold"

// LEAD
#define LEADDELETENO       @"_leadNo=%@&&"
#define LEADDELETENO1      _leadNo
#define LEADDELETEURL      @"http://localhost:8888/deleteLeads.php"
#define LEADSCOPE          @"name",@"city",@"phone",@"date",@"active"
//------segue-------------------------------
#define LEADVIEWSEGUE      @"detailSegue"
#define LEADNEWSEGUE       @"newLeadSeque"

// CUSTOMER
#define CUSTDELETENO        @"_custNo=%@&&"
#define CUSTDELETENO1       _custNo
#define CUSTDELETEURL       @"http://localhost:8888/deleteCustomer.php"
#define CUSTSCOPE           @"name",@"city",@"phone",@"date", @"active"
//------segue-------------------------------
#define CUSTVIEWSEGUE      @"detailCustSegue"
#define CUSTNEWSEGUE       @"newCustSeque"

// VENDOR
#define VENDDELETENO        @"_vendorNo=%@&&"
#define VENDDELETENO1       _vendorNo
#define VENDORDELETEURL     @"http://localhost:8888/deleteVendor.php"
#define VENDSCOPE           @"name",@"city",@"phone",@"department"
//------segue-------------------------------
#define VENDVIEWSEGUE       @"venddetailSegue"
#define VENDNEWSEGUE        @"newVendSeque"

// EMPLOYEE
#define EMPLOYDELETENO      @"_employeeNo=%@&&"
#define EMPLOYDELETENO1     _employeeNo
#define EMPLOYEEDELETEURL   @"http://localhost:8888/deleteEmployee.php"
#define EMPLOYSCOPE         @"name",@"city",@"phone",@"active"
//------segue-------------------------------
#define EMPLOYVIEWSEGUE    @"employdetailSegue"
#define EMPLOYNEWSEGUE     @"newEmplySegue"

// PRODUCT
#define PRODDELETENO       @"_productNo=%@&&"
#define PRODDELETENO1      _productNo
#define PRODUCTDELETEURL   @"http://localhost:8888/deleteProduct.php"
#define PRODSCOPE          @"product",@"productNo",@"active"
//------segue-------------------------------
#define PRODVIEWSEGUE      @"productDetailSegue"

// ADVERTISING
#define ADDELETENO         @"_adNo=%@&&"
#define ADDELETENO1        _adNo
#define ADDELETEURL        @"http://localhost:8888/deleteAdvertising.php"
#define ADSCOPE            @"advertiser",@"adNo",@"active"
//------segue-------------------------------
#define ADVIEWSEGUE        @"adDetailSegue"

// JOB
#define JOBDELETENO        @"_jobNo=%@&&"
#define JOBDELETENO1       _jobNo
#define JOBDELETEURL       @"http://localhost:8888/deleteJob.php"
#define JOBSCOPE          @"job",@"jobNo",@"active"
//------segue-------------------------------
#define JOBVIEWSEGUE       @"jobDetailSegue"

// SALESMAN
#define SALEDELETENO       @"_salesNo=%@&&"
#define SALEDELETENO1      _salesNo
#define SALEDELETEURL      @"http://localhost:8888/deleteSalesman.php"
#define SALESCOPE          @"salesman",@"salesNo",@"active"
//------segue-------------------------------
#define SALEVIEWSEGUE      @"salesmanDetailSegue"
//-----------------------END-------------------------------

// LEADDETAIL
//extern int DETAILFONTSIZE = 9;
#define DETAILFONTSIZE     10
#define DETAILNEWSFONTSIZE 14
#define DETAILNEWS         16
#define DETAILTITLECOLOR   [UIColor blackColor]
#define DETAILSUBCOLOR     [UIColor grayColor]
#define DETAILCOLOR        [UIColor darkGrayColor]
#define DIVIDERCOLOR       [UIColor redColor]
#define LEADNEWSTITLE      @"Customer News Company to expand to a new web advertising directive starting this week."
#define CUSTOMERNEWSTITLE  @"Customer News Check out or new line of fabulous windows and siding."
#define VENDORNEWSTITLE    @"Business News Peter Balsamo Appointed to United's Board of Directors."
#define EMPLOYEENEWSTITLE  @"Employee News Health benifits cancelled immediately, ineffect starting today."
//------segue-------------------------------
#define VIEWSEGUE          @"editFormSegue"
#define NEWCUSTSEGUE       @"newcustSegue"
#define MAPSEGUE           @"mapdetailSegue"
#define CALENDSEGUE        @"calenderSegue"
#define CONTACTSEGUE       @"contactSegue"
//-----------------------END-------------------------------

// BLOG
#define BLOGCELLIMAGE      @"IMG_1378"
#define BLOGIMGRADIUS      5
#define BLOGDELETENO       @"_msgNo=%@&&"
#define BLOGDELETENO1      _msgNo
#define BLOGDELETEURL      @"http://localhost:8888/deleteBlog.php"
#define BLOGLINECOLOR1     [UIColor whiteColor]
#define BLOGSCOPE          @"subject", @"date", @"rating", @"postby"
//------navigationController-------------------------------
#define BLOGNAVBARCOLOR        [UIColor redColor]
#define BLOGNAVBARTINTCOLOR    [UIColor whiteColor]
#define BLOGNAVBARTRANSLUCENT   NO
#define BLOG_FONTSIZE          17
#define SEARCHBARSTYLEBLOG     UIBarStyleDefault
//--------------segue-------------------------------
#define BLOGVIEWSEGUE      @"blogviewSegue"
#define BLOGNEWSEGUE       @"NewBlogSegue"

//-----------------------END-------------------------------

// BLOGEDIT
#define BLOGEDITTITLE      @"Message"
#define BLOGBACKCOLOR      [UIColor lightGrayColor]
//------notification-------------------------------
#define BLOGNOTIFICATION   @"You have entered the region you are monitoring"
#define BNOTIFCATEGORY     @"INVITE_CATEGORY"
#define BNOTIFACTION       @"Details"
#define BNOTIFTITLE        @"Alert! Breaking News"
//-------------segue-------------------------------
#define BLOGEDITSEGUE      @"updateNewSeque"
//-----------------------END-------------------------------

// BLOGNEW
#define KEY_USER          @"usernameKey"
#define KEY_EMAIL         @"emailKey"
#define BLOGNEWBACKCOLOR  [UIColor darkGrayColor]
#define BLOGNEWTITLE      @"Share an idea"

#define BLOGUPDATEFIELD   @"_msgNo=%@&&_msgDate=%@&_subject=%@&_rating=%@&_postby=%@&"
#define BLOGUPDATEFIELD1  _msgNo, _msgDate, _subject, _rating, _postby
#define BLOGUPDATEURL     @"http://localhost:8888/updateBlog.php"

#define BLOGSAVEFIELD     @"_msgDate=%@&&_subject=%@&_rating=%@&_postby=%@&"
#define BLOGSAVEFIELD1    _msgDate, _subject, _rating, _postby
#define BLOGSAVEURL       @"http://localhost:8888/saveBlog.php"
//-----------------------END-------------------------------

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
#define READLABEL        @"News" //Read more
#define NEWSREADCOLOR    [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
//-----------------------END-------------------------------

// WEBCONTROLLER
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
#define KEY_WEBPAGE5 @"http://stocktwits.com/The_Stock_Whisperer"
//-----------------------END-------------------------------

// NOTIFICATION CONTROLLER
#define NOTIDATE    @"MM-dd-yyy hh:mm"
//#define NOTMESSAGE  @"You have a notification. Please check"
#define BADGENO     + 1
#define NSOUND      != 0 //allowsSound
#define NBADGE      != 0 //allowsBadge
#define NALERT      != 0 //allowsAlert
//-----------------------END-------------------------------

// FACEBOOKVIEW - SOCIAL
#define FBMESSAGE       @"Good day everyone"
#define FMMESSAGEURL    @"http://www.test.com"
#define TWEETMESSAGE    @"Happy tweeting everyone"
//-----------------------END-------------------------------

// SIDEBAR CONTROLLER
#define SIDEIMAGETITLE      @"user_male-128.png"
#define SIDEIMAGEBACKCOLOR  [UIColor grayColor]
#define SIDEEMAILTITLE      @"Email Support"
#define SIDEEMAILMESSAGE    @"<h2>Learning iOS Programming!</h2>"
//-----------------------END-------------------------------

// PHOTO COLLECTION
#define PHOTOHEADER           @"Job Pictures #%li"  // CollectionParse
#define PHOTOHEADERIMAGE      @"header_banner.png"
#define PHOTOCELLIMAGE        @"photo-frame-2.png" // cell.backgroundView
#define PHOTOCELLSELECTIMAGE  @"photo-frame.png"  //cell.selectedBackgroundView
#define PHOTOBUTTONTITLE1     @"Share"
#define PHOTOBUTTONTITLE2     @"Upload"

//-----------------------END-------------------------------

// MAPCONTROLLER
#define MAPTITLE           @"Map of Boston"
#define NY_LATITUDE        42.37 //40.714353
#define NY_LONGTITUDE     -71.03 //74.005973
//-----------------------END-------------------------------

//LOOKUP NEWDATA SEGUE
#define LOOKCITYSEGUE   @"lookupCitySegue"
#define LOOKJOBSEGUE    @"lookupJobSegue"
#define LOOKPRODSEGUE   @"lookupProductSegue"
//-----------------------END-------------------------------

//LOOKUP EDITDATA SEGUE
#define EDITLOOKCITYSEGUE   @"lookupcitySegue"
#define EDITLOOKJOBSEGUE    @"lookupjobSegue"
#define EDITLOOKPRODSEGUE   @"lookupproductSegue"
#define EDITLOOKSALESEGUE   @"lookupsalesmanSegue"
//-----------------------END-------------------------------

// EDITDATA
#define HEADERTITLE @"Info"
#define FOOTERTITLE @"MySQL! :)"
#define TEXT_FIELD_TAG_OFFSET 1000  //dismissKeyboard
#define NUM_TEXT_FIELD 5            //dismissKeyboard

#define UPDATEEMPLOYEEFIELD @"_employeeNo=%@&&_company=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_homephone=%@&_workphone=%@&_cellphone=%@&_country=%@&_email=%@&_last=%@&_department=%@&_middle=%@&_first=%@&_manager=%@&_social=%@&_comments=%@&_active=%@&_employtitle=%@&"
#define UPDATEEMPLOYEEFIELD1 _employeeNo, _company, _address, _city, _state, _zip, _homephone, _workphone, _cellphone, _country, _email, _last, _department, _middle, _first, _manager, _social, _comments, _active, _employtitle
#define UPDATEEMPLOYEEURL @"http://localhost:8888/updateEmployee.php"

#define UPDATEVENDORFIELD @"_vendorNo=%@&&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_phone=%@&_phone1=%@&_phone2=%@&_phone3=%@&_email=%@&_webpage=%@&_department=%@&_office=%@&_manager=%@&_profession=%@&_assistant=%@&_comments=%@&_active=%@&_phonecmbo=%@&_phonecmbo1=%@&_phonecmbo2=%@&_phonecmbo3=%@&"
#define UPDATEVENDORFIELD1 _vendorNo, _name, _address, _city, _state, _zip, _phone, _phone1, _phone2, _phone3, _email, _webpage, _department, _office, _manager, _profession, _assistant, _comments, _active, _phonecmbo, _phonecmbo1, _phonecmbo2, _phonecmbo3
#define UPDATEVENDORURL @"http://localhost:8888/updateVendor.php"

#define UPDATECUSTFIELD @"_custNo=%@&&_date=%@&_leadNo=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_quan=%@&_email=%@&_first=%@&_spouse=%@&_rate=%@&_photo=%@&_photo1=%@&_photo2=%@&_salesNo=%@&_jobNo=%@&_start=%@&_complete=%@&_productNo=%@&_contractor=%@&_active=%@&"
#define UPDATECUSTFIELD1 _custNo, _date, _leadNo, _address, _city, _state, _zip, _comments, _amount, _phone, _quan, _email,_first, _spouse, _rate, _photo, _photo1, _photo2,_salesNo, _jobNo, _start, _complete, _productNo, _contractor, _active
#define UPDATECUSTURL @"http://localhost:8888/updateCustomer.php"

#define UPDATELEADFIELD @"_leadNo=%@&&_date=%@&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_aptdate=%@&_email=%@&_first=%@&_spouse=%@&_callback=%@&_salesNo=%@&_jobNo=%@&_adNo=%@&_active=%@&_photo=%@&"
#define UPDATELEADFIELD1 _leadNo, _date, _name, _address, _city, _state, _zip, _comments, _amount, _phone, _aptdate, _email, _first, _spouse, _callback, _salesNo, _jobNo, _adNo, _active, _photo
#define UPDATELEADURL @"http://localhost:8888/updateLeads.php"
//-----------------------END-------------------------------

// NEWDATA
#define SAVEEMPLOYEEFIELD @"_company=%@&&_address=%@&_city=%@&_state=%@&_zip=%@&_homephone=%@&_workphone=%@&_cellphone=%@&_country=%@&_email=%@&_last=%@&_department=%@&_middle=%@&_first=%@&_manager=%@&_social=%@&_comments=%@&_active=%@&_employtitle=%@&"
#define SAVEEMPLOYEEFIELD1 _company, _address, _city, _state, _zip, _homephone, _workphone, _cellphone, _country, _email, _last, _department, _middle, _first, _manager, _social, _comments, _active, _employtitle
#define SAVEEMPLOYEEURL @"http://localhost:8888/saveEmployee.php"

#define SAVEVENDORFIELD @"_name=%@&&_address=%@&_city=%@&_state=%@&_zip=%@&_phone=%@&_phone1=%@&_phone2=%@&_phone3=%@&_email=%@&_webpage=%@&_department=%@&_office=%@&_manager=%@&_profession=%@&_assistant=%@&_comments=%@&_active=%@&_phonecmbo=%@&_phonecmbo1=%@&_phonecmbo2=%@&_phonecmbo3=%@&"
#define SAVEVENDORFIELD1 _name, _address, _city, _state, _zip, _phone, _phone1, _phone2, _phone3, _email, _webpage, _department, _office, _manager, _profession, _assistant, _comments, _active, _phonecmbo, _phonecmbo1, _phonecmbo2, _phonecmbo3
#define SAVEVENDORURL @"http://localhost:8888/saveVendor.php"

#define SAVECUSTFIELD @"_leadNo=%@&&_date=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_quan=%@&_start=%@&_email=%@&_first=%@&_spouse=%@&_rate=%@&_salesNo=%@&_jobNo=%@&_productNo=%@&_active=%@&_photo=%@&_photo1=%@&_photo2=%@&_contractor=%@&_complete=%@&"
#define SAVECUSTFIELD1 _leadNo, _date, _address, _city, _state, _zip, _comments, _amount, _phone, _quan, _start, _email, _first, _spouse, _rate, _salesNo, _jobNo, _productNo, _active, _photo, _photo1, _photo2, _contractor, _complete
#define SAVECUSTOMERURL @"http://localhost:8888/saveCustomer.php"

#define SAVELEADFIELD @"_date=%@&&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_aptdate=%@&_email=%@&_first=%@&_spouse=%@&_callback=%@&_salesNo=%@&_jobNo=%@&_adNo=%@&_active=%@&_photo=%@&"
#define SAVELEADFIELD1 _date, _name, _address, _city, _state, _zip, _comments, _amount, _phone, _aptdate, _email, _first, _spouse, _callback, _salesNo, _jobNo, _adNo, _active, _photo
#define SAVELEADURL @"http://localhost:8888/saveLeads.php"
//-----------------------END-------------------------------

// NEWDATADETAIL
//----------New
#define SAVESALEFIELD @"_salesman=%@&&_active=%@&"
#define SAVESALEFIELD1 _salesman, _active
#define SAVESALEURL @"http://localhost:8888/saveSalesman.php"

#define SAVEJOBFIELD @"_description=%@&&_active=%@&"
#define SAVEJOBFIELD1 _description, _active
#define SAVEJOBURL @"http://localhost:8888/saveJob.php"

#define SAVEPRODFIELD @"_product=%@&&_active=%@&"
#define SAVEPRODFIELD1 _product, _active
#define SAVEPRODURL @"http://localhost:8888/saveProduct.php"

#define SAVEADFIELD @"_advertiser=%@&&_active=%@&"
#define SAVEADFIELD1 _advertiser, _active
#define SAVEADURL @"http://localhost:8888/saveAdvertising.php"
//----------Edit
#define EDITSALEFIELD @"_salesNo=%@&&_salesman=%@&_active=%@&"
#define EDITSALEFIELD1 _salesNo, _salesman, _active
#define EDITSALEURL @"http://localhost:8888/updateSalesman.php"

#define EDITJOBFIELD @"_jobNo=%@&&_description=%@&_active=%@&"
#define EDITJOBFIELD1 _jobNo, _description, _active
#define EDITJOBURL @"http://localhost:8888/updateJob.php"

#define EDITPRODFIELD @"_productNo=%@&&_products=%@&_active=%@&"
#define EDITPRODFIELD1 _productNo, _products, _active
#define EDITPRODURL @"http://localhost:8888/updateProduct.php"

#define EDITADFIELD @"_adNo=%@&&_advertiser=%@&_active=%@&"
#define EDITADFIELD1 _adNo, _advertiser, _active
#define EDITADURL @"http://localhost:8888/updateAdvertising.php"
//-----------------------END-------------------------------

//#define KEY_UPDATE  @"updateAt"
//#define KEY_GEOLOC  @"location"
//#define WALL_OBJECT @"WallImageObject"
//#define KEY_COMMENT @"comment"

@end
