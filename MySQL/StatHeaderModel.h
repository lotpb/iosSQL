//
//  StatHeaderModel.h
//  MySQL
//
//  Created by Peter Balsamo on 5/9/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatHeaderModelProtocol <NSObject>

- (void)itemsHeaderDownloaded:(NSArray *)itemsHeader;

@end

@interface StatHeaderModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <StatHeaderModelProtocol> delegate;

- (void)downloadItems;

@end
