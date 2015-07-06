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
- (void)parseLeadActiveloaded:(NSMutableArray *)leadItem;
- (void)parseLeadApptTodayloaded:(NSMutableArray *)leadItem;
- (void)parseCustActiveloaded:(NSMutableArray *)leadItem;
- (void)parseWindowSoldloaded:(NSMutableArray *)leadItem;

@end

@interface ParseStatConnection : NSObject

@property (weak, nonatomic) id<ParseStatConnectionProtocal> delegate;

- (void)parseTodayLeads;
- (void)parseActiveLeads;
- (void)parseApptTodayLeads;
- (void)parseActiveCust;
- (void)parseWindowSold;

@end
