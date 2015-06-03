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
    NSMutableArray *salesArray, *callbackArray, *contractorArray, *rateArray, *zipArray, *jobArray, *adproductArray, *headCount, *BlogArray, *custArray, *leadArray, *vendorArray, *employArray, *adArray, *prodArray, *saleArray;
}
@end

@implementation ParseConnection

//------------------Table Data----------------------------------
#pragma mark - Blog Form
- (void)parseBlog {
    PFQuery *query = [PFQuery queryWithClassName:@"Blog"];
    [PFQuery clearAllCachedResults];
    /*  [query selectKeys:@[@"objectId"]];
     [query selectKeys:@[@"MsgNo"]];
     [query selectKeys:@[@"MsgDate"]];
     [query selectKeys:@[@"PostBy"]];
     [query selectKeys:@[@"Rating"]];
     [query selectKeys:@[@"Subject"]];  */
    [query orderByDescending:@"createdAt"];
    [query setLimit: 1000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        BlogArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [BlogArray addObject:object];
                // NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseBlogloaded:BlogArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Customer Form
- (void)parseCustomer {
    PFQuery *query = [PFQuery queryWithClassName:@"Customer"];
    [PFQuery clearAllCachedResults];
    [query orderByDescending:@"createdAt"];
    [query setLimit: 5000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        custArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [custArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseCustomerloaded:custArray];
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
    [query setLimit: 10000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        leadArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [leadArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseLeadloaded:leadArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Vendor Form //not setup yet
- (void)parseVendor {
    PFQuery *query = [PFQuery queryWithClassName:@"Vendor"];
    [PFQuery clearAllCachedResults];
    [query orderByDescending:@"createdAt"];
    //[query setLimit: 10000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        vendorArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [vendorArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseVendorloaded:vendorArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Employee Form //not setup yet
- (void)parseEmployee {
    PFQuery *query = [PFQuery queryWithClassName:@"Employee"];
    [PFQuery clearAllCachedResults];
    [query orderByDescending:@"createdAt"];
    //[query setLimit: 10000]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        employArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [employArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseEmployloaded:employArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Advertiser Form //not setup yet
- (void)parseAdvertiser {
    PFQuery *query = [PFQuery queryWithClassName:@"Advertising"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"Advertiser"];
    //[query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [adArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseAdvertiserloaded:adArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Product Form
- (void)parseProduct {
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"Products"];
    [query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        prodArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [prodArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseProductloaded:prodArray];
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
        jobArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [jobArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseJobloaded:jobArray];
                }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

#pragma mark - Salesman Form
- (void)parseSalesman {
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    [PFQuery clearAllCachedResults];
    [query orderByAscending:@"Salesman"];
    //[query setLimit: 500]; //parse.com standard is 100
    query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        saleArray = [[NSMutableArray alloc]initWithArray:objects];
        if (!error) {
            for (PFObject *object in objects) {
                [saleArray addObject:object];
                //NSLog(@"Object id %@",[object objectId]);
                if (self.delegate) {
                    [self.delegate parseSalesmanloaded:saleArray];
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
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"SalesNo"];
    [query whereKey:@"Active" containsString:@"Active"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseSalesmanloaded:salesArray];
        }
    }];
}

- (void)parseRate {
    PFQuery *query14 = [PFQuery queryWithClassName:@"Rate"];
    [query14 selectKeys:@[@"rating"]];
    [query14 orderByDescending:@"rating"];
     query14.cachePolicy = kPFCACHEPOLICY;
    [query14 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        rateArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseRateloaded:rateArray];
        }
    }];
}

- (void)parseContractor {
    PFQuery *query13 = [PFQuery queryWithClassName:@"Contractor"];
    [query13 selectKeys:@[@"Contractor"]];
    [query13 orderByDescending:@"Contractor"];
     query13.cachePolicy = kPFCACHEPOLICY;
    [query13 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        contractorArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseContractorloaded:contractorArray];
        }
    }];
}

- (void)parseCallback {
    PFQuery *query1 = [PFQuery queryWithClassName:@"Callback"];
    [query1 selectKeys:@[@"Callback"]];
    [query1 orderByDescending:@"Callback"];
     query1.cachePolicy = kPFCACHEPOLICY;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        callbackArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseCallbackloaded:callbackArray];
        }
    }];
}

