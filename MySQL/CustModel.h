//
//  CustModel.h
//  MySQL
//
//  Created by Peter Balsamo on 11/1/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface CustModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <CustModelProtocol> delegate;

- (void)downloadItems;

@end
