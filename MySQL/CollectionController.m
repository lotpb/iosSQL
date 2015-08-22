//
//  CollectionController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/26/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "CollectionController.h"
#import "Constants.h"

@interface CollectionController ()
{   //Parse
    NSMutableArray *selectedJobs, *imageFilesArray;
    BOOL shareEnabled;
    UIRefreshControl *refreshControl;
    PFObject *imageObject;
    PFFile *imageFile;
}
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

@implementation CollectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imagesCollection.dataSource = self;
    self.imagesCollection.delegate = self;
    self.workseg = nil;
    [self queryParseMethod];
    
    // on iphone 5 need to change cell width to 100
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showdone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
#pragma mark RefreshControl
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.collectionView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];
    
    [refreshView addSubview:refreshControl];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize s = CGSizeMake([[UIScreen mainScreen] bounds].size.width/3 - 18, [[UIScreen mainScreen] bounds].size.height/7);
    return s;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)reloadDatas:(id)sender {
    
    [self queryParseMethod];
    [self.imagesCollection reloadData];
    
    if (refreshControl) {
        
        static NSDateFormatter *formatter = nil;
        if (formatter == nil) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:KEY_DATEREFRESH];
            NSString *lastUpdated = [NSString stringWithFormat:UPDATETEXT, [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:REFRESHTEXTCOLOR forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
            refreshControl.attributedTitle = attributedTitle;  }
        
        [refreshControl endRefreshing];
    }
}

- (void)showdone {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Parse
- (void)queryParseMethod {
    
    PFQuery *query = [PFQuery queryWithClassName:@"jobPhoto"];
    query.cachePolicy = kPFCACHEPOLICY;
    [query orderByDescending:KEY_CREATION_DATE];
    // [query whereKey:@"imageGroup" equalTo:self.workseg];
    [query whereKey:@"imageGroup" containsString:self.workseg];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSMutableArray alloc] initWithArray:objects];
            [_imagesCollection reloadData];
        }
    }];
}

-(IBAction)SegmentChangeViewValueChanged:(UISegmentedControl *)SControl
{
    if(self.segmentedControl.selectedSegmentIndex == 0)
    {
        self.workseg = nil;
    } else if(self.segmentedControl.selectedSegmentIndex == 1)
    {
        self.workseg = @"window";
    } else if(self.segmentedControl.selectedSegmentIndex == 2)
    {
        self.workseg = @"siding";
    } else if(self.segmentedControl.selectedSegmentIndex == 3)
    {
        self.workseg = @"door";
    }
    
    [self queryParseMethod];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *title = [[NSString alloc]initWithFormat:PHOTOHEADER, indexPath.section + (unsigned long)1];
        headerView.title.text = title;
        UIImage *headerImage = [UIImage imageNamed:PHOTOHEADERIMAGE];
        headerView.backgroundImage.image = headerImage;
        
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    JobViewCell *cell = (JobViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //Parse Download
    imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    imageFile = [imageObject objectForKey:KEY_IMAGE];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            cell.jobImageView.image = [UIImage imageWithData:data];
            
            cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PHOTOCELLIMAGE]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:PHOTOCELLSELECTIMAGE]];
            
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
        }
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"showPhoto" sender:self.imagesCollection];
    
    imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    imageFile = [imageObject objectForKey:KEY_IMAGE];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            
            self.selectedImage = [UIImage imageWithData:data];
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        
        CollectionDetailController *detailViewController = segue.destinationViewController;
        detailViewController.image = self.selectedImage;
    }
}

/*
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (shareEnabled) {
        return NO;
    } else {
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (shareEnabled) {
        NSString *deSelectedJob = [selectedJobs[indexPath.section] objectAtIndex:indexPath.row];
        [selectedJobs removeObject:deSelectedJob];
    }
} */

- (IBAction)shareButtonTouched:(id)sender {
    if (shareEnabled) {
        
        // Post selected photos to Facebook
        if ([selectedJobs count] > 0) {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller setInitialText:@"Check out my jobs!"];
                for (NSString *jobPhoto in selectedJobs) {
                    [controller addImage:[UIImage imageNamed:jobPhoto]];
                }
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }
        
        // Deselect all selected items
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
        
        // Remove all items from selectedRecipes array
        [selectedJobs removeAllObjects];
        
        // Change the sharing mode to NO
        shareEnabled = NO;
        self.collectionView.allowsMultipleSelection = NO;
        self.shareButton.title = PHOTOBUTTONTITLE1;
        [self.shareButton setStyle:UIBarButtonItemStylePlain];
        
    } else {
        
        // Change shareEnabled to YES and change the button text to DONE
        shareEnabled = YES;
        self.collectionView.allowsMultipleSelection = YES;
        self.shareButton.title = PHOTOBUTTONTITLE2;
        [self.shareButton setStyle:UIBarButtonItemStyleDone];
    }
}

@end
