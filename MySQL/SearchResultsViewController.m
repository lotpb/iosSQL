//
//  SearchResultsViewController.m
//  MySQL
//
//  Created by Peter Balsamo on 2/16/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "SearchResultsViewController.h"

NSString *const SearchResultsViewControllerStoryboardIdentifier = @"SearchResultsViewControllerStoryboardIdentifier";

@implementation SearchResultsViewController


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // -updateSearchResultsForSearchController: is called when the controller is being dismissed to allow those who are using the controller they are search as the results controller a chance to reset their state. No need to update anything if we're being dismissed.
    if (!searchController.active) {
        return;
    }
    
    self.filterString = searchController.searchBar.text;
}

@end
