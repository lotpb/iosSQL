//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"

@interface NewsController ()

@property (nonatomic, retain) NSArray *imageFilesArray;
@property (nonatomic, retain) NSArray *wallObjectsArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void)getWallImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation NewsController

@synthesize wallObjectsArray = _wallObjectsArray;
@synthesize wallScroll = _wallScroll;
@synthesize activityIndicator = _loadingSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mySQLNEWS.png"]];
    //self.title = NSLocalizedString(@"News", nil);
    [self.wallScroll setBackgroundColor:SCROLLBACKCOLOR];
    
    //tableData = [NSArray arrayWithObjects:@"Big changes for Twitter, will new users follow?", @"Will retail sales reveal truth about cheap gas?", @"Vendor Info", @"Blog", nil];
    //tableData1 = [NSArray arrayWithObjects:@"Yahoo Finance 2 hrs ago", @"CNBC 2 hrs ago", @"Vendor Info", @"Blog", nil];
    // tableImage = [NSArray arrayWithObjects:@"profile-rabbit-toy.png", @"calendar_photo.jpg", @"tag_photo.jpg", @"bookmark_photo.jpg", nil];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.wallScroll = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    //Reload the wall
    [self getWallImages];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Receive Wall Objects

//Get the list of images
-(void)getWallImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"Newsios"];
     query.cachePolicy = kPFCachePolicyCacheThenNetwork; //added
    [query orderByDescending:KEY_CREATION_DATE];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.imageFilesArray = nil;
            self.imageFilesArray = [[NSMutableArray alloc] initWithArray:objects];
            [self loadWallViews];
        } else {
            //Remove the activity indicator
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
        
    }];
    
}

#pragma mark Wall Load
//Load the images on the wall
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
        
        //Build the view with the image and the comments
        UIView *wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20 , 345)]; //self.view.frame.size.height - original height 330 not 345
            
        [wallImageView setBackgroundColor:VIEWBACKCOLOR];
        
        //Add the image
        PFFile *image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
        UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        
        userImage.frame = CGRectMake(0, 67, wallImageView.frame.size.width, 230);
        [wallImageView addSubview:userImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, wallImageView.frame.size.width - 5, 55)];
        titleLabel.text = [wallObject objectForKey:@"newsTitle"];
        titleLabel.font = DETAILFONT(TITLEFONTSIZE);
        titleLabel.textColor = NEWSTITLECOLOR;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [wallImageView addSubview:titleLabel];
            
        NSDate *creationDate = wallObject.createdAt;
        NSDate *datetime1 = creationDate;
        NSDate *datetime2 = [NSDate date];
        double dateInterval = [datetime2 timeIntervalSinceDate:datetime1] / (60*60*24);
        NSString *resultDateDiff = [NSString stringWithFormat:@"%.0f days ago",dateInterval];

        //Add the detail
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 52, wallImageView.frame.size.width, 12)];
        detailLabel.text = [NSString stringWithFormat:@" %@, %@", [wallObject objectForKey:@"newsDetail"], resultDateDiff];
        detailLabel.font = DETAILFONT(KEY_FONTSIZE);
        detailLabel.textColor = NEWSDETAILCOLOR;
        detailLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:detailLabel];
        
        UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 62 , 52, wallImageView.frame.size.width, 12)];
        readLabel.text = READLABEL;
        readLabel.font = DETAILFONT(KEY_FONTSIZE + 1);
        readLabel.textColor = NEWSREADCOLOR;
        readLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:readLabel];
        
        UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(5,310, 20, 20)];
        [faceBtn setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
        [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:faceBtn];
        
        UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(35,310, 20, 20)];
        [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
        [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:twitBtn];
        
        UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(65,310, 20, 20)];
        [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
        [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:tumblrBtn];
        
        UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(95,310, 20, 20)];
        [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
        [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:yourBtn];
       
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, self.view.frame.size.width, .8)];
        separatorLineView.backgroundColor = SEPARATORCOLOR;// you can also put image here
            
      //  wallImageView.separatorInset = UIEdgeInsetsMake(0.0f, self.view.frame.size.width, 0.0f, 400.0f);
     //   wallImageView = UIEdgeInsetsMake(0.0f, self.wallScroll.frame.size.width, 0.0f, 400.0f);
            
        [wallImageView addSubview:separatorLineView];
        [self.wallScroll addSubview:wallImageView];
        
        originY = originY + wallImageView.frame.size.width + 1;
    }
    
    //Set the bounds of the scroll
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
    
    //Remove the activity indicator
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

#pragma mark - search
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
    self.searchController.searchBar.barStyle = UIBarStyleBlack;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    [self presentViewController:self.searchController animated:YES completion:nil];
}

#pragma mark - Airdrop
- (void)share:(id)sender {

    NSString * message = @"newsTitle";
    NSString * message1 = @"Newsios";
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
