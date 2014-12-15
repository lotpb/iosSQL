//
//  EmployeeModel.h
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmployeeModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface EmployeeModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <EmployeeModelProtocol> delegate;

- (void)downloadItems;

@end
