
//
//  MainViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

#import "SearchResultsViewController.h"

@interface MainViewController ()
{
   UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.edgesForExtendedLayout = UIRectEdgeNone;//fix
     self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mySQLHOME.png"]];
     //self.title = NSLocalizedString(@"Main Menu", nil);
     self.listTableView.delegate = self;
     self.listTableView.dataSource = self;
    // self.listTableView.backgroundColor = [UIColor clearColor];
   
if ([self.tabBarController.tabBar respondsToSelector:@selector(setTranslucent:)]) {
    [self.tabBarController.tabBar setTranslucent:NO];
    [self.tabBarController.tabBar setTintColor:TABTINTCOLOR];
    }

    tableData = [[NSMutableArray alloc]initWithObjects:@"Lead", @"Customer", @"Vendor", @"Employee", @"Advertising", @"Product", @"Job", @"Salesman", @"Blog", nil];
 
#pragma mark Bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
#pragma mark Sidebar
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    _sidebarButton.tintColor = SIDEBARTINTCOLOR;
    
#pragma mark TableRefresh
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.listTableView insertSubview:refreshView atIndex:0]; //the tableView is a IBOutlet
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = REFRESHCOLOR;
    [refreshControl setTintColor:REFRESHTEXTCOLOR];
    [refreshControl addTarget:self action:@selector(reloadDatas:) forControlEvents:UIControlEventValueChanged];

    [refreshView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = MAINNAVCOLOR;
     self.navigationController.navigationBar.translucent = NAVTRANSLUCENT;
    // self.navigationController.navigationBar.tintColor = NAVTINTCOLOR;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RefreshControl
-(void)reloadDatas:(id)sender {
    
    [self.listTableView reloadData];
    
    if (refreshControl) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:KEY_DATEREFRESH];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
            forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated attributes:attrsDictionary];
        refreshControl.attributedTitle = attributedTitle;

    [refreshControl endRefreshing];
    }
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFilltered)
        return [filteredString count];
    
    return [tableData count];
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"mainCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil)
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if (!isFilltered)
       myCell.textLabel.text = [tableData objectAtIndex:indexPath.row];
       else
       myCell.textLabel.text = [filteredString objectAtIndex:indexPath.row];
    
    if (self.searchController.searchBar.text.length > 0)
        myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return myCell;
}

#pragma mark TableHeader
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!isFilltered)
        return 175.0;
    else return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *newString = [NSString stringWithFormat:@"FOLLOW \n%lu", (unsigned long) tableData.count];
    NSString *newString1 = [NSString stringWithFormat:HEADTITLE2];
    NSString *newString2 = [NSString stringWithFormat:HEADTITLE3];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
    
    //[[UIView appearance] setBackgroundColor:[UIColor redColor]]; //added for problem solve
    
    tableView.tableHeaderView = view; //makes header move with tablecell
    
    UIImageView *imageHolder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 175)];
    UIImage *image = [UIImage imageNamed:@"IMG_1133NEW.jpg"];
    imageHolder.image = image;
    [view addSubview:imageHolder];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 122, tableView.frame.size.width, 45)];
    [label setFont:CELL_FONT(HEADFONTSIZE)];
    [label setTextColor:HEADCOLOR];
    label.numberOfLines = 0;
    NSString *string = newString;
    [label setText:string];
    [view addSubview:label];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(12, 162, 60, 1.5)];
    separatorLineView.backgroundColor = [UIColor greenColor];
    [view addSubview:separatorLineView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(85, 122, tableView.frame.size.width, 45)];
    label1.numberOfLines = 0;
    [label1 setFont:CELL_FONT(HEADFONTSIZE)];
    [label1 setTextColor:HEADCOLOR];
    NSString *string1 = newString1;
    [label1 setText:string1];
    [view addSubview:label1];
    
    UIView* separatorLineView1 = [[UIView alloc] initWithFrame:CGRectMake(85, 162, 60, 1.5)];
    separatorLineView1.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(158, 122, tableView.frame.size.width, 45)];
    label2.numberOfLines = 0;
    [label2 setFont:CELL_FONT(HEADFONTSIZE)];
    [label2 setTextColor:HEADCOLOR];
    NSString *string2 = newString2;
    [label2 setText:string2];
    [view addSubview:label2];
    
    UIView* separatorLineView2 = [[UIView alloc] initWithFrame:CGRectMake(158, 162, 60, 1.5)];
    separatorLineView2.backgroundColor = [UIColor redColor];
    [view addSubview:separatorLineView2];
    /*
    if (!isFilltered)
        [view setBackgroundColor:[UIColor clearColor]];
    else
        [view setBackgroundColor:[UIColor blackColor]]; */
    
    return view;
}

#pragma mark - Search
- (void)searchButton:(id)sender {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
   [self.searchController.searchBar sizeToFit];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.barStyle = SEARCHBARSTYLE;
    self.searchController.searchBar.tintColor = SEARCHTINTCOLORMAIN;
    self.searchController.hidesBottomBarWhenPushed = YES;
    self.listTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.edgesForExtendedLayout = UIRectEdgeNone;

    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
         self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
       }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
        isFilltered = NO;
        else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(NSString *str in tableData)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
                [filteredString addObject:str];
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *mycell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([mycell.textLabel.text isEqualToString:@"Lead"])
        [self performSegueWithIdentifier:@"leadDetailSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Customer"])
        [self performSegueWithIdentifier:@"custDetailSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Vendor"])
        [self performSegueWithIdentifier:@"vendDetailSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Employee"])
        [self performSegueWithIdentifier:@"employeeSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Advertising"])
        [self performSegueWithIdentifier:@"adSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Product"])
        [self performSegueWithIdentifier:@"prodSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Job"])
        [self performSegueWithIdentifier:@"jobSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Salesman"])
        [self performSegueWithIdentifier:@"saleSegue" sender:nil];
    
    if ([mycell.textLabel.text isEqualToString:@"Blog"])
        [self performSegueWithIdentifier:@"blogSegue" sender:nil];
}

@end





