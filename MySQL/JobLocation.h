//
//  JobLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobLocation.h"

@interface JobLocation : NSObject

@property (nonatomic, strong) NSString *jobNo;
@property (nonatomic, strong) NSString *jobdescription;
@property (nonatomic, strong) NSString *active;

@end
