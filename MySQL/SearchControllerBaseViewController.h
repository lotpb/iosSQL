//
//  SearchControllerBaseViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 2/16/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

@import UIKit;

@interface SearchControllerBaseViewController : UITableViewController

/// A nil / empty filter string means show all results. Otherwise, show
/// only results containing the filter.
@property (nonatomic, copy) NSString *filterString;

@property (readonly, copy) NSArray *visibleResults;
@end
