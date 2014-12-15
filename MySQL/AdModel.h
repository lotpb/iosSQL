//
//  AdModel.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface AdModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <AdModelProtocol> delegate;

- (void)downloadItems;

@end
