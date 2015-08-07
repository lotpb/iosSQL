
//
//  MainViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
   UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;//fix
     self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MAINNAVLOGO]];
   //self.title = NSLocalizedString(@"Main Menu", nil);
     self.listTableView.delegate = self;
     self.listTableView.dataSource = self;
     self.listTableView.backgroundColor = BACKGROUNDCOLOR;
     self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//fix
    
    [self YahooFinanceLoad];

//-------------------create Parse User------------------

 [PFUser logInWithUsernameInBackground:@"Peter Balsamo" password:@"3911"
 block:^(PFUser *user, NSError *error) {
 if (user) {
 // Hooray! Let them use the app now.
     [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        // NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);
         [user setObject:geoPoint forKey:@"currentLocation"];
         [user saveInBackground];
      //   [mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude),MKCoordinateSpanMake(0.01, 0.01))];
         
     //    [refreshMap:nil];
     }];

 } 
 }];
//----------------------------------------------------
   /*
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.movies = dict[@"movies"];
        [self.tableView reloadData];
        //NSArray * movies = dict[@"movies"];
        //NSDictionary * firstMovie = movies[0];
        //NSLog(@"%@", firstMovie);
        //NSLog(@"%@", object);
    }]; */
    
     //| -------------------------iAd------------------------------
  /*  bannerView = [[ADBannerView alloc]initWithFrame:
                  CGRectMake(0, 0, 320, 50)];
    // Optional to set background color to clear color
    [bannerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview: bannerView]; */
   
     //| -----------------------Sound Key---------------------------

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundKey"]) {
        [self playSound1];
    }
    //| -----------------------Notification Key---------------------------
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"verseKey"]) {
        [self sendLocalNotification];
    }
     //| -------------------------Timer----------------------------------
  //  [NSTimer scheduledTimerWithTimeInterval: MTIMER target:self selector:@selector(timertest:) userInfo:nil repeats: MTIMERREP];
    
    //| ---------------------------end----------------------------------
    
if ([self.tabBarController.tabBar respondsToSelector:@selector(setTranslucent:)]) {
    [self.tabBarController.tabBar setTranslucent:NO];
    [self.tabBarController.tabBar setTintColor:TABTINTCOLOR];
    }
    
    tableData = [[NSMutableArray alloc]initWithObjects:TNAME1, TNAME2, TNAME3, TNAME4, TNAME5, TNAME6, TNAME7, TNAME8, TNAME9, nil];
 
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    //Change BarButton Font Below
    // [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} forState:UIControlStateNormal];
    
#pragma mark Sidebar
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = SIDEBARTINTCOLOR;
    revealViewController.rearViewRevealWidth = 275; //default 200
    // Cannot drag and see beyond width 200
    revealViewController.rearViewRevealOverdraw = 0;
    revealViewController.toggleAnimationDuration = 0.2;
    revealViewController.frontViewShadowRadius = 5;
    [self.view addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }

#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"iadKey"]) {
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 50)];
    bannerView.delegate = self;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
-(void)reloadDatas:(id)sender {
    [self YahooFinanceLoad];
    [self.listTableView reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:KEY_DATEREFRESH];
        NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR
            forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle; }

    [refreshControl endRefreshing];
    }
} 

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFilltered)
        return [filteredString count];
    
    return [tableData count];
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = IDCELL;
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [myCell.textLabel setFont:CELL_FONT(IPADFONT20)];
    } else {
        [myCell.textLabel setFont:CELL_FONT(IPHONEFONT20)];
    }
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (!isFilltered)
       myCell.textLabel.text = [tableData objectAtIndex:indexPath.row];
       else
       myCell.textLabel.text = [filteredString objectAtIndex:indexPath.row];
    
    if (self.searchController.searchBar.text.length > 0)
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return myCell;
}

