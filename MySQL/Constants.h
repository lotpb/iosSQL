//
//  Constants.h
//  TutorialParse
//
//  Created by Antonio MG on 7/4/12.
//  Copyright (c) 2012 AMG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// All STORYBOOKS

// searchbar
#define SEARCHBARSTYLE      UIBarStyleBlack
#define SEARCHTINTCOLOR     [UIColor whiteColor]
#define SEARCHBARTINTCOLOR  [UIColor clearColor]
//#define DIMBACKGROUND      YES
//#define HIDENAVBAR         YES
//#define DEFINESPRESNT      YES
//#define HIDEBOTTOMBAR      YES
#define EDGEINSERT          44, 0, 0, 0

// navigationController
#define MAINNAVCOLOR   [UIColor blackColor]
#define NAVTRANSLUCENT  YES
#define NAVTINTCOLOR   [UIColor grayColor]

// curser color
#define CURSERCOLOR       [UIColor grayColor]

// buttons
#define LIKEFONTSIZE      9
#define LIKEFONT(s)       [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define LIKECOLORTEXT     [UIColor whiteColor]
#define LIKECOLORBACK     [UIColor redColor]
#define ACTIVEBUTTONYES   @"iosStar.png"
#define ACTIVEBUTTONNO    @"iosStarNA.png"

// parse
#define kPFCACHEPOLICY    kPFCachePolicyNetworkElseCache
//kPFCachePolicyIgnoreCache
//kPFCachePolicyCacheOnly
//kPFCachePolicyNetworkOnly
//kPFCachePolicyCacheElseNetwork
//kPFCachePolicyNetworkElseCache
//kPFCachePolicyCacheThenNetwork

// tableheader
//#define HEADTITLE1    @"NASDAQ \n4,727.35"
#define HEADTITLE2      @"NASDAQ \n4,727.35"
#define HEADTITLE3      @"DOW \n17,776.80"
#define HEADTEXTCOLOR   [UIColor whiteColor]
#define HEADFONTSIZE    13
#define HEADHEIGHT      55.0

#define LABELSIZE1     12, 3, tableView.frame.size.width, 45
#define LABELSIZE2     85, 3, tableView.frame.size.width, 45
#define LABELSIZE3     158, 3, tableView.frame.size.width, 45

#define LINESIZE1      12, 45, 60, 1.5
#define LINESIZE2      85, 45, 60, 1.5
#define LINESIZE3      158, 45, 60, 1.5

#define LINECOLOR1     [UIColor greenColor]
#define LINECOLOR2     [UIColor redColor]
#define LINECOLOR3     [UIColor redColor]

// tabbar
#define TABTINTCOLOR     [UIColor whiteColor]

// refreshcontrol
#define KEY_DATEREFRESH  @"MMM d, h:mm a"
#define UPDATETEXT       @"Last update: %@"
#define REFRESHCOLOR     [UIColor blackColor]
#define REFRESHTEXTCOLOR [UIColor whiteColor]

// tableviewcell
#define ROW_HEIGHT        44.0f
#define CELL_FONTSIZE     14
#define CELL_FONT(s)      [UIFont fontWithName:@"HelveticaNeue" size:s]
#define CELL_THINFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Thin" size:s]
#define CELL_LIGHTFONT(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define CELL_MEDFONT(s)   [UIFont fontWithName:@"HelveticaNeue-Medium" size:s]
#define CELL_BOLDFONT(s)  [UIFont fontWithName:@"HelveticaNeue-Bold" size:s]
#define DATECOLORTEXT     [UIColor whiteColor]
#define DATECOLORBACK     [UIColor redColor]

// navigationLogo
#define MAINNAVLOGO           @"mySQLHOME.png"
#define BLOGNAVLOGO           @"mySQLBLOG.png"
#define NEWSNAVLOGO           @"mySQLNEWS.png"

// dates
#define KEY_DATESQLFORMAT @"yyyy-MM-dd" //new dataView

