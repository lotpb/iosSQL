//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"

@interface NewsController () {
    
}

@property (nonatomic, retain) NSArray *imageFilesArray;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void)getNewsImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) MPMoviePlayerController *videoController;
@end

@implementation NewsController

@synthesize imageFilesArray = _imageFilesArray;
@synthesize wallScroll = _wallScroll;
//@synthesize activityIndicator = _loadingSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone; //fix
     self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NEWSNAVLOGO]];
    //self.title = NSLocalizedString(@"News", nil);
    [self.wallScroll setBackgroundColor:SCROLLBACKCOLOR];
    
  #pragma mark RefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [self.wallScroll addSubview:refreshControl];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

}

- (void)viewDidUnload {
    [super viewDidUnload];
  // Release any retained subviews of the main view.
     self.wallScroll = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
     //self.navigationController.hidesBarsOnSwipe = true;
     //self.navigationController.hidesBarsOnTap = false;
    //Clean the scroll view
     for (id viewToRemove in [self.wallScroll subviews]) {
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    //Reload the wall
    [self getNewsImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(UIRefreshControl *)refreshControl {
    [self getNewsImages];
    [refreshControl endRefreshing];
}

#pragma mark - Get Parse Image
-(void)getNewsImages {
    PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
    [query setLimit:25]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY; 
    [query orderByDescending:KEY_CREATION_DATE];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.imageFilesArray = nil;
            self.imageFilesArray = [[NSMutableArray alloc] initWithArray:objects];
            [self loadWallViews];
        } else {
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
    }];
}

#pragma mark - Wall Load
-(void)loadWallViews
{
    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //For every wall element, put a view in the scroll
    int originY = 10;
    
    for (PFObject *wallObject in self.imageFilesArray){
        
        UIView *wallImageView;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //fix-self.view.frame.size.height - original height 330 not 345
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 200)];
        } else {
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 345)];
        }
        
        //Add the image
        PFFile *image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
        PFImageView *userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        
        //--------------------load background-----------------------------------
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backgroundImageKey"]) {
            //added to remove warning on thread...load faster use above code
            [[NSOperationQueue pffileOperationQueue] addOperationWithBlock:^ {
                [userImage loadInBackground];
                //userImage.contentMode = UIViewContentModeScaleAspectFill;
            }];
        } else {
            [userImage loadInBackground];
            //userImage.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            userImage.frame = CGRectMake(15, 15, 300, 170);
        else
            userImage.frame = CGRectMake(0, 75, wallImageView.frame.size.width, 225);
        /*
        self.videoController = [[MPMoviePlayerController alloc] init];
       // [self.videoController setContentURL:videoURL];
        [self.videoController.view setFrame:userImage.frame ];
        self.videoController.view.clipsToBounds = YES;
        self.videoController.controlStyle = MPMovieControlStyleFullscreen;
        [userImage addSubview:self.videoController.view]; */
        
        [wallImageView addSubview:userImage];
        
        /*
         UIImageView *userImage = [[UIImageView alloc] initWithImage:
         [UIImage imageWithData:image.getData]];
         userImage.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 200);
         [wallImageView addSubview:userImage]; */
        
        //--------------------------------------------------------------------------------------
        UILabel *titleLabel, *detailLabel, *readLabel;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 10, wallImageView.frame.size.width - userImage.frame.size.width - 50, 55)];
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 66, wallImageView.frame.size.width - userImage.frame.size.width - 50, 15)];
            readLabel = [[UILabel alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 70 , 66, wallImageView.frame.size.width, 15)];
            titleLabel.font = CELL_LIGHTFONT(IPADFONT22);
        } else {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, wallImageView.frame.size.width - 7, 55)];
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 56, wallImageView.frame.size.width, 15)];
            readLabel = [[UILabel alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 50 , 56, wallImageView.frame.size.width, 15)];
            titleLabel.font = CELL_LIGHTFONT(IPHONEFONT20);
        }
        detailLabel.font = DETAILFONT(IPHONEFONT14);
        readLabel.font = DETAILFONT(IPHONEFONT14);
        
        titleLabel.text = [wallObject objectForKey:@"newsTitle"];
        titleLabel.textColor = NEWSTITLECOLOR;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [wallImageView addSubview:titleLabel];
        
        NSDate *creationDate = wallObject.createdAt;
        NSDate *datetime1 = creationDate;
        NSDate *datetime2 = [NSDate date];
        double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
        NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];
        detailLabel.text = [NSString stringWithFormat:@" %@, %@", [wallObject objectForKey:@"newsDetail"], resultDateDiff];
        detailLabel.textColor = NEWSDETAILCOLOR;
        detailLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:detailLabel];
        
        readLabel.text = READLABEL;
        readLabel.textColor = NEWSREADCOLOR;
        readLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:readLabel];
        
        UIButton *actionBtn;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 55 ,165, 20, 20)];
        } else {
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55 ,310, 20, 20)];
        }
        [actionBtn setImage:[UIImage imageNamed:@"Upload50.png"] forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:actionBtn];
        
        UIView* separatorLineView;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, .8)];
        } else {
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, .8)];
        }
        separatorLineView.backgroundColor = SCROLLBACKCOLOR;
        [wallImageView addSubview:separatorLineView];
        
        //  self.wallScroll.layoutMargins = UIEdgeInsetsZero;
        //  wallImageView.separatorInset = UIEdgeInsetsMake(0.0f, self.view.frame.size.width, 0.0f, 400.0f);
        //   wallImageView = UIEdgeInsetsMake(0.0f, self.wallScroll.frame.size.width, 0.0f, 400.0f);
        
        // [self.wallScroll addSubview:wallImageView];
        // [self.wallScroll addSubview:separatorLineView];
        // self.automaticallyAdjustsScrollViewInsets = NO;
        
        [wallImageView setBackgroundColor:VIEWBACKCOLOR];
        [self.wallScroll addSubview:wallImageView];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            originY = originY + 200 + 1;
        } else {
            originY = originY + wallImageView.frame.size.width + 1;
        }
    }
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
}

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

#pragma mark - search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    //self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLOR;
    self.searchController.searchBar.barTintColor = SEARCHBARTINTCOLOR;
    [self presentViewController:self.searchController animated:YES completion:nil];
}

#pragma mark - ActivityViewController
- (void)share:(id)sender {
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, 212), self.view.opaque, 0.0);
    }else {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, 365), self.view.opaque, 0.0);
    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newPNG=UIImageJPEGRepresentation(img, 0.0f); // or you can use JPG or PDF
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:@"I would like to share this.",newPNG, nil] applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    } else {

        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0);
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

@end
