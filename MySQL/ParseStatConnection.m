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
    NSMutableArray *_feedItems;
}

@end

@implementation ParseStatConnection

static NSDateFormatter *formatter = nil;

#pragma mark - Lead Form
- (void)parseTodayLeads {
    
    if (formatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
        [query selectKeys:@[@"Date"]];
        [query whereKey:@"Date" equalTo:stringFromDate];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseLeadTodayloaded:_feedItems];
            }
        }];
    }
}

- (void)parseApptTodayLeads {
    if (formatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
        [query selectKeys:@[@"AptDate"]];
        [query whereKey:@"AptDate" equalTo:stringFromDate];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseLeadApptTodayloaded:_feedItems];
            }
        }];
    }
}

- (void)parseApptTomorrowLeads {
    if (formatter == nil) {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:nextDate];
        PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
        [query selectKeys:@[@"AptDate"]];
        [query whereKey:@"AptDate" equalTo:stringFromDate];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseLeadApptTomorrowloaded:_feedItems];
                //NSLog(@"Object Peter Baby id %@",_feedItems3);
            }
        }];
    }
}

- (void)parseActiveLeads {
    PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLeadActiveloaded:_feedItems];
        }
    }];
}

- (void)parseYearLeads {
    if (formatter == nil) {
        NSTimeInterval secondsPerDay = (8760 * 60 * 60);
        NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFrom = [formatter stringFromDate:nextDate];
        NSString *stringTo = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
        [query selectKeys:@[@"Date"]];
        [query whereKey:@"Date" greaterThan:stringFrom];
        [query whereKey:@"Date" lessThan:stringTo];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseLeadYearloaded:_feedItems];
                //NSLog(@"Object Peter Baby id %@",stringFrom);
                //NSLog(@"Object Peter Baby id %@",_feedItems);
            }
        }];
    }
}

#pragma mark - Customer Form
- (void)parseTodayCust {
    if (formatter == nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query selectKeys:@[@"Date"]];
        [query whereKey:@"Date" equalTo:stringFromDate];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseCustTodayloaded:_feedItems];
            }
        }];
    }
}

- (void)parseYesterdayCust {
    if (formatter == nil) {
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFromDate = [formatter stringFromDate:nextDate];
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query selectKeys:@[@"Date"]];
        [query whereKey:@"Date" equalTo:stringFromDate];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseCustYesterdayloaded:_feedItems];
            }
        }];
    }
}

- (void)parseActiveCust {
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseCustActiveloaded:_feedItems];
        }
    }];
}

- (void)parseWindowSold {
    if (formatter == nil) {
        NSTimeInterval secondsPerDay = (8760 * 60 * 60);
        NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFrom = [formatter stringFromDate:nextDate];
        NSString *stringTo = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query selectKeys:@[@"Quan"]];
        [query whereKey:@"Date" greaterThan:stringFrom];
        [query whereKey:@"Date" lessThan:stringTo];
        [query whereKey:@"Quan" greaterThanOrEqualTo:@1];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseWindowSoldloaded:_feedItems];
            }
        }];
    } 
}

- (void)parseYearCust {
    if (formatter == nil) {
        NSTimeInterval secondsPerDay = (8760 * 60 * 60);
        NSDate *nextDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *stringFrom = [formatter stringFromDate:nextDate];
        NSString *stringTo = [formatter stringFromDate:[NSDate date]];
        PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
        [query selectKeys:@[@"Date"]];
        [query whereKey:@"Date" greaterThan:stringFrom];
        [query whereKey:@"Date" lessThan:stringTo];
        query.cachePolicy = kPFCACHEPOLICY;
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            if (self.delegate) {
                [self.delegate parseCustYearloaded:_feedItems];
            }
        }];
    }
}



@end
