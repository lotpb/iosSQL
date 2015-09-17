//
//  ParseStatConnection.h
//  MySQL
//
//  Created by Peter Balsamo on 7/5/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"

@protocol ParseStatConnectionProtocal <NSObject>

@required

- (void)parseLeadTodayloaded:(NSMutableArray *)leadItem;
- (void)parseLeadApptTodayloaded:(NSMutableArray *)leadItem;
- (void)parseLeadApptTomorrowloaded:(NSMutableArray *)leadItem;
- (void)parseLeadActiveloaded:(NSMutableArray *)leadItem;
- (void)parseLeadYearloaded:(NSMutableArray *)leadItem;

- (void)parseCustTodayloaded:(NSMutableArray *)leadItem;
- (void)parseCustYesterdayloaded:(NSMutableArray *)leadItem;
- (void)parseWindowSoldloaded:(NSMutableArray *)leadItem;
- (void)parseCustActiveloaded:(NSMutableArray *)leadItem;
- (void)parseCustYearloaded:(NSMutableArray *)leadItem;

@end

@interface ParseStatConnection : NSObject

@property (weak, nonatomic) id<ParseStatConnectionProtocal> delegate;

- (void)parseTodayLeads;
- (void)parseApptTodayLeads;
- (void)parseApptTomorrowLeads;
- (void)parseActiveLeads;
- (void)parseYearLeads;

- (void)parseTodayCust;
- (void)parseYesterdayCust;
- (void)parseWindowSold;
- (void)parseActiveCust;
- (void)parseYearCust;



@end
