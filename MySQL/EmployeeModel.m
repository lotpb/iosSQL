//
//  EmployeeModel.m
//  MySQL
//
//  Created by Peter Balsamo on 11/22/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "EmployeeModel.h"
#import "EmployeeLocation.h"

@interface EmployeeModel ()
{
    NSMutableData *_downloadedData;
}
@end

@implementation EmployeeModel

- (void)downloadItems
{
    // Download the json file localhost/iosLeads.php  gtvinyl.com/service.php
    
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://localhost:8888/iosEmployee.php"];
    
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

        EmployeeLocation *newLocation = [[EmployeeLocation alloc] init];
        newLocation.employeeNo = jsonElement[@"EmployeeNo"];
        newLocation.first = jsonElement[@"First Name"];
        newLocation.middle = jsonElement[@"Middle Name"];
        newLocation.lastname = jsonElement[@"Last Name"];
        newLocation.company = jsonElement[@"Company Name"];
        newLocation.social = jsonElement[@"Social Security"];
        newLocation.department = jsonElement[@"Department"];
        newLocation.titleEmploy = jsonElement[@"Title"];
        newLocation.manager = jsonElement[@"Manager"];
        newLocation.workphone = jsonElement[@"Work Phone"];
        newLocation.cellphone = jsonElement[@"Cell Phone"];
        newLocation.street = jsonElement[@"Street"];
        newLocation.city = jsonElement[@"City"];
        newLocation.state = jsonElement[@"State"];
        newLocation.country = jsonElement[@"Country"];
        newLocation.zip = jsonElement[@"Zip"];
        newLocation.homephone = jsonElement[@"Home Phone"];
        newLocation.email = jsonElement[@"Email"];
        newLocation.comments = jsonElement[@"Comments"];
        newLocation.active = jsonElement[@"Active"];
        newLocation.time = jsonElement[@"Time"];
        // Add this question to the locations array
        [_locations addObject:newLocation];
    }
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate) {
        [self.delegate itemsDownloaded:_locations];
    }
}

@end
