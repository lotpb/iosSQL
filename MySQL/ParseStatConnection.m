//
//  ParseStatConnection.m
//  MySQL
//
//  Created by Peter Balsamo on 7/5/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "ParseStatConnection.h"

@interface ParseStatConnection ()
{
    NSMutableArray *_feedItems, *_feedItems1, *_feedItems2, *_feedItems3;
}
@end

@implementation ParseStatConnection


#pragma mark - Lead Form
- (void)parseTodayLeads {
    PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [query selectKeys:@[@"createdAt"]];
    [query whereKey:@"createdAt" equalTo:[NSDate date]];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLeadTodayloaded:_feedItems];
        }
    }];
}

- (void)parseActiveLeads {
    PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems1 = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLeadActiveloaded:_feedItems1];
        }
    }];
}

- (void)parseApptTodayLeads {
    PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [query selectKeys:@[@"createdAt"]];
    [query whereKey:@"createdAt" equalTo:[NSDate date]];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems3 = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLeadApptTodayloaded:_feedItems3];
        }
    }];
}

#pragma mark - Customer Form
- (void)parseActiveCust {
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems2 = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseCustActiveloaded:_feedItems2];
        }
    }];
}

- (void)parseWindowSold {
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems2 = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseWindowSoldloaded:_feedItems2];
        }
    }];
}

@end
