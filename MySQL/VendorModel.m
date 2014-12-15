//
//  VendorModel.m
//  MySQL
//
//  Created by Peter Balsamo on 11/12/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "VendorModel.h"
#import "VendLocation.h"

@interface VendorModel ()
{
   NSMutableData *_downloadedData;
}

@end

@implementation VendorModel

- (void)downloadItems
{
    // Download the json file localhost/iosLeads.php  gtvinyl.com/service.php
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/iosVendors.php"];
    
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
        
        // Create a new location object and set its props to JsonElement properties
        VendLocation *newLocation = [[VendLocation alloc] init];
        newLocation.vendorNo = jsonElement[@"VendorNo"];
        newLocation.vendorName = jsonElement[@"Vendor Name"];
        newLocation.address = jsonElement[@"Address"];
        newLocation.city = jsonElement[@"City"];
        newLocation.state = jsonElement[@"State"];
        newLocation.zip = jsonElement[@"Zip"];
        newLocation.phone = jsonElement[@"Phone"];
        newLocation.phone1 = jsonElement[@"Phone1"];
        newLocation.phone2 = jsonElement[@"Phone2"];
        newLocation.phone3 = jsonElement[@"Phone3"];
        newLocation.email = jsonElement[@"Email"];
        newLocation.webpage = jsonElement[@"Web Page"];
        newLocation.department = jsonElement[@"Department"];
        newLocation.office = jsonElement[@"Office"];
        newLocation.manager = jsonElement[@"Manager"];
        newLocation.profession = jsonElement[@"Profession"];
        newLocation.assistant = jsonElement[@"Assistant"];
        newLocation.comments = jsonElement[@"Comments"];
        newLocation.active = jsonElement[@"Active"];
        
        // Add this question to the locations array
        [_locations addObject:newLocation];
    }
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:_locations];
    }
}

@end