// MAINVIEW
#define MAINNAVLOGO           @"mySQLHOME.png"
#define SEARCHTINTCOLORMAIN  [UIColor redColor]
#define SIDEBARTINTCOLOR     [UIColor whiteColor]
// tableheader
#define MAINHEADHEIGHT     175.0
#define HEADERIMAGE        @"IMG_1133NEW.jpg" //400x175
#define MAINLABELSIZE1     12, 122, tableView.frame.size.width, 45
#define MAINLABELSIZE2     85, 122, tableView.frame.size.width, 45
#define MAINLABELSIZE3     158, 122, tableView.frame.size.width, 45

#define MAINLINESIZE1      12, 162, 60, 1.5
#define MAINLINESIZE2      85, 162, 60, 1.5
#define MAINLINESIZE3      158, 162, 60, 1.5

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
#define NEWSREADCOLOR    [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
#define READLABEL        @"News" //Read more

// VENDOR
#define VENDDELETENO       @"_vendorNo=%@&&"
#define VENDDELETENO1      _vendorNo
#define VENDORDELETEURL    @"http://localhost:8888/deleteVendor.php"
// EMPLOYEE
#define EMPLOYDELETENO     @"_employeeNo=%@&&"
#define EMPLOYDELETENO1    _employeeNo
#define EMPLOYEEDELETEURL  @"http://localhost:8888/deleteEmployee.php"
// PRODUCT
#define PRODDELETENO       @"_productNo=%@&&"
#define PRODDELETENO1      _productNo
#define PRODUCTDELETEURL    @"http://localhost:8888/deleteProduct.php"
// ADVERTISING
#define ADDELETENO         @"_adNo=%@&&"
#define ADDELETENO1        _adNo
#define ADDELETEURL        @"http://localhost:8888/deleteAdvertising.php"
// JOB
#define JOBDELETENO        @"_jobNo=%@&&"
#define JOBDELETENO1       _jobNo
#define JOBDELETEURL       @"http://localhost:8888/deleteJob.php"
// SALESMAN
#define SALEDELETENO       @"_salesNo=%@&&"
#define SALEDELETENO1      _salesNo
#define SALEDELETEURL      @"http://localhost:8888/deleteSalesman.php"
// CUSTOMER
#define CUSTDELETENO       @"_custNo=%@&&"
#define CUSTDELETENO1      _custNo
#define CUSTDELETEURL      @"http://localhost:8888/deleteCustomer.php"
// LEAD
#define LEADDELETENO       @"_leadNo=%@&&"
#define LEADDELETENO1      _leadNo
#define LEADDELETEURL      @"http://localhost:8888/deleteLeads.php"


// BLOG
#define KEY_USER         @"username"  // BogNew
#define KEY_EMAIL        @"emailKey"  // BogNew
#define BLOGDELETEURL    @"http://localhost:8888/deleteBlog.php"
#define BLOGLINECOLOR1   [UIColor whiteColor]
// navigationController
#define BLOGNAVBARCOLOR        [UIColor redColor]
#define BLOGNAVBARTINTCOLOR    [UIColor whiteColor]
#define BLOGNAVBARTRANSLUCENT   NO
#define BLOG_FONTSIZE         12
#define SEARCHBARSTYLEBLOG    UIBarStyleDefault

// BLOGEDIT
#define BLOGTABLEIMAGE    @"DemoCellImage"

// BLOGNEW
#define BLOGUPDATEURL     @"http://localhost:8888/updateBlog.php"
#define BLOGSAVEURL       @"http://localhost:8888/saveBlog.php"

// PHOTO COLLECTION
#define PHOTOHEADER       @"Job Pictures #%li"  // CollectionParse

// LEADDETAIL
#define DETAILFONTSIZE     9
#define DETAILNEWS         12
#define DETAILTITLECOLOR   [UIColor blackColor]
#define DETAILSUBCOLOR     [UIColor grayColor]
#define DETAILCOLOR        [UIColor darkGrayColor]
#define DIVIDERCOLOR       [UIColor redColor]
#define LEADNEWSTITLE      @"Customer News Peter Balsamo Appointed to United's Board of Directors"
#define CUSTOMERNEWSTITLE  @"Customer News Peter Balsamo Appointed to United's Board of Directors"
#define VENDORNEWSTITLE    @"Business News Peter Balsamo Appointed to United's Board of Directors"
#define EMPLOYEENEWSTITLE  @"Employee News Peter Balsamo Appointed to United's Board of Directors"

