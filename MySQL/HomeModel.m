//
//  HomeModel.m
//  MySQL
//
//  Created by Peter Balsamo on 9/29/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "HomeModel.h"
#import "Location.h"

@interface HomeModel()
{
    NSMutableData *_downloadedData;
}
@end

@implementation HomeModel

- (void)downloadItems
{
    // Download the json file localhost/iosLeads.php  gtvinyl.com/service.php
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/iosLeads.php"];
    
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
        Location *newLocation = [[Location alloc] init];
        newLocation.leadNo = jsonElement[@"LeadNo"];
        newLocation.name = jsonElement[@"Last Name"];
        newLocation.address = jsonElement[@"Address"];
        newLocation.date = jsonElement[@"Date"];
        newLocation.city = jsonElement[@"City"];
        newLocation.state = jsonElement[@"State"];
        newLocation.zip = jsonElement[@"Zip Code"];
        newLocation.salesNo = jsonElement[@"SalesNo"];
        newLocation.comments = jsonElement[@"Coments"];
        newLocation.amount = jsonElement[@"Amount"];
        newLocation.phone = jsonElement[@"Phone"];
        newLocation.aptdate = jsonElement[@"Apt date"];
        newLocation.email = jsonElement[@"Email"];
        newLocation.jobNo = jsonElement[@"JobNo"];
        newLocation.adNo = jsonElement[@"AdNo"];
        newLocation.first = jsonElement[@"First"];
        newLocation.spouse = jsonElement[@"Spouse"];
        newLocation.active = jsonElement[@"Active"];
        newLocation.callback = jsonElement[@"Call Back"];
        newLocation.time = jsonElement[@"Time"];
        newLocation.photo = jsonElement[@"Photo"];
//        newLocation.salesman = jsonElement[@"Salesman"];
//        newLocation.jobdescription = jsonElement[@"Description"];
//        newLocation.advertiser = jsonElement[@"Advertiser"];
        
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