//-----------------Lookup Parse Data----------------------------------

#pragma mark - Lookup Form
- (void)parseLookupZip { //lookup city
    PFQuery *query = [PFQuery queryWithClassName:@"Zip"];
    [PFQuery clearAllCachedResults];
    //[query selectKeys:@[@"ZipNo"]];
    [query selectKeys:@[@"City"]];
    [query selectKeys:@[@"State"]];
    [query selectKeys:@[@"zipCode"]];
    [query orderByAscending:@"City"];
    [query setLimit: 1000]; //parse.com standard is 100
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     zipArray = [[NSMutableArray alloc]initWithArray:objects];
    /*    if (self.delegate) {
            [self.delegate parseLookupZiploaded:zipArray]; */
        if (!error) {
            for (PFObject *object in objects) {
                [zipArray addObject:object];
            if (self.delegate) {
               [self.delegate parseLookupZiploaded:zipArray];
               }
            }
        } else
            NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

- (void)parseLookupJob { //lookup job
    PFQuery *query = [PFQuery queryWithClassName:@"Job"];
    [PFQuery clearAllCachedResults];
    [query selectKeys:@[@"JobNo"]];
    [query selectKeys:@[@"Description"]];
    [query orderByDescending:@"Description"];
    //[query whereKey:@"Active" containsString:QACTIVE];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        jobArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupJobloaded:jobArray];
        }
    }];
}

- (void)parseLookupProduct { //lookup product
    PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
    [PFQuery clearAllCachedResults];
    [query3 selectKeys:@[@"ProductNo"]];
    [query3 selectKeys:@[@"Products"]];
    [query3 orderByDescending:@"Products"];
    //[query3 whereKey:@"Active" containsString:QACTIVE];
     query3.cachePolicy = kPFCACHEPOLICY;
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adproductArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupProductloaded:adproductArray];
        }
    }];
}

- (void)parseLookupAd { //lookup Advertiser
    PFQuery *query1 = [PFQuery queryWithClassName:@"Advertising"];
  //[PFQuery clearAllCachedResults];
    [query1 selectKeys:@[@"AdNo"]];
    [query1 selectKeys:@[@"Advertiser"]];
    [query1 orderByDescending:@"Advertiser"];
    //[query1 whereKey:@"Active" containsString:QACTIVE];
     query1.cachePolicy = kPFCACHEPOLICY;
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        adproductArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupProductloaded:adproductArray];
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

/*
- (void)parseLookupSalesman { //lookup Salesman
    PFQuery *query = [PFQuery queryWithClassName:@"Salesman"];
    //[PFQuery clearAllCachedResults];
    [query selectKeys:@[@"SalesNo"]];
    [query selectKeys:@[@"Salesman"]];
    [query orderByDescending:@"Salesman"];
     query.cachePolicy = kPFCACHEPOLICY;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        salesArray = [[NSMutableArray alloc]initWithArray:objects];
        if (self.delegate) {
            [self.delegate parseLookupSalesmanloaded:salesArray];
        }
    }];
} */

/*
- (void)parseJob {
    PFQuery *query21 = [PFQuery queryWithClassName:@"Job"];
    query21.cachePolicy = kPFCACHEPOLICY;
    [query21 whereKey:@"JobNo" equalTo:self.frm22];
    [query21 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.jobName.text = [object objectForKey:@"Description"];
    }];
}

- (void)parseProduct {
    PFQuery *query3 = [PFQuery queryWithClassName:@"Product"];
    query3.cachePolicy = kPFCACHEPOLICY;
    [query3 whereKey:@"ProductNo" containsString:self.frm23];
    [query3 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.adName.text = [object objectForKey:@"Products"];
    }];
   
}

- (void)parseAd {
    PFQuery *query11 = [PFQuery queryWithClassName:@"Advertising"];
    query11.cachePolicy = kPFCACHEPOLICY;
    [query11 whereKey:@"AdNo" equalTo:self.frm23];
    [query11 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else
            self.adName.text = [object objectForKey:@"Advertiser"];
    }];
} */


@end
