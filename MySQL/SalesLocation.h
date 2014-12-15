//
//  SalesLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 12/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalesLocation.h"

@interface SalesLocation : NSObject

@property (nonatomic, strong) NSString *salesNo;
@property (nonatomic, strong) NSString *salesman;
@property (nonatomic, strong) NSString *active;

@end
