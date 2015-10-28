//
//  ViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseConnection.h"
#import "Location.h"
#import "HomeModel.h"
#import "LeadDetailViewControler.h"
#import "NewData.h"
#import "LeadsUserController.h"
//#import "UIImageView+Letters.h"
//#import "CRNInitialsImageView.h"
//#import <QuartzCore/QuartzCore.h>
//#import "MapViewController.h"


@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, HomeModelProtocol>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

