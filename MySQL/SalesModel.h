//
//  SalesModel.h
//  MySQL
//
//  Created by Peter Balsamo on 12/8/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SalesModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface SalesModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <SalesModelProtocol> delegate;

- (void)downloadItems;

@end
