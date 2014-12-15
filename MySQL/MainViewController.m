
//
//  MainViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"

@interface MainViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@end

@implementation MainViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
    self.title = NSLocalizedString(@"Main Menu", nil);
    self.searchBar.hidden = YES;
    self.listTableView.backgroundColor = [UIColor clearColor];

    tableData = [[NSMutableArray alloc]initWithObjects:@"Lead", @"Customer", @"Vendor", @"Employee", @"Advertising", @"Product", @"Job", @"Salesman", @"Blog", nil];
#pragma mark bar Button
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButton:)];
    NSArray *actionButtonItems = @[searchItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
#pragma mark sidebar
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
     //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

//  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

#pragma mark - Search
- (void)searchButton:(id)sender{
   [self.searchBar becomeFirstResponder];
    self.searchBar.hidden = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
 self.searchBar.hidden = YES;
[self.listTableView reloadData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        isFilltered = NO;
    } else {
        isFilltered = YES;
        filteredString = [[NSMutableArray alloc]init];
        for(NSString *str in tableData)
        {
            NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound) {
                [filteredString addObject:str];
            }
        }
    }
    [self.listTableView reloadData];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFilltered) {
        return [filteredString count];
    }
        return [tableData count];
}

#pragma mark TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"mainCell";
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (myCell == nil) {
        myCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]; }
    
    if (!isFilltered) {
       myCell.textLabel.text = [tableData objectAtIndex:indexPath.row];
        
    } else {
       myCell.textLabel.text = [filteredString objectAtIndex:indexPath.row];
    }
    return myCell;
}

#pragma mark - Segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *mycell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([mycell.textLabel.text isEqualToString:@"Lead"]) {
        [self performSegueWithIdentifier:@"leadDetailSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Customer"]) {
        [self performSegueWithIdentifier:@"custDetailSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Vendor"]) {
        [self performSegueWithIdentifier:@"vendDetailSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Employee"]) {
        [self performSegueWithIdentifier:@"employeeSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Advertising"]) {
        [self performSegueWithIdentifier:@"adSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Product"]) {
        [self performSegueWithIdentifier:@"prodSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Job"]) {
        [self performSegueWithIdentifier:@"jobSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Salesman"]) {
        [self performSegueWithIdentifier:@"saleSegue" sender:nil];
    }
    
    if ([mycell.textLabel.text isEqualToString:@"Blog"]) {
        [self performSegueWithIdentifier:@"blogSegue" sender:nil];
    }
}

@end





