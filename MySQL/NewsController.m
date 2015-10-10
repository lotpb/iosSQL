//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"

@interface NewsController () {

    UILabel *titleLabel, *detailLabel, *readLabel, *emptyLabel, *numLabel, *urlLabel;
    UITextView *newsTextview;
    PFImageView *userImage;
    PFFile *image;
    PFObject *wallObject;
    BOOL stopFetching, requestInProgress, forceRefresh;
    int pageNumber;
    UIButton *likeButton, *playButton, *actionBtn;
    UIView *wallImageView, *separatorLineView;
    UIBarButtonItem *searchItem, *shareItem;
}

-(void)getNewsImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@property(copy, nonatomic) NSURL *videoURL;
@property (nonatomic, strong) UISearchController *searchController;
//- (IBAction)sendNotification:(UIButton *)sender;
@end

@implementation NewsController

@synthesize imageFilesArray = _imageFilesArray;
@synthesize wallScroll = _wallScroll;

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
    [self.wallScroll setBackgroundColor:SCROLLBACKCOLOR];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [self.wallScroll addSubview:refreshControl];
    
    shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(notification:)];
    searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[shareItem, searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    emptyLabel = [[UILabel alloc] initWithFrame:self.wallScroll.bounds];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.textColor = [UIColor lightGrayColor];
    emptyLabel.text = @"You have no pending news :)";
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
  // Release any retained subviews of the main view.
     self.wallScroll = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //self.navigationController.hidesBarsOnSwipe = true;
    //self.navigationController.hidesBarsOnTap = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    //Clean the scroll view
     for (id viewToRemove in [self.wallScroll subviews]) {
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    //Reload the wall
    [self forceFetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - refreshControl
- (void)reloadDatas:(UIRefreshControl *)refreshControl {
    [self getNewsImages];
    [refreshControl endRefreshing];
}

#pragma mark - fetch data
- (void)forceFetchData {
    forceRefresh = YES;
    stopFetching = NO;
    pageNumber=0;
    [self getNewsImages];
}

#pragma mark - Get Parse Image
-(void)getNewsImages {
    
    if (!requestInProgress && !stopFetching) {
        requestInProgress = YES;
        
        PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
        [query setLimit:10]; //parse.com standard is 100
        query.skip = pageNumber*10;
        query.cachePolicy = kPFCACHEPOLICY;
        query.maxCacheAge = 60*60;
        [query orderByDescending:KEY_CREATION_DATE];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (!error) {
                //Everything was correct, put the new objects and load the wall
                self.imageFilesArray = nil;
                self.imageFilesArray = [[NSMutableArray alloc] initWithArray:objects];
                [self loadWallViews];
                
                if (self.imageFilesArray.count==0) {
                    [self.wallScroll addSubview:emptyLabel];
                } else {
                    [emptyLabel removeFromSuperview];
                }
                
                requestInProgress = NO;
                forceRefresh = NO;
                if (objects.count<10) {
                    stopFetching = YES;
                }
                pageNumber++;
            } else {
                requestInProgress = NO;
                forceRefresh = NO;
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                [self showErrorView:errorString];
            }
        }];
    }
}

#pragma mark - Wall Load
-(void)loadWallViews
{
    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]) {
        
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    //shadow for uiview
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.wallScroll.bounds];
    self.wallScroll.layer.masksToBounds = NO;
    self.wallScroll.layer.shadowColor = [UIColor blackColor].CGColor;
    self.wallScroll.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.wallScroll.layer.shadowOpacity = 0.5f;
    self.wallScroll.layer.shadowPath = shadowPath.CGPath;
    
    //For every wall element, put a view in the scroll
    int originY = 10;
    for (wallObject in self.imageFilesArray) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 200)];
        } else {
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 345)];
        }

        //Add the image
        //image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
        //userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        
        //--------------------load in background------------------------------
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"backgroundImageKey"]) {
            
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
             image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
             dispatch_async(dispatch_get_main_queue(), ^(void){
             userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
             });
             });
            /*
            //added to remove warning on thread...load faster use above code
            [[NSOperationQueue pffileOperationQueue] addOperationWithBlock:^ {
                image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
                userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
            }]; */
        } else {
            image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
            userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
            
        }
        [userImage loadInBackground];
         //-------------------------------------------------------------------
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            userImage.frame = CGRectMake(15, 15, 300, 170);
        else
            userImage.frame = CGRectMake(0, 75, wallImageView.frame.size.width, 225);
        
        userImage.backgroundColor = [UIColor blackColor];
        userImage.clipsToBounds = YES;
        userImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        userImage.layer.borderWidth = 0.5f;

         wallImageView.userInteractionEnabled = YES;
        [wallImageView setBackgroundColor:VIEWBACKCOLOR];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLoadSegue:)];
        [wallImageView addGestureRecognizer:tap];
        [wallImageView addSubview:userImage];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 10, wallImageView.frame.size.width - userImage.frame.size.width - 50, 55)];
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 66, wallImageView.frame.size.width - userImage.frame.size.width - 50, 15)];
            readLabel = [[UILabel alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 70 , 66, wallImageView.frame.size.width, 15)];
            newsTextview = [[UITextView alloc] initWithFrame:CGRectMake(345, 86, wallImageView.frame.size.width - userImage.frame.size.width - 60, 45)];
            playButton = [[UIButton alloc] initWithFrame:CGRectMake(userImage.frame.size.width / 2, userImage.frame.origin.y + 55, 50, 50)];
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(userImage.frame.size.width + 50 ,165, 20, 20)];
            likeButton = [[UIButton alloc] initWithFrame:CGRectMake(userImage.frame.size.width + 90 ,167, 20, 20)];
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(userImage.frame.size.width + 113 ,168, 20, 20)];
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, .8)];
            titleLabel.font = CELL_LIGHTFONT(IPADFONT22);
            detailLabel.font = DETAILFONT(IPADFONT14);
            readLabel.font = DETAILFONT(IPADFONT14);
            newsTextview.font = DETAILFONT(IPADFONT16);
            numLabel.font = DETAILFONT(IPADFONT16);
        } else {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, wallImageView.frame.size.width - 7, 55)];
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 56, wallImageView.frame.size.width, 15)];
            readLabel = [[UILabel alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 50 , 56, wallImageView.frame.size.width, 15)];
            newsTextview = [[UITextView alloc] initWithFrame:CGRectMake(5, 86, wallImageView.frame.size.width, 45)];
            playButton = [[UIButton alloc] initWithFrame:CGRectMake(userImage.frame.size.width / 2 - 25, userImage.frame.origin.y + 85, 50, 50)];
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 ,310, 20, 20)];
            likeButton = [[UIButton alloc] initWithFrame:CGRectMake(60 ,312, 20, 20)];
            numLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 314, 20, 20)];
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, .8)];
            titleLabel.font = DETAILFONT(IPHONEFONT20);
            detailLabel.font = DETAILFONT(IPHONEFONT14);
            readLabel.font = DETAILFONT(IPHONEFONT14);
            newsTextview.font = DETAILFONT(IPHONEFONT16);
            numLabel.font = DETAILFONT(IPHONEFONT16);
            
            newsTextview.hidden = true;
        }
        
        titleLabel.text = [wallObject objectForKey:@"newsTitle"];
        titleLabel.textColor = NEWSTITLECOLOR;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 1;
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
        detailLabel.tag = 2;
        [wallImageView addSubview:detailLabel];
        
        readLabel.text = READLABEL;
        readLabel.textColor = BLUECOLOR;
        readLabel.backgroundColor = [UIColor clearColor];
        readLabel.tag = 3;
        [wallImageView addSubview:readLabel];
        
        //newsTextview.editable = NO; //bug fix
        newsTextview.text = [wallObject objectForKey:@"storyText"];
        [newsTextview setUserInteractionEnabled:NO];
        [wallImageView addSubview:newsTextview];
        
        urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 310, 20, 20)];
        urlLabel.tag = 4;
        urlLabel.text = image.url;
        urlLabel.hidden = true;
        [wallImageView addSubview:urlLabel];
        
        if([image.url containsString:@"movie.mp4"]) {
            playButton.alpha = 1.0f;
            playButton.userInteractionEnabled = YES;
            //playButton.center = userImage.center;
            UIImage *button = [[UIImage imageNamed:@"play_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [playButton setImage:button forState:UIControlStateNormal];
            [playButton setTitle:urlLabel.text forState:UIControlStateNormal];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
            [playButton addGestureRecognizer:tap];
            [wallImageView addSubview:playButton];
        }
        
        actionBtn.tintColor = [UIColor darkGrayColor];
        UIImage *imagebutton1 = [[UIImage imageNamed:@"Upload50.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [actionBtn setImage:imagebutton1 forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:actionBtn];

        likeButton.tintColor = [UIColor lightGrayColor]; //BLUECOLOR;
        UIImage *imagebutton = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [likeButton setImage:imagebutton forState:UIControlStateNormal];
        [likeButton setTitle:wallObject.objectId forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        [likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:likeButton];

        numLabel.textColor = [UIColor grayColor];
        numLabel.text = [[wallObject objectForKey:@"Liked"]stringValue];
        numLabel.tag = 14;
        [numLabel sizeToFit];
        if (![numLabel.text isEqual: @"0"] ) {
            numLabel.textColor = BLUECOLOR;
            numLabel.font = LIKEFONT(IPHONEFONT16);
        } else {
            //numLabel.textColor = [UIColor grayColor];
            numLabel.text = @"";
        }
        [wallImageView addSubview:numLabel];

        separatorLineView.backgroundColor = SCROLLBACKCOLOR;
        [wallImageView addSubview:separatorLineView];
        
        //[self.wallScroll addSubview:wallImageView];
        //[self.wallScroll addSubview:separatorLineView];
        //self.automaticallyAdjustsScrollViewInsets = NO;
        [self.wallScroll addSubview:wallImageView];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            originY = originY + 201;
        } else {
            originY = originY + wallImageView.frame.size.width;
        }
    }
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
}

#pragma mark like button
- (void)likeButton:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSString *objectidItem = button.titleLabel.text;
    [[PFUser currentUser] addUniqueObject:[PFUser currentUser].objectId forKey:@"Liked"];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
            [query whereKey:@"objectId" equalTo:objectidItem];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateLead, NSError *error) {
                if (!error) {
                    NSNumber* likedNum = [updateLead valueForKey:@"Liked"];
                    int likeCount = [likedNum intValue];
                    
                    if (likeButton.isSelected) {
                        likeCount++;
                    } else {
                        if (likeCount > 0) {
                            likeCount--;
                        }
                    }
                    numLabel.text = [NSString stringWithFormat:@"%d", likeCount];
                    NSNumber *numCount = [NSNumber numberWithInteger: likeCount];
                    [updateLead setObject:numCount ? numCount:[NSNumber numberWithInteger: 0] forKey:@"Liked"];
                    [updateLead saveInBackground];
                }
            }];
        } else {
            NSLog(@"Parse not loading!");
        }
    }];
}

