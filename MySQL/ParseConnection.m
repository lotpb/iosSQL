//
//  ParseConnection.m
//  MySQL
//
//  Created by Peter Balsamo on 4/3/15.
//  Copyright (c) 2015 Peter Balsamo. All rights reserved.
//

#import "ParseConnection.h"

@interface ParseConnection ()
{
    NSMutableArray *salesArray, *callbackArray, *contractorArray, *rateArray, *headCount, *_feedItems;
    int pageNumber;
    BOOL stopFetching, requestInProgress, forceRefresh;
}
@end

@implementation ParseConnection

//------------------Table Data----------------------------------
#pragma mark - Blog Form
- (void)parseBlog {
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query setLimit:1000]; //parse.com standard is 100
     //query.skip = pageNumber*50;
     query.cachePolicy = kPFCACHEPOLICY;
     //query.maxCacheAge = 60*60;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
         
                requestInProgress = NO;
                forceRefresh = NO;
                if (objects.count<50) {
                    stopFetching = YES;
                }
                
                pageNumber++;
                
                if (self.delegate) {
                    [self.delegate parseBlogloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
} 

#pragma mark - Customer Form
- (void)parseCustomer {
  PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query clearCachedResult];
  //[query setMaxCacheAge:60 * 4];  //4 mins cache
    [query setLimit:1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            _feedItems = [[NSMutableArray alloc]initWithArray:objects];
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
           // NSLog(@"Object id %@",_feedItems);
                if (self.delegate) {
                    [self.delegate parseCustomerloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Lead Form //not setup yet
- (void)parseLeads {
     PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [PFQuery clearAllCachedResults];
    [query orderByDescending:@"createdAt"];
     query.skip = 0;
    [query setLimit: 1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseLeadloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Vendor Form
- (void)parseVendor {
    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
    //[PFQuery clearAllCachedResults];
    [query orderByAscending:@"Vendor"];
    [query setLimit: 1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseVendorloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Employee Form
- (void)parseEmployee {
    PFQuery *query = [PFQuery queryWithClassName:@"Employee"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"createdAt"];
    [query setLimit: 100]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseEmployeeloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Advertiser Form 
- (void)parseAdvertiser {
    PFQuery *query = [PFQuery queryWithClassName:@"Advertising"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"Advertiser"];
    //[query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseAdvertiserloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Product Form
- (void)parseProduct {
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    //[PFQuery clearAllCachedResults];
    [query orderByAscending:@"Products"];
    [query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                if (self.delegate) {
                    [self.delegate parseProductloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Job Form
- (void)parseJob {
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"Description"];
    [query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                if (self.delegate) {
                    [self.delegate parseJobloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Salesman Form
- (void)parseSalesman {
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    //[PFQuery clearAllCachedResults];
    [query orderByAscending:@"Salesman"];
    //[query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
                if (self.delegate) {
                    [self.delegate parseSalesmanloaded:_feedItems];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

//-----------------Pickerview Parse data--------------------

#pragma mark - EditData PickerView
- (void)parseSalesPick {
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    //[query selectKeys:@[@"SalesNo"]];
    //[query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"SalesNo"];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseSalesPickloaded:salesArray];
        }
    }];
}

- (void)parseRatePick {
    PFQuery *query14 = [PFQuery queryWithClassName:@"Rate"];
    //[query14 selectKeys:@[@"rating"]];
    [query14 orderByDescending:@"rating"];
     query14.cachePolicy = kPFCACHEPOLICY;
    [query14 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        rateArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseRatePickloaded:rateArray];
        }
    }];
}

- (void)parseContractorPick {
    PFQuery *query13 = [PFQuery queryWithClassName:@"Contractor"];
    //[query13 selectKeys:@[@"Contractor"]];
    [query13 orderByDescending:@"Contractor"];
     query13.cachePolicy = kPFCACHEPOLICY;
    [query13 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        contractorArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseContractorPickloaded:contractorArray];
        }
    }];
}

- (void)parseCallbackPick {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
    //[query1 selectKeys:@[@"Callback"]];
    [query1 orderByDescending:@"Callback"];
     query1.cachePolicy = kPFCACHEPOLICY;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callbackArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseCallbackPickloaded:callbackArray];
        }
    }];
}

//-----------------Lookup Parse Data----------------------------------

#pragma mark - Lookup Form
- (void)parseLookupZip { //lookup city
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
    //[PFQuery clearAllCachedResults];
    //[query selectKeys:@[@"ZipNo"]];
    //[query selectKeys:@[@"City"]];
    //[query selectKeys:@[@"State"]];
    //[query selectKeys:@[@"zipCode"]];
    [query orderByAscending:@"City"];
    [query setLimit: 1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     _feedItems = [[NSMutableArray alloc]initWithArray:objects];
       // if (self.delegate) {
       //     [self.delegate parseLookupZiploaded:zipArray];
        if (!error) {
            for (PFObject *object in objects) {
                [_feedItems addObject:object];
            if (self.delegate) {
               [self.delegate parseLookupZiploaded:_feedItems];
               }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        
    }];
}

- (void)parseLookupJob { //lookup job
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    //[PFQuery clearAllCachedResults];
    //[query selectKeys:@[@"JobNo"]];
    //[query selectKeys:@[@"Description"]];
    [query orderByDescending:@"Description"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupJobloaded:_feedItems];
        }
    }];
}

- (void)parseLookupProduct { //lookup product
    PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
    //[PFQuery clearAllCachedResults];
    //[query3 selectKeys:@[@"ProductNo"]];
    //[query3 selectKeys:@[@"Products"]];
    [query3 orderByDescending:@"Products"];
     query3.cachePolicy = kPFCACHEPOLICY;
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupProductloaded:_feedItems];
        }
    }];
}

