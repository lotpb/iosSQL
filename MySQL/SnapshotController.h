//
//  SnapshotController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/30/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseConnection.h"
#import "Constants.h"
#import "CustomTableViewCell.h"
#import "JobViewCell.h"
#import "UserDetailController.h"
#import "NewsDetailController.h"
#import "CollectionDetailController.h"
#import "NewDataDetail.h"
#import "LeadDetailViewControler.h"
//#import <AudioToolbox/AudioServices.h> //vibrate

@interface SnapshotController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *filteredString;
    BOOL isFilltered;
}

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSString *selectedObjectId;
@property (strong, nonatomic) NSString *selectedTitle;
@property (strong, nonatomic) NSString *selectedName;
@property (strong, nonatomic) NSString *selectedCreate;
@property (strong, nonatomic) NSString *selectedEmail;
@property (strong, nonatomic) NSString *selectedPhone;
@property (strong, nonatomic) NSString *imageDetailurl;

@property (strong, nonatomic) NSString *selectedState;
@property (strong, nonatomic) NSString *selectedZip;
@property (strong, nonatomic) NSString *selectedAmount;
@property (strong, nonatomic) NSString *selectedComments;
@property (strong, nonatomic) NSString *selectedActive;

@property (strong, nonatomic) NSString *selected11;
@property (strong, nonatomic) NSString *selected12;
@property (strong, nonatomic) NSString *selected13;
@property (strong, nonatomic) NSString *selected14;
@property (strong, nonatomic) NSString *selected15;
@property (strong, nonatomic) NSString *selected21;
@property (strong, nonatomic) NSString *selected22;
@property (strong, nonatomic) NSString *selected23;
@property (strong, nonatomic) NSString *selected24;
@property (strong, nonatomic) NSString *selected25;
@property (strong, nonatomic) NSString *selected16;
@property (strong, nonatomic) NSString *selected26;
@property (strong, nonatomic) NSString *selected27;

@end

