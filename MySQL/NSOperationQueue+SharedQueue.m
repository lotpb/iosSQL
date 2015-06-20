//
//  NSOperationQueue+SharedQueue.m
//  MySQL
//
//  Created by Peter Balsamo on 6/18/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"

//Source http://www.raywenderlich.com/44833/integrating-facebook-and-parse-tutorial-part-2

@implementation NSOperationQueue (SharedQueue)

+ (NSOperationQueue *) pffileOperationQueue {
    static NSOperationQueue *pffileQueue = nil;
    if (pffileQueue == nil) {
        pffileQueue = [[NSOperationQueue alloc] init];
        [pffileQueue setName:@"com.rwtutorial.pffilequeue"];
    }
    return pffileQueue;
}

@end
