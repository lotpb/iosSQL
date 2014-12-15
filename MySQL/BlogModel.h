//
//  BlogModel.h
//  MySQL
//
//  Created by Peter Balsamo on 10/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BlogModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface BlogModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <BlogModelProtocol> delegate;

- (void)downloadItems;

@end
