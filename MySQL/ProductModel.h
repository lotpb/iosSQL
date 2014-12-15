//
//  ProductModel.h
//  MySQL
//
//  Created by Peter Balsamo on 12/5/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProductModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface ProductModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <ProductModelProtocol> delegate;

- (void)downloadItems;

@end
