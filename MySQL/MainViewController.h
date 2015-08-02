//
//  MainViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ConstantMain.h"
#import "SWRevealViewController.h"
#import "YQL.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <iAd/iAd.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, ADBannerViewDelegate>
{
    NSMutableArray *tableData, *filteredString, *fieldYQL, *changeYQL;
    BOOL isFilltered, condition, _bannerIsVisible;
    YQL *yql;
    NSDictionary *resultsYQL, *resultsWeatherYQL;
    ADBannerView *bannerView;
    NSString *tempYQL, *textYQL;
    AVAudioPlayer *_audioPlayer;
   
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