-(void)buttonPress:(id)sender{
    UIButton* button = (UIButton*)sender;
    if (!likeButton.selected) {
        [likeButton setSelected:YES];
        button.tintColor = BLUECOLOR;
    } else {
        [likeButton setSelected:NO];
        button.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark - play video
- (IBAction)playVideo:(UITapGestureRecognizer *)sender {
    
    UIButton *button = (UIButton *) sender.view;
    self.imageDetailurl = button.titleLabel.text;
    _videoURL = [NSURL URLWithString:self.imageDetailurl];
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayingVideo:) name:MPMoviePlayerWillExitFullscreenNotification object:self.videoController];
    
    self.videoController.view.frame = self.view.bounds;
    [self.videoController prepareToPlay];
    [self.videoController setContentURL:_videoURL];
    [self.view addSubview:self.videoController.view];
    [self.videoController play];
    [self.videoController setFullscreen:YES animated:YES];
    
}

- (void) stopPlayingVideo:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.videoController stop];
    [self.videoController.view removeFromSuperview];
}

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg {
    
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"Error" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
        UIView* senderView = (UIView *)sender;
        activityVC.popoverPresentationController.sourceView = senderView;
        activityVC.popoverPresentationController.sourceRect = senderView.bounds;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void)notification:(id)sender {
    
    UIAlertController *view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* notify = [UIAlertAction actionWithTitle:@"Notification" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                               {
                                   [self sendNotification];
                               }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    [view addAction:notify];
    [view addAction:cancel];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        view.popoverPresentationController.barButtonItem = shareItem;
        view.popoverPresentationController.sourceView = self.view;
    }
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - Notification
- (void)sendNotification {
    UIAlertView *alert;
    UIDatePicker *DatePicker;
    
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    alert = [[UIAlertView alloc] initWithTitle:@"Notification date:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    DatePicker = [[UIDatePicker alloc] init];
    DatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    DatePicker.timeZone = [NSTimeZone localTimeZone];
    DatePicker.date = [NSDate date];
    
    self.DateInput = [alert textFieldAtIndex:0];
    self.itemText = [alert textFieldAtIndex:1];
    [self.DateInput setTextAlignment:NSTextAlignmentLeft];
    [self.itemText setTextAlignment:NSTextAlignmentLeft];
    self.DateInput.text = [DateFormatter stringFromDate:[NSDate date]];
    self.itemText.text = NEWSBODY;
    [self.DateInput setPlaceholder:@"notification date"];
    [self.itemText setPlaceholder:@"title"];
    self.itemText.secureTextEntry = NO;
    self.DateInput.inputView=DatePicker;
    [DatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [alert show];
}

- (void) dateChanged:(UIDatePicker *)DatePicker {
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
        self.DateInput.text = [DateFormatter stringFromDate:DatePicker.date];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"]) {
        [self requestApptdate];
    }
}

- (void)requestApptdate {
    NSDate *apptdate;
    static NSDateFormatter *DateFormatter = nil;
    if (DateFormatter == nil) {
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc]init];
        [DateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [DateFormatter setTimeStyle:NSDateFormatterShortStyle];
        apptdate = [DateFormatter dateFromString:self.DateInput.text];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = self.itemText.text; //BLOGNOTIFICATION;
    localNotification.category = NEWSCATEGORY;
    localNotification.alertAction = NSLocalizedString(NEWSACTION, nil);
    localNotification.alertTitle = NSLocalizedString(NEWSTITLE, nil);;
    localNotification.soundName = @"Tornado.caf";//UILocalNotificationDefaultSoundName;
    localNotification.fireDate = apptdate;//[NSDate dateWithTimeIntervalSinceNow:60];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] BADGENO; //The number to diplay on the icon badge
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

#pragma mark - Segue
- (void)imgLoadSegue:(UITapGestureRecognizer *)sender {
    
    UIView *tappedView = sender.view;
    UILabel *label1 = (UILabel*)[tappedView viewWithTag:1];
    titleLabel.text = label1.text;
    UILabel *label2 = (UILabel*)[tappedView viewWithTag:2];
    detailLabel.text = label2.text;
    //UILabel *label3 = (UILabel*)[tappedView viewWithTag:3];
    //detailLabel.text = label3.text;
    UILabel *label4 = (UILabel*)[tappedView viewWithTag:4];
    self.imageDetailurl = label4.text;
    
    for (UIView *view in sender.view.subviews) {
        
        if([view isKindOfClass:[UITextView class]]) {
            newsTextview.text = ((UITextView *)view).text;
        }
        
        if([view isKindOfClass:[PFImageView class]]) {
            userImage.image = ((PFImageView *)view).image;
        }
    }
    [self performSegueWithIdentifier: @"newsdetailseque" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newsdetailseque"]) {
       
        NewsDetailController *photo = segue.destinationViewController;
        photo.image = userImage.image;
        photo.newsTitle = titleLabel.text;
        photo.newsDetail = detailLabel.text;
        photo.newsStory = newsTextview.text;
        photo.imageDetailurl = self.imageDetailurl;
    }
}

@end