- (void)parseLookupAd { //lookup Advertiser
    PFQuery *query1 = [PFQuery queryWithClassName:@"Advertising"];
  //[PFQuery clearAllCachedResults];
    //[query1 selectKeys:@[@"AdNo"]];
    //[query1 selectKeys:@[@"Advertiser"]];
    [query1 orderByDescending:@"Advertiser"];
     query1.cachePolicy = kPFCACHEPOLICY;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupProductloaded:_feedItems];
        }
    }];
}

- (void)parseLookupSalesman { //lookup Salesman
    PFQuery *query1 = [PFQuery queryWithClassName:@"Salesman"];
    //[PFQuery clearAllCachedResults];
    //[query1 selectKeys:@[@"SalesNo"]];
    //[query1 selectKeys:@[@"Salesman"]];
    [query1 orderByDescending:@"Salesman"];
    query1.cachePolicy = kPFCACHEPOLICY;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _feedItems = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupSalesloaded:_feedItems];
        }
    }];
}

//-----------------TableHeader Data----------------------------------

- (void)parseHeadSalesman {
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadSalesmanloaded:headCount];
        }
    }];
}

- (void)parseHeadJob {
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    [query selectKeys:@[@"Description"]];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadJobloaded:headCount];
        }
    }];
}

- (void)parseHeadAd {
    PFQuery *query = [PFQuery queryWithClassName:@"Advertising"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadAdloaded:headCount];
        }
   }];
}

- (void)parseHeadProduct {
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadProductloaded:headCount];
        }
    }];
}

- (void)parseHeadEmployee {
    PFQuery *query = [PFQuery queryWithClassName:@"Employee"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadEmployeeloaded:headCount];
        }
    }];
}

- (void)parseHeadVendor {
    PFQuery *query = [PFQuery queryWithClassName:@"Vendors"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadVendorloaded:headCount];
        }
    }];
}

- (void)parseHeadLeads {
    PFQuery *query = [PFQuery queryWithClassName:@"Leads"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadLeadsloaded:headCount];
        }
    }];
}

- (void)parseHeadCustomer {
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [query selectKeys:@[@"Active"]];
    [query whereKey:@"Active" equalTo:@1];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadCustomerloaded:headCount];
        }
    }];
}

- (void)parseHeadBlog {
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [query selectKeys:@[@"Rating"]];
    [query whereKey:@"Rating" equalTo:@"5"];
    [query setLimit: 1000];
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        headCount = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseHeadBlogloaded:headCount];
        }
    }];
}


@end