#pragma mark TableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return MAINHEADHEIGHT;
    else return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"FOLLOW \n%lu", (unsigned long) tableData.count];
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n%@", [changeYQL objectAtIndex:0]];
    NSString *newString2 = [NSString stringWithFormat:@"S&P 500 \n%@", [changeYQL objectAtIndex:1]];
    NSString *newString3 = [NSString stringWithFormat:@"Todays Weather %@ %@", textYQL, tempYQL];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, MAINHEADHEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE1)];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE2)];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE3)];
    UILabel *label4;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    label4 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE5)];
    } else {
    label4 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE4)];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [label setFont:CELL_FONT(IPADFONT16)];
        [label1 setFont:CELL_FONT(IPADFONT16)];
        [label2 setFont:CELL_FONT(IPADFONT16)];
        [label4 setFont:CELL_FONT(IPADFONT16)];
        label.backgroundColor = [UIColor blackColor];
        button.titleLabel.font = CELL_FONT(IPADFONT18);
        button.frame = CGRectMake(tableView.frame.size.width -115, 130, 90, 37);
    } else {
        [label setFont:CELL_FONT(IPHONEFONT14 + 1)];
        [label1 setFont:CELL_FONT(IPHONEFONT14 + 1)];
        [label2 setFont:CELL_FONT(IPHONEFONT14 + 1)];
        [label4 setFont:CELL_FONT(IPHONEFONT14)];
        button.titleLabel.font = CELL_FONT(IPHONEFONT14);
        button.frame = CGRectMake(tableView.frame.size.width -90, 125, 90, 37);
    }
    [label setTextColor:HEADTEXTCOLOR];
    [label1 setTextColor:HEADTEXTCOLOR];
    [label2 setTextColor:HEADTEXTCOLOR];
    
    UIImage *image;
    /*  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     image = nil; //[UIImage imageNamed:@""];
     } else {
     image = [UIImage imageNamed:@"IMG_1133New.jpg"];
     }*/
    image = [UIImage imageNamed:@"IMG_1133New.jpg"];
    imageHolder.image = image;
    imageHolder.contentMode = UIViewContentModeScaleAspectFill;
    imageHolder.clipsToBounds = true;
    [view addSubview:imageHolder];

    label.numberOfLines = 0;
    NSString *string3 = newString;
    [label setText:string3];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE1)];
    separatorLineView.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView];
    
    label1.numberOfLines = 0;
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    /*
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE2)];
    if (([[changeYQL objectAtIndex:0] containsString:@"-"]) || ([[changeYQL objectAtIndex:0] isEqual:nil] )) {
        separatorLineView1.backgroundColor = LINECOLOR3;
    } else {
        separatorLineView1.backgroundColor = LINECOLOR1;
    }
    [view addSubview:separatorLineView1]; */
    
    label2.numberOfLines = 0;
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    /*
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE3)];
    if (([[changeYQL objectAtIndex:1] containsString:@"-"]) || ([[changeYQL objectAtIndex:1] isEqual:nil] )) {
        separatorLineView2.backgroundColor = LINECOLOR3;
    } else {
        separatorLineView2.backgroundColor = LINECOLOR1;
    }
    [view addSubview:separatorLineView2]; */
    
    if (([textYQL containsString:@"Rain"]) || ([textYQL containsString:@"Snow"])) {
        [label4 setTextColor:LINECOLOR3];
    } else {
        [label4 setTextColor:LINECOLOR1];
    }
    
    label4.numberOfLines = 0;
    NSString *string = newString3;
    [label4 setText:string];
    [view addSubview:label4];
    
    [button addTarget:self action:@selector(openStats:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Statistics" forState:UIControlStateNormal];
    [button setTitleColor:LINECOLOR1 forState:UIControlStateNormal];
    [view addSubview:button];
    
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]];
    
    return view;
}

-(void)openStats:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            
            [self performSegueWithIdentifier:@"statisticSegue" sender:nil];
           /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Statistics" message:@"No Statistics for Parse at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show]; */
        }
        else
            [self performSegueWithIdentifier:@"statisticSegue" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"statisticSegue" sender:nil];
    }
}

