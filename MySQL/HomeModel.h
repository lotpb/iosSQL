//
//  HomeModel.h
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface HomeModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <HomeModelProtocol> delegate;

- (void)downloadItems;

@end
