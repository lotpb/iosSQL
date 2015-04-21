//
//  DataLocation.h
//  MySQL
//
//  Created by Peter Balsamo on 4/20/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLocation.h"

@interface DataLocation : NSObject

//SALESMAN
@property (nonatomic, strong) NSString *salesNo;
@property (nonatomic, strong) NSString *salesman;
@property (nonatomic, strong) NSString *active;

//JOBS
@property (nonatomic, strong) NSString *jobNo;
@property (nonatomic, strong) NSString *jobdescription;
//@property (nonatomic, strong) NSString *active;

//PRODUCT
@property (nonatomic, strong) NSString *productNo;
@property (nonatomic, strong) NSString *products;
//@property (nonatomic, strong) NSString *active;

//ADVERTISER
@property (nonatomic, strong) NSString *AdNo;
@property (nonatomic, strong) NSString *Advertiser;
//@property (nonatomic, strong) NSString *active;

//EMPLOYEE
@property (nonatomic, strong) NSString *employeeNo;
@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *middle;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *social;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *titleEmploy;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSString *workphone;
@property (nonatomic, strong) NSString *cellphone;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *homephone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *comments;
//@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *time;

//BLOG
@property (nonatomic, strong) NSString *msgNo;
@property (nonatomic, strong) NSString *msgDate;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *postby;

//VENDOR
@property (nonatomic, strong) NSString *vendorNo;
@property (nonatomic, strong) NSString *vendorName;
@property (nonatomic, strong) NSString *address;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *state;
//@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *phone1;
@property (nonatomic, strong) NSString *phone2;
@property (nonatomic, strong) NSString *phone3;
//@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *webpage;
//@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *office;
//@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) NSString *profession;
@property (nonatomic, strong) NSString *assistant;
//@property (nonatomic, strong) NSString *comments;
//@property (nonatomic, strong) NSString *active;
//@property (nonatomic, strong) NSString *time;

//CUSTOMER
@property (nonatomic, strong) NSString *custNo;
@property (nonatomic, strong) NSString *leadNo;
@property (nonatomic, strong) NSString *date;
//@property (nonatomic, strong) NSString *address;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *state;
//@property (nonatomic, strong) NSString *zip;
//@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *quan;
//@property (nonatomic, strong) NSString *jobNo;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *start;
@property (nonatomic, strong) NSString *completion;
//@property (nonatomic, strong) NSString *salesNo;
//@property (nonatomic, strong) NSString *comments;
@property (nonatomic, strong) NSString *prodNo;
//@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *contractor;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *photo1;
@property (nonatomic, strong) NSString *photo2;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *first;
@property (nonatomic, strong) NSString *spouse;
//@property (nonatomic, strong) NSString *lastname;
//@property (nonatomic, strong) NSString *time;

//LEADS
//@property (nonatomic, strong) NSString *leadNo;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *address;
//@property (nonatomic, strong) NSString *date;
//@property (nonatomic, strong) NSString *city;
//@property (nonatomic, strong) NSString *state;
//@property (nonatomic, strong) NSString *zip;
//@property (nonatomic, strong) NSString *comments;
//@property (nonatomic, strong) NSString *amount;
//@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *aptdate;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *first;
//@property (nonatomic, strong) NSString *spouse;
//@property (nonatomic, strong) NSString *active;
@property (nonatomic, strong) NSString *callback;
//@property (nonatomic, strong) NSString *time;
//@property (nonatomic, strong) NSString *photo;
//@property (nonatomic, strong) NSString *salesNo;
//@property (nonatomic, strong) NSString *jobNo;
@property (nonatomic, strong) NSString *adNo;


@end
