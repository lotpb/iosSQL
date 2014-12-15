//
//  BlogLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogLocation.h"


@interface BlogLocation : NSObject

@property (nonatomic, strong) NSString *msgNo;
@property (nonatomic, strong) NSString *msgDate;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *postby;

@end
