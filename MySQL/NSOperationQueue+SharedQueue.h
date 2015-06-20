//
//  NSOperationQueue+SharedQueue.h
//  MySQL
//
//  Created by Peter Balsamo on 6/18/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (SharedQueue)

+ (NSOperationQueue *) pffileOperationQueue;

@end
