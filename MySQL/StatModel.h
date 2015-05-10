//
//  StatModel.h
//  MySQL
//
//  Created by Peter Balsamo on 4/30/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface StatModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <StatModelProtocol> delegate;

- (void)downloadItems;

@end
