//
//  JobModel.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JobModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface JobModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <JobModelProtocol> delegate;

- (void)downloadItems;

@end
