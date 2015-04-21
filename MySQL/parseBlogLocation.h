//
//  parseBlogLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 4/20/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "parseBlogLocation.h"

@interface parseBlogLocation :  NSObject

@property (nonatomic, strong) NSString *msgNo;
@property (nonatomic, strong) NSString *msgDate;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *postby;

@end
