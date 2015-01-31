//
//  VendLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 11/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "VendLocation.h"

@interface VendLocation : NSObject

@property (nonatomic, strong) NSString *vendorNo;
@property (nonatomic, strong) NSString *vendorName;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *phone1;
@property (nonatomic, strong) NSString *phone2;
@property (nonatomic, strong) NSString *phone3;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *webpage;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *office;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSString *assistant;
@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *time;

@end

