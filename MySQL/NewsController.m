//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"
#import <Parse/Parse.h>
#import "Constants.h"

@interface NewsController ()

@property (nonatomic, retain) NSArray *imageFilesArray;
@property (nonatomic, retain) NSArray *wallObjectsArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(void)getWallImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
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

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.title = NSLocalizedString(@"News", nil);
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"title",@"subtitle"];
    self.definesPresentationContext = YES;
    //Adds Padding to top of Tableview
    //UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    //self.listTableView.contentInset = inset;

    //tableData = [NSArray arrayWithObjects:@"Big changes for Twitter, will new users follow?", @"Will retail sales reveal truth about cheap gas?", @"Vendor Info", @"Blog", nil];
    //tableData1 = [NSArray arrayWithObjects:@"Yahoo Finance 2 hrs ago", @"CNBC 2 hrs ago", @"Vendor Info", @"Blog", nil];
    // tableImage = [NSArray arrayWithObjects:@"profile-rabbit-toy.png", @"calendar_photo.jpg", @"tag_photo.jpg", @"bookmark_photo.jpg", nil];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
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
  //[query where:@"name" containsString:@"Purina"] /added
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
        UIView *wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20 , 330)]; //self.view.frame.size.height
        //[[UIView appearance] setBackgroundColor:[UIColor redColor]]; //added for problem solve
        
        //Add the image
        PFFile *image = (PFFile *)[wallObject objectForKey:KEY_IMAGE];
        UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        
        userImage.frame = CGRectMake(0, 65, wallImageView.frame.size.width, 225);
        [wallImageView addSubview:userImage];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wallImageView.frame.size.width,55)];
        infoLabel.text = [wallObject objectForKey:@"newsTitle"];
        infoLabel.font = [UIFont fontWithName:KEY_FONT size:20];
        infoLabel.textColor = [UIColor darkGrayColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.numberOfLines = 0;
        [wallImageView addSubview:infoLabel];
        /*
            NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:0]; //[wallObject objectForKey:@"createdAt"];
            NSString *ago = [date timeAgoSinceNow];
            NSLog(@"Output is: \"%@\"", ago); */
            
        //Add the info label (User and creation date)
         NSDate *creationDate = wallObject.createdAt;
         NSDateFormatter *df = [[NSDateFormatter alloc] init];
         [df setDateFormat:KEY_DATEFORMAT];

        //Add the comment
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, wallImageView.frame.size.width, 12)];
        //commentLabel.text = [NSString stringWithFormat:@"Uploaded by: %@, %@", [wallObject objectForKey:@"NewsDetail"], [df stringFromDate:creationDate]];
        commentLabel.text = [NSString stringWithFormat:@" %@, %@", [wallObject objectForKey:@"newsDetail"], [df stringFromDate:creationDate]];
        commentLabel.font = [UIFont fontWithName:KEY_FONT size:10];
        commentLabel.textColor = [UIColor lightGrayColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:commentLabel];
        
        UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 71 , 50, wallImageView.frame.size.width, 12)];
        readLabel.text = @"Read more";
        readLabel.font = [UIFont fontWithName:KEY_FONT size:10];
        readLabel.textColor = [UIColor blueColor];
        readLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:readLabel];
        
        UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(2,310, 20, 20)];
        [faceBtn setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
        [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:faceBtn];
        
        UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(32,310, 20, 20)];
        [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
        [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:twitBtn];
        
        UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(62,310, 20, 20)];
        [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
        [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:tumblrBtn];
        
        UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(92,310, 20, 20)];
        [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
        [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [wallImageView addSubview:yourBtn];
     //   wallImageView = UIEdgeInsetsMake(0.0f, myCell.frame.size.width, 0.0f, 400.0f);
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 343, self.view.frame.size.width, .8)];
        separatorLineView.backgroundColor = [UIColor grayColor];// you can also put image here
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

#pragma mark IB Actions
/*
-(IBAction)logoutPressed:(id)sender
{
    //TODO
    //If logout succesful:
    [self.navigationController popViewControllerAnimated:YES];
} */

#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

#pragma mark - search
- (void)searchButton:(id)sender {
    
     self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
     self.searchBar.text=@"";
     self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{ /*
    if(searchText.length == 0)
    {
        isFilltered = NO;
    } else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        
        for(Location* string in _feedItems)
        {
            if (self.searchBar.selectedScopeButtonIndex == 0)
            {
                NSRange stringRange = [string.name rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 1)
            {
                NSRange stringRange = [string.city rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
            
            if (self.searchBar.selectedScopeButtonIndex == 2)
            {
                NSRange stringRange = [string.phone rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch];
                if(stringRange.location != NSNotFound) {
                    [filteredString addObject:string];
                }
            }
        }
    } */
}

#pragma mark - Airdrop
- (void)share:(id)sender{
    //airdrop opens webpage
    NSString * message = @"newsTitle";
    NSString * message1 = @"Newsios";
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
