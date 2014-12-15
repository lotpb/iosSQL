//
//  CustParse.h
//  MySQL
//
//  Created by Peter Balsamo on 12/14/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface CustParse : NSObject

@property (nonatomic, strong) NSString *name; // name of recipe
@property (nonatomic, strong) NSString *prepTime; // preparation time
@property (nonatomic, strong) PFFile *imageFile; // image of recipe
@property (nonatomic, strong) NSArray *ingredients; // ingredients

@end