// MAPCONTROLLER
#define MAPTITLE           @"Map of Boston"
#define NY_LATITUDE        42.37 //40.714353
#define NY_LONGTITUDE     -71.03//74.005973

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
#define KEY_WEBPAGE5 @"http://stocktwits.com/symbol/UPL"

// EDITDATA
#define HEADERTITLE @"Info"
#define FOOTERTITLE @"MySQL"
#define TEXT_FIELD_TAG_OFFSET 1000
#define NUM_TEXT_FIELD 5

#define UPDATEEMPLOYEEFIELD @"_employeeNo=%@&&_company=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_homephone=%@&_workphone=%@&_cellphone=%@&_country=%@&_email=%@&_last=%@&_department=%@&_middle=%@&_first=%@&_manager=%@&_social=%@&_comments=%@&_active=%@&_employtitle=%@&"
#define UPDATEEMPLOYEEFIELD1 _employeeNo, _company, _address, _city, _state, _zip, _homephone, _workphone, _cellphone, _country, _email, _last, _department, _middle, _first, _manager, _social, _comments, _active, _employtitle
#define UPDATEEMPLOYEEURL @"http://localhost:8888/updateEmployee.php"

#define UPDATEVENDORFIELD @"_vendorNo=%@&&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_phone=%@&_phone1=%@&_phone2=%@&_phone3=%@&_email=%@&_webpage=%@&_department=%@&_office=%@&_manager=%@&_profession=%@&_assistant=%@&_comments=%@&_active=%@&_phonecmbo=%@&_phonecmbo1=%@&_phonecmbo2=%@&_phonecmbo3=%@&"
#define UPDATEVENDORFIELD1 _vendorNo, _name, _address, _city, _state, _zip, _phone, _phone1, _phone2, _phone3, _email, _webpage, _department, _office, _manager, _profession, _assistant, _comments, _active, _phonecmbo, _phonecmbo1, _phonecmbo2, _phonecmbo3
#define UPDATEVENDORURL @"http://localhost:8888/updateVendor.php"

#define UPDATECUSTFIELD @"_custNo=%@&&_leadNo=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_quan=%@&_email=%@&_first=%@&_spouse=%@&_rate=%@&_photo=%@&_photo1=%@&_photo2=%@&_salesNo=%@&_jobNo=%@&_start=%@&_complete=%@&_productNo=%@&_contractor=%@&_active=%@&"
#define UPDATECUSTFIELD1 _custNo, _leadNo, _address, _city, _state, _zip, _comments, _amount, _phone, _quan, _email,_first, _spouse, _rate, _photo, _photo1, _photo2,_salesNo, _jobNo, _start, _complete, _productNo, _contractor, _active
#define UPDATECUSTURL @"http://localhost:8888/updateCustomer.php"

#define UPDATELEADFIELD @"_leadNo=%@&&_date=%@&_name=%@&_address=%@&_city=%@&_state=%@&_zip=%@&_comments=%@&_amount=%@&_phone=%@&_aptdate=%@&_email=%@&_first=%@&_spouse=%@&_callback=%@&_salesNo=%@&_jobNo=%@&_adNo=%@&_active=%@&_photo=%@&"
#define UPDATELEADFIELD1 _leadNo, _date, _name, _address, _city, _state, _zip, _comments, _amount, _phone, _aptdate, _email, _first, _spouse, _callback, _salesNo, _jobNo, _adNo, _active, _photo
#define UPDATELEADURL @"http://localhost:8888/updateLeads.php"

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

// NEWDATADETAIL
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


//#define KEY_UPDATE  @"updateAt"
//#define KEY_GEOLOC  @"location"
//#define WALL_OBJECT @"WallImageObject"
//#define KEY_COMMENT @"comment"

@end
