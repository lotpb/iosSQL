//
//  CollectionDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 12/25/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import "CollectionDetailController.h"


@interface CollectionDetailController ()

@end

@implementation CollectionDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jobImageView.image = [UIImage imageNamed:self.jobImageName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
