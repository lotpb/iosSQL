//
//  LeadTodayModel.h
//  MySQL
//
//  Created by Peter Balsamo on 4/30/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LeadTodayModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray *)items;

@end

@interface LeadTodayModel : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, weak) id <LeadTodayModelProtocol> delegate;

- (void)downloadItems;

@end
