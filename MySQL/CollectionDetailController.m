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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.title = NSLocalizedString(@"Check out my jobs!", nil);
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.backgroundColor = BACKGROUNDCOLOR;
    self.jobImageView.image = self.image;
    self.jobImageView.backgroundColor = [UIColor blackColor];
    self.jobImageView.contentMode = UIViewContentModeScaleAspectFit;

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.scrollView = nil;
    self.jobImageView.image = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.jobImageView;
}

@end
