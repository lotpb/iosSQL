//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"

@interface NewsController () {
   // NSURL *url;
    UILabel *titleLabel, *detailLabel, *readLabel, *emptyLabel, *playLabel, *numLabel;
    UITextView *newsTextview;
    PFImageView *userImage;
    PFFile *image;
    PFObject *wallObject;
    BOOL stopFetching, requestInProgress, forceRefresh;
    int pageNumber;
    UIButton *likeButton, *playButton, *actionBtn;
    UIView *wallImageView, *separatorLineView;
}

-(void)getNewsImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@property(copy, nonatomic) NSURL *videoURL;
@property (nonatomic, strong) UISearchController *searchController;
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
    
  #pragma mark RefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    [self.wallScroll addSubview:refreshControl];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
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

#pragma mark - RefreshControl
- (void)reloadDatas:(UIRefreshControl *)refreshControl {
    [self getNewsImages];
    [refreshControl endRefreshing];
}

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
    [query setLimit:5]; //parse.com standard is 100
     query.skip = pageNumber*5;
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
            if (objects.count<5) {
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
    
    //For every wall element, put a view in the scroll
    int originY = 10;
    for (wallObject in self.imageFilesArray) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 200)];
        } else {
            wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20, 345)];
        }

        //Add the image
        image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
        userImage = [[PFImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        //NSURL *imageFileURL = [[NSURL alloc] initWithString:image.url];
        //NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
        //NSLog(@"video url...%@", imageFileURL);
        
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
        
        userImage.backgroundColor = [UIColor blackColor];
        userImage.clipsToBounds = YES;
        userImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        userImage.layer.borderWidth = 0.5f;
        userImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgLoadSegue:)];
        [userImage addGestureRecognizer:tap];
        
        [wallImageView addSubview:userImage];

        /*
         UIImageView *userImage = [[UIImageView alloc] initWithImage:
         [UIImage imageWithData:image.getData]];
         userImage.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 200);
         [wallImageView addSubview:userImage]; */
        
        //--------------------------------------------------------------------------------------
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 10, wallImageView.frame.size.width - userImage.frame.size.width - 50, 55)];
            detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(345, 66, wallImageView.frame.size.width - userImage.frame.size.width - 50, 15)];
            readLabel = [[UILabel alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 70 , 66, wallImageView.frame.size.width, 15)];
            newsTextview = [[UITextView alloc] initWithFrame:CGRectMake(345, 86, wallImageView.frame.size.width - userImage.frame.size.width - 60, 45)];
    
            titleLabel.font = CELL_LIGHTFONT(IPADFONT22);
            newsTextview.font = DETAILFONT(IPADFONT16);
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
        readLabel.textColor = BLUECOLOR;
        readLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:readLabel];
        
        newsTextview.text = [wallObject objectForKey:@"storyText"];
        //NSLog(@"Testing Text url...%@", newsTextview.text);
        [wallImageView addSubview:newsTextview];
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(wallImageView.frame.size.width - 55 ,165, 20, 20)];
        } else {
            actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55 ,310, 20, 20)];
        }
        actionBtn.tintColor = [UIColor lightGrayColor];
        [actionBtn setImage:[UIImage imageNamed:@"Upload50.png"] forState:UIControlStateNormal];
        [actionBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:actionBtn];
        
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, .8)];
        } else {
            separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, .8)];
        }
        separatorLineView.backgroundColor = SCROLLBACKCOLOR;
        [wallImageView addSubview:separatorLineView];
        
        
        likeButton = [[UIButton alloc] initWithFrame:CGRectMake(20 ,310, 20, 20)];
        likeButton.tintColor = [UIColor lightGrayColor]; //BLUECOLOR;
        UIImage *imagebutton = [[UIImage imageNamed:@"Thumb Up.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [likeButton setImage:imagebutton forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton addTarget:self action:@selector(likeButton:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:likeButton];
        
        numLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 310, 20, 20)];
        numLabel.font = DETAILFONT(IPHONEFONT16);
        numLabel.textColor = [UIColor grayColor];
        numLabel.text = [[wallObject objectForKey:@"Liked"]stringValue];
        [numLabel sizeToFit];
        [wallImageView addSubview:numLabel];
        
        //_videoURL = [NSURL URLWithString:image.url];
        
        if([image.url containsString:@"movie.mp4"]) {
            
            playButton = [[UIButton alloc] init];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                playButton.frame = CGRectMake(userImage.frame.size.width / 2 - 25 , userImage.frame.origin.y + 45, 50, 50);
            } else {
                playButton.frame = CGRectMake(userImage.frame.size.width / 2 - 25 , userImage.frame.origin.y + 10, 50, 50);
            }
             playButton.alpha = 1.0f;
            //playButton.center = userImage.center;
            UIImage *playbutton = [[UIImage imageNamed:@"play_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [playButton setImage:playbutton forState:UIControlStateNormal];
            playButton.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
            [playButton addGestureRecognizer:tap];
            
            [userImage addSubview:playButton];
            
            _videoURL = [NSURL URLWithString:image.url];
            //NSLog(@"Testing url...%@", _videoURL);

        }
        
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

- (void)imgLoadSegue:(UITapGestureRecognizer *)sender {

    PFImageView *tappedimage = (PFImageView*)sender.view;
    userImage.image = tappedimage.image;

    //titleLabel.text = (NSString *)sender.view;
    //detailLabel.text;
    
    //if([image.url containsString:@"movie.mp4"]) {
    //self.videoURL = [NSURL URLWithString:image.url];
    //NSLog(@"Peter Test url...%@", sender);
    //}

    [self performSegueWithIdentifier: @"newsdetailseque" sender: self];
    
}

#pragma mark - play video
- (IBAction) playVideo:(id)sender { //(NSURL*) _videoURL{
     //UIButton* button = (UIButton *) sender;
    //NSLog([(long)sender tag]);
    //NSURL *url = [[NSBundle mainBundle] URLForResource:@"video1" withExtension:@"mp4"];
      //NSString * videoPath = [wallObject objectForKey:KEY_IMAGE]
    //image = (PFFile *)[wallObject objectAtIndex:[sender tag]];
    //NSString *url = [[NSBundle mainBundle] pathForResource:@"Test_iPad" ofType:@"m4v"];
    //[image.url objectAtIndex:3];
    
    //_videoURL = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.videoURL]];//[image objectForKey:@"url"];
    //_videoURL = [NSURL URLWithString:[_imageFilesArray objectAtIndex:1]];//[image objectForKey:@"url"];
    // _videoURL = [NSURL URLWithString:image.url];
    //self.videoController = [[MPMoviePlayerController alloc] initWithFrame:frame placeholderImage:placeholderImage videoURL:videoURL];
    
    self.videoController = [[MPMoviePlayerController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.videoController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopPlayingVideo:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:self.videoController];
    
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

#pragma mark like button
- (void) buttonPress:(id)sender {
    UIButton* button = (UIButton*)sender;
    if (!likeButton.selected) {
        [[PFUser currentUser] addUniqueObject:[PFUser currentUser].objectId forKey:@"Liked"];
        [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSLog(@"liked News!");
                // [self likedSuccess];
            }
            else {
                //[self likedFail];
            }
        }];
        [likeButton setSelected:YES];
        button.tintColor = BLUECOLOR;
    } else {
         NSLog(@"unlike News!");
        [likeButton setSelected:NO];
        button.tintColor = [UIColor lightGrayColor];
    }
}

#pragma mark like button
- (void)likeButton:(id)sender {
//NSLog(@"TESTING %ld",(long)buttonPosition);
    /*
    UIButton *btn = (UIButton *) sender;
    CGRect buttonPosition = [btn convertRect:btn.bounds toView:self.wallScroll];
    NSIndexPath *indexPath = [self.wallImageView indexPathForRowAtPoint:buttonPosition.origin];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
    [query whereKey:@"objectId" equalTo:[[_imageFilesArray objectAtIndex:indexPath.row] objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * updateLead, NSError *error) {
        if (!error) {
            NSNumber* likedNum = [wallObject objectForKey:@"Liked"];
            int likeCount = [likedNum intValue];
            
            if (likeButton.isSelected) {
                likeCount++;
                [likeButton setSelected:YES];
            } else {
                likeCount--;
                [likeButton setSelected:NO];
            }
            
            NSNumber *numCount = [NSNumber numberWithInteger: likeCount];
            [updateLead setObject:numCount ? numCount:[NSNumber numberWithInteger: 0] forKey:@"Liked"];
            [updateLead saveInBackground];
            
        }
    }];
    
    //[self.listTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //numLabel.text = [[[_feedItems objectAtIndex:indexPath.row] valueForKey:@"Liked"]stringValue];
    //[self.listTableView reloadData]; */
}

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg {
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"newsdetailseque"]) {
       
        NewsDetailController *photo = segue.destinationViewController;
        photo.image = userImage.image;
        photo.newsTitle = titleLabel.text;
        photo.newsDetail = detailLabel.text;
        photo.newsStory = newsTextview.text;
        photo.videoURL = self.videoURL;
        
    }
}

@end
