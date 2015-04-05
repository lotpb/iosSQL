//
//  ParseConnection.m
//  MySQL
//
//  Created by Peter Balsamo on 4/3/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "ParseConnection.h"

@interface ParseConnection ()
{
  //  NSMutableArray *salesArray, *callbackArray, *contractorArray, *rateArray, *zipArray, *jobArray;
}
@end

@implementation ParseConnection

#pragma mark - EditData PickerView
- (void)parseSalesman {
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"SalesNo"];
    [query whereKey:@"Active" containsString:@"Active"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

- (void)parseRate {
    PFQuery *query14 = [PFQuery queryWithClassName:@"Rate"];
    query14.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query14 selectKeys:@[@"rating"]];
    [query14 orderByDescending:@"rating"];
    [query14 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        rateArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

- (void)parseContractor {
    PFQuery *query13 = [PFQuery queryWithClassName:@"Contractor"];
    query13.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query13 selectKeys:@[@"Contractor"]];
    [query13 orderByDescending:@"Contractor"];
    [query13 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        contractorArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

- (void)parseCallback {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
    query1.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query1 selectKeys:@[@"Callback"]];
    [query1 orderByDescending:@"Callback"];
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callbackArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

#pragma mark - Lookup Form
- (void)parseZip { //lookup city
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
    [PFQuery clearAllCachedResults];
    //[query selectKeys:@[@"ZipNo"]];
    [query selectKeys:@[@"City"]];
    [query selectKeys:@[@"State"]];
    [query selectKeys:@[@"zipCode"]];
    [query orderByAscending:@"City"];
    [query setLimit: 1000]; //parse.com standard is 100
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [zipArray addObject:object];
              //  [self.listTableView reloadData];
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

- (void)parseLookupJob { //lookup job
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    [PFQuery clearAllCachedResults];
    [query selectKeys:@[@"JobNo"]];
    [query selectKeys:@[@"Description"]];
    [query orderByDescending:@"Description"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                [jobArray addObject:object];
              //  [self.listTableView reloadData];
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

- (void)parseLookupProduct { //lookup product
}


//- (void)parseJob:(NSString*)fm22  {
- (void)parseJob {
    PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
    query21.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query21 whereKey:@"JobNo" equalTo:self.frm22];
    [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.jobName.text = [object objectForKey:@"Description"];
    }];
}

- (void)parseProduct {
    PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
    query3.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query3 whereKey:@"ProductNo" containsString:self.frm23];
    [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.adName.text = [object objectForKey:@"Products"];
    }];
}

- (void)parseAd {
    PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
    query11.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query11 whereKey:@"AdNo" equalTo:self.frm23];
    [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.adName.text = [object objectForKey:@"Advertiser"];
    }];
}


@end
