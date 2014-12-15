//
//  VendorModel.h
//  MySQL
//
//  Created by Peter Balsamo on 11/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VendorModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface VendorModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <VendorModelProtocol> delegate;

- (void)downloadItems;

@end
