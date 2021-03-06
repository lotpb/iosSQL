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

- (void)parseNewsloaded:(NSMutableArray *)newsItem;
- (void)parseJobPhotoloaded:(NSMutableArray *)jobphotoItem;
- (void)parseUserloaded:(NSMutableArray *)userItem;
- (void)parseBlogloaded:(NSMutableArray *)blogItem;
- (void)parseCustomerloaded:(NSMutableArray *)custItem;
- (void)parseLeadloaded:(NSMutableArray *)leadItem;
- (void)parseVendorloaded:(NSMutableArray *)vendItem;
- (void)parseEmployeeloaded:(NSMutableArray *)employItem;
- (void)parseAdvertiserloaded:(NSMutableArray *)adItem;
- (void)parseProductloaded:(NSMutableArray *)prodItem;
- (void)parseJobloaded:(NSMutableArray *)jobItem;
- (void)parseSalesmanloaded:(NSMutableArray *)saleItem;
//PickerView
- (void)parseSalesPickloaded:(NSMutableArray *)salesItem;
- (void)parseRatePickloaded:(NSMutableArray *)rateItem;
- (void)parseContractorPickloaded:(NSMutableArray *)contractItem;
- (void)parseCallbackPickloaded:(NSMutableArray *)callbackItem;
//Lookup
- (void)parseLookupZiploaded:(NSMutableArray *)zipItem;
- (void)parseLookupJobloaded:(NSMutableArray *)jobItem;
- (void)parseLookupProductloaded:(NSMutableArray *)prodItem;
- (void)parseLookupAdloaded:(NSMutableArray *)adItem;
- (void)parseLookupSalesloaded:(NSMutableArray *)saleLookItem;
//Header
- (void)parseHeadSalesmanloaded:(NSMutableArray *)salesheadItem;
- (void)parseHeadJobloaded:(NSMutableArray *)jobheadItem;
- (void)parseHeadAdloaded:(NSMutableArray *)adheadItem;
- (void)parseHeadProductloaded:(NSMutableArray *)prodheadItem;
- (void)parseHeadEmployeeloaded:(NSMutableArray *)employheadItem;
- (void)parseHeadVendorloaded:(NSMutableArray *)vendheadItem;
- (void)parseHeadLeadsloaded:(NSMutableArray *)leadheadItem;
- (void)parseHeadCustomerloaded:(NSMutableArray *)custheadItem;
- (void)parseHeadBlogloaded:(NSMutableArray *)blogheadItem;

@end

@interface ParseConnection : NSObject

@property (weak, nonatomic) id<ParseConnectionProtocal> delegate;

- (void)parseNews;
- (void)parseJobPhoto;
- (void)parseUser;
- (void)parseBlog;
- (void)parseCustomer;
- (void)parseLeads;
- (void)parseVendor;
- (void)parseEmployee;
- (void)parseAdvertiser;
- (void)parseProduct;
- (void)parseJob;
- (void)parseSalesman;
//PickerView
- (void)parseSalesPick;
- (void)parseRatePick;
- (void)parseContractorPick;
- (void)parseCallbackPick;
//Lookup
- (void)parseLookupZip;
- (void)parseLookupJob;
- (void)parseLookupProduct;
- (void)parseLookupAd;
- (void)parseLookupSalesman;
//Header
- (void)parseHeadSalesman;
- (void)parseHeadJob;
- (void)parseHeadAd;
- (void)parseHeadProduct;
- (void)parseHeadEmployee;
- (void)parseHeadVendor;
- (void)parseHeadLeads;
- (void)parseHeadCustomer;
- (void)parseHeadBlog;

//@property (strong, nonatomic) NSString *frm22;
//@property (strong, nonatomic) NSString *frm23;
//@property (strong, nonatomic) UITextField *jobName;
//@property (strong, nonatomic) UITextField *adName;

@end
