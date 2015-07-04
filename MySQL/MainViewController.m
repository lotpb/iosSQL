
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
   AVAudioPlayer *_audioPlayer;
   NSDictionary *results, *results1, *results2;
   NSString *respond, *respond1, *respond2, *respond3;
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
    
    [self YahooFinanceLoad];

//-----create Parse User----------------------------

 [PFUser logInWithUsernameInBackground:@"Peter Balsamo" password:@"3911"
 block:^(PFUser *user, NSError *error) {
 if (user) {
 // Hooray! Let them use the app now.
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
  // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR; //set in AppDelegate - grayColor
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
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [myCell.textLabel setFont:CELL_FONT1(CELL_TITLEFONTSIZE)];
    
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
    NSString *newString1 = [NSString stringWithFormat:@"NASDAQ \n%@", respond];
    NSString *newString2 = [NSString stringWithFormat:@"S&P 500 \n%@", respond1];
    NSString *newString3 = [NSString stringWithFormat:@"Todays Weather %@ %@", respond3, respond2];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    tableView.tableHeaderView = view; //makes header move with tablecell
  //[[UIView appearance] setBackgroundColor:[UIColor redColor]]; //added for problem solve
    
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, MAINHEADHEIGHT)];
    
    UIImage *image;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        image = nil; //[UIImage imageNamed:@""];
    } else {
        image = [UIImage imageNamed:@"IMG_1133New.jpg"];
    }
    
    imageHolder.image = image;
    imageHolder.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageHolder];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE4)];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    [label4 setFont:CELL_FONT(IPAD_FONTSIZE)];
    } else {
    [label4 setFont:CELL_FONT(HEADFONTSIZE)];
    }
    
    if (([respond3 containsString:@"Rain"]) || ([respond3 containsString:@"Snow"])) {
        [label4 setTextColor:LINECOLOR3];
    } else {
        [label4 setTextColor:LINECOLOR1];
    }

    label4.numberOfLines = 0;
    NSString *string = newString3;
    [label4 setText:string];
    [view addSubview:label4];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE1)];
    [label setFont:CELL_FONT(HEADFONTSIZE + 1)];
    [label setTextColor:HEADTEXTCOLOR];
    label.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label.shadowOffset = CGSizeMake(0.0f, 0.5f);
    label.numberOfLines = 0;
    NSString *string3 = newString;
    [label setText:string3];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE1)];
    separatorLineView.backgroundColor = LINECOLOR1;
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE2)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_FONT(HEADFONTSIZE + 1)];
    [label1 setTextColor:HEADTEXTCOLOR];
    label1.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label1.shadowOffset = CGSizeMake(0.0f, 0.5f);
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE2)];
    if (![respond containsString:@"-"]) {
        separatorLineView1.backgroundColor = LINECOLOR1;
    } else {
        separatorLineView1.backgroundColor = LINECOLOR3;
    }
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(MAINLABELSIZE3)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_FONT(HEADFONTSIZE + 1)];
    [label2 setTextColor:HEADTEXTCOLOR];
    label2.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    label2.shadowOffset = CGSizeMake(0.0f, 0.5f);
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(MAINLINESIZE3)];
    if (![respond1 containsString:@"-"]) {
        separatorLineView2.backgroundColor = LINECOLOR1;
    } else {
        separatorLineView2.backgroundColor = LINECOLOR3;
    }
    [view addSubview:separatorLineView2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(openStats:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Statistics" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        button.titleLabel.font = CELL_FONT(IPAD_FONTSIZE) ;
    } else {
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    button.frame = CGRectMake(tableView.frame.size.width -90, 120, 90, 37);
    [view addSubview:button];
    /*
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]]; */
    
    return view;
}

-(void)openStats:(id)sender {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"parsedataKey"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Statistics" message:@"No Statistics for Parse at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
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
    
    NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"^IXIC\")";
    NSString *queryString1 = @"select * from yahoo.finance.quote where symbol in (\"SPY\")";
    NSString *queryString2 = @"select * from weather.forecast where woeid=2446726";
    //NSString *queryString = @"select * from local.search where zip='11758' and query='pizza'";
    //NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"YHOO\",\"AAPL\",\"GOOG\",\"SPY\")";
    //NSString *queryString = @"select * from yahoo.finance.quote where symbol in (\"SPY\",\"^IXIC\")";
    
    results = [yql query:queryString];
    //respond = [[[results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
        respond = [[[results valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
    
    results1 = [yql query:queryString1];
    //respond1 = [[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"LastTradePriceOnly"];
        respond1 = [[[results1 valueForKeyPath:@"query.results"] objectForKey:@"quote"] objectForKey:@"Change"];
    
    results2 = [yql query:queryString2];
    respond2 = [[results2 valueForKeyPath:@"query.results.channel.item.condition"] objectForKey:@"temp"];
    
    respond3 = [[results2 valueForKeyPath:@"query.results.channel.item.condition"]
                objectForKey:@"text"];

   // respond4 = [[results2 valueForKeyPath:@"query.results.channel.item.forecast"] objectForKey:@"text"];
    //NSLog(@"%@", results);
    //NSLog(@"%@", respond4);
}

#pragma mark - AudioPlayer
-(void)playSound1 {
    NSString *path = [NSString stringWithFormat:SOUNDFILE, [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [_audioPlayer play];
}

#pragma mark - Notification
- (void)sendLocalNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = MNOTIFTEXT;
    notification.category = MNOTIFCATEGORY;
    notification.alertAction = NSLocalizedString(MAINNOTIFACTION, nil);
    notification.alertTitle = NSLocalizedString(MAINNOTIFTITLE, nil);
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

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
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





