//
//  StatModel.h
//  MySQL
//
//  Created by Peter Balsamo on 4/30/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatCustModelProtocol <NSObject>

- (void)itemsCustDownloaded:(NSArray *)itemsCust;

@end

@interface StatCustModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <StatCustModelProtocol> delegate;

- (void)downloadItems;

@end
