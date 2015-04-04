//
//  ParseConnection.h
//  MySQL
//
//  Created by Peter Balsamo on 4/3/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
//#import "EditData.h"

@interface ParseConnection : NSObject

// NSMutableArray *salesArray, *callbackArray, *contractorArray, *rateArray;

- (void)parseSalesman;
//- (void)parseJob:(NSString*)fm22;
- (void)parseJob;
- (void)parseProduct;
- (void)parseAd;
- (void)parseRate;
- (void)parseContractor;
- (void)parseCallback;

@property (strong, nonatomic) NSString *frm22;
@property (strong, nonatomic) NSString *frm23;
@property (strong, nonatomic) UITextField *jobName;
@property (strong, nonatomic) UITextField *adName;


@end