#pragma mark - Search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
   [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = MHIDE;
    self.searchController.dimsBackgroundDuringPresentation = SDIM;
    self.definesPresentationContext = SDEFINE;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLORMAIN;
    self.searchController.hidesBottomBarWhenPushed = SHIDEBAR;
    self.listTableView.contentInset = UIEdgeInsetsMake(SEDGEINSERT);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.edgesForExtendedLayout = UIRectEdgeNone;

    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    if (!searchController.active) {
         self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
       }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
        isFilltered = NO;
        else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(NSString *str in tableData)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
                [filteredString addObject:str];
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Yahoo Finance
-(void)YahooFinanceLoad {
    
    yql = [[YQL alloc] init];
    
   NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\",\"SPY\")";
   NSString *queryString1 = @"select * from weather.forecast where woeid=2446726";
    //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    
    resultsYQL = [yql query:queryString];
    //symYQL = [resultsYQL valueForKeyPath:@"query.results.quote.symbol"];
    fieldYQL = [resultsYQL valueForKeyPath:@"query.results.quote.LastTradePriceOnly"];
    changeYQL = [resultsYQL valueForKeyPath:@"query.results.quote.Change"];
    
    resultsWeatherYQL = [yql query:queryString1];
    tempYQL = [[resultsWeatherYQL valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"temp"];
    
    textYQL = [[resultsWeatherYQL valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"text"];
}

#pragma mark - ADBannerView
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!_bannerIsVisible)
    {
        if (bannerView.superview == nil)
        {
            [self.view addSubview:bannerView];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];

        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Failed to retrieve ad");
    
    if (_bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        // Assumes the banner view is placed at the bottom of the screen.
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        
        [UIView commitAnimations];
        
        _bannerIsVisible = NO;
    }
}

#pragma mark - AudioPlayer
-(void)playSound1 {
    NSString *path = [NSString stringWithFormat:SOUNDFILE, [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer play];
}
//verse of the day
#pragma mark - Notification
- (void)sendLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = MAIN_BODY;
    notification.category = MAIN_CATEGORY;
    notification.alertAction = NSLocalizedString(MAIN_ACTION, nil);
    notification.alertTitle = NSLocalizedString(MAIN_ALERTTITLE, nil);
    // The notification will arrive in 5 seconds
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1; //The number to diplay on the icon badge
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *mycell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([mycell.textLabel.text isEqualToString:TNAME1])
        [self performSegueWithIdentifier:MAINVIEWSEGUE1 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME2])
        [self performSegueWithIdentifier:MAINVIEWSEGUE2 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME3])
        [self performSegueWithIdentifier:MAINVIEWSEGUE3 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME4])
        [self performSegueWithIdentifier:MAINVIEWSEGUE4 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME5])
        [self performSegueWithIdentifier:MAINVIEWSEGUE5 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME6])
        [self performSegueWithIdentifier:MAINVIEWSEGUE6 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME7])
        [self performSegueWithIdentifier:MAINVIEWSEGUE7 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME8])
        [self performSegueWithIdentifier:MAINVIEWSEGUE8 sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:TNAME9])
        [self performSegueWithIdentifier:MAINVIEWSEGUE9 sender:nil];
}

//------------
/*
 NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitHour | NSCalendarUnitMinute fromDate :[NSDate date]];
 
 NSInteger hh = [components hour];
 
 NSInteger mm = [components minute];
 //time is between 00:01 AM to 9:00 AM
 if( (9>hh && hh>0) || (hh==0 && mm >0)|| (hh ==9 && mm ==0 ))
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"time is between 00:01 AM to 9:00 AM" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 }
 //time is between 3:00 PM to 9:00 PM
 else if( (21>hh && hh>=15) || (hh==21 && mm ==0))
 {
 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"time is between 3:00 PM to 9:00 PM" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
 [alert show];
 } */
//--------------

/*
 #pragma mark - AdViewDelegates
 
 -(void)bannerView:(ADBannerView *)banner
 didFailToReceiveAdWithError:(NSError *)error{
 NSLog(@"Error loading");
 }
 
 -(void)bannerViewDidLoadAd:(ADBannerView *)banner{
 NSLog(@"Ad loaded");
 }
 -(void)bannerViewWillLoadAd:(ADBannerView *)banner{
 NSLog(@"Ad will load");
 }
 -(void)bannerViewActionDidFinish:(ADBannerView *)banner{
 NSLog(@"Ad did finish");
 
 } */

//#pragma message ("To Do: Meassage test - highlight but no error")

@end





