//
//  NewsController.m
//  MySQL
//
//  Created by Peter Balsamo on 11/2/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "NewsController.h"
#import "CustomTableViewCell.h"

@interface NewsController ()
{
  //  UIRefreshControl *refreshControl;
        NSArray *tableData, *tableData1, *tableImage;
}
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end

@implementation NewsController

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.title = NSLocalizedString(@"News", nil);
    self.listTableView.estimatedRowHeight = 44.0;
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.hidden = NO;
    self.listTableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    self.listTableView.contentInset = inset;    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    self.searchBar.barTintColor = [UIColor clearColor];
    self.searchBar.showsScopeBar = YES;
    self.searchBar.scopeButtonTitles = @[@"title",@"subtitle"];
    self.definesPresentationContext = YES;

    tableData = [NSArray arrayWithObjects:@"Big changes for Twitter, will new users follow?", @"Will retail sales reveal truth about cheap gas?", @"Vendor Info", @"Blog", nil];
    tableData1 = [NSArray arrayWithObjects:@"Yahoo Finance 2 hrs ago", @"CNBC 2 hrs ago", @"Vendor Info", @"Blog", nil];
     tableImage = [NSArray arrayWithObjects:@"profile-rabbit-toy.png", @"calendar_photo.jpg", @"tag_photo.jpg", @"bookmark_photo.jpg", nil];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.listTableView reloadData];
}

#pragma mark - Search
- (void)searchButton:(id)sender{
    self.searchBar.hidden = NO;
    [self.searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text=@"";
    self.searchBar.hidden = YES;
    [self.searchBar resignFirstResponder];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableData count];
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"newsCell";
    CustomTableViewCell *myCell = (CustomTableViewCell *)[self.listTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (myCell == nil) {
        myCell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        myCell.accessoryType = UITableViewCellAccessoryNone;
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    myCell.separatorInset = UIEdgeInsetsMake(0.0f, myCell.frame.size.width, 0.0f, 400.0f);
    myCell.newstitleLabel.text = [tableData objectAtIndex:indexPath.row];
    myCell.newssubtitleLabel.text = [tableData1 objectAtIndex:indexPath.row];
    myCell.newsreadmore.text = @"Read more";
    myCell.newsImageView.image = [UIImage imageNamed:[tableImage objectAtIndex:indexPath.row]];
   
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,70, 20, 20)];
    [faceBtn setImage:[UIImage imageNamed:@"Facebook.png"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:faceBtn];
    
    UIButton *twitBtn = [[UIButton alloc] initWithFrame:CGRectMake(40,70, 20, 20)];
    [twitBtn setImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    [twitBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:twitBtn];
    
    UIButton *tumblrBtn = [[UIButton alloc] initWithFrame:CGRectMake(70,70, 20, 20)];
    [tumblrBtn setImage:[UIImage imageNamed:@"Tumblr.png"] forState:UIControlStateNormal];
    [tumblrBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:tumblrBtn];
    
    UIButton *yourBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,70, 20, 20)];
    [yourBtn setImage:[UIImage imageNamed:@"Flickr.png"] forState:UIControlStateNormal];
    [yourBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [myCell.contentView addSubview:yourBtn];
    
    return myCell;
}

#pragma mark - Airdrop
- (void)share:(id)sender{
    //airdrop opens webpage
    NSString * message = self.newstitleLabel.text;
    NSString * message1 = self.newssubtitleLabel.text;
    UIImage * image = [UIImage imageNamed:@"IMG_1133.jpg"];
    NSArray * shareItems = @[message, message1, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

@end
