//
//  StatLeadModel.h
//  MySQL
//
//  Created by Peter Balsamo on 5/17/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatLeadModelProtocol <NSObject>

- (void)itemsLeadDownloaded:(NSArray *)itemsLead;

@end

@interface StatLeadModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <StatLeadModelProtocol> delegate;

- (void)downloadItems;

@end
