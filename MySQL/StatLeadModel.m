//
//  StatLeadModel.m
//  MySQL
//
//  Created by Peter Balsamo on 5/17/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "StatLeadModel.h"
#import "CustLocation.h"

@interface StatLeadModel ()
{
    NSMutableData *_downloadedData;
}

@end

@implementation StatLeadModel

- (void)downloadItems
{
    // Download the json file
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/iosStatisticLead.php"];
    
    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableArray *_locations = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
        NSDictionary *jsonElement = jsonArray[i];
        
        CustLocation *newLocation = [[CustLocation alloc] init];
       // newLocation.custNo = jsonElement[@"CustNo"];
        newLocation.leadNo = jsonElement[@"LeadNo"];
     
        
        // Add this question to the locations array
        [_locations addObject:newLocation];
    }
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate) {
        [self.delegate itemsLeadDownloaded:_locations];
    }
}

@end
