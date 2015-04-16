//
//  ParseConnection.h
//  MySQL
//
//  Created by Peter Balsamo on 4/3/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Constants.h"

@protocol ParseConnectionProtocal <NSObject>

@required

- (void)parseSalesmanloaded:(NSMutableArray *)salesItem;
- (void)parseRateloaded:(NSMutableArray *)rateItem;
- (void)parseContractorloaded:(NSMutableArray *)contractItem;
- (void)parseCallbackloaded:(NSMutableArray *)callbackItem;
- (void)parseLookupZiploaded:(NSMutableArray *)zipItem;
- (void)parseLookupJobloaded:(NSMutableArray *)jobItem;
- (void)parseLookupProductloaded:(NSMutableArray *)prodItem;
- (void)parseLookupAdloaded:(NSMutableArray *)adItem;
- (void)parseHeadSalesmanloaded:(NSMutableArray *)salesheadItem;
- (void)parseHeadJobloaded:(NSMutableArray *)jobheadItem;
- (void)parseHeadAdloaded:(NSMutableArray *)adheadItem;
- (void)parseHeadProductloaded:(NSMutableArray *)prodheadItem;

@end

@interface ParseConnection : NSObject

@property (weak, nonatomic) id<ParseConnectionProtocal> delegate;

- (void)parseSalesman;
- (void)parseRate;
- (void)parseContractor;
- (void)parseCallback;
- (void)parseLookupZip;
- (void)parseLookupJob;
- (void)parseLookupProduct;
- (void)parseLookupAd;
- (void)parseHeadSalesman;
- (void)parseHeadJob;
- (void)parseHeadAd;
- (void)parseHeadProduct;

@property (strong, nonatomic) NSString *frm22;
@property (strong, nonatomic) NSString *frm23;
@property (strong, nonatomic) UITextField *jobName;
@property (strong, nonatomic) UITextField *adName;

@end
