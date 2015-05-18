//
//  LeadTodayModel.m
//  MySQL
//
//  Created by Peter Balsamo on 4/30/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "StatModel.h"
#import "CustLocation.h"

@interface StatModel ()
{
    NSMutableData *_downloadedData;
}
@end

@implementation StatModel

- (void)downloadItems
{
    // Download the json file
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/iosStatisticCustomer.php"];
    
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
        newLocation.custNo = jsonElement[@"CustNo"];
     /*   newLocation.leadNo = jsonElement[@"LeadNo"];
        newLocation.date = jsonElement[@"Date"];
        newLocation.address = jsonElement[@"Address"];
        newLocation.city = jsonElement[@"City"];
        newLocation.state = jsonElement[@"State"];
        newLocation.zip = jsonElement[@"Zip Code"];
        newLocation.phone = jsonElement[@"Phone"];
        newLocation.quan = jsonElement[@"Quan"];
        newLocation.jobNo = jsonElement[@"JobNo"];
        newLocation.amount = jsonElement[@"Amount"];
        newLocation.start = jsonElement[@"Start Date"];
        newLocation.completion = jsonElement[@"Completion Date"];
        newLocation.salesNo = jsonElement[@"SalesNo"];
        newLocation.comments = jsonElement[@"Comments"];
        newLocation.prodNo = jsonElement[@"ProductNo"];
        newLocation.active = jsonElement[@"Active"];
        newLocation.rate = jsonElement[@"Rate"];
        newLocation.contractor = jsonElement[@"Contractor"];
        newLocation.photo = jsonElement[@"Photo"];
        newLocation.photo1 = jsonElement[@"Photo1"];
        newLocation.photo2 = jsonElement[@"Photo2"];
        newLocation.email = jsonElement[@"Email"];
        newLocation.first = jsonElement[@"First"];
        newLocation.spouse = jsonElement[@"Spouse"];
        newLocation.lastname = jsonElement[@"Last Name"];
        newLocation.time = jsonElement[@"Time"]; */
        
        // Add this question to the locations array
        [_locations addObject:newLocation];
    }
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate) {
        [self.delegate itemsDownloaded:_locations];
    }
}


@end
