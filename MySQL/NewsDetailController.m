//
//  NewsDetailController.m
//  MySQL
//
//  Created by Peter Balsamo on 8/20/15.
//  Copyright © 2015 Peter Balsamo. All rights reserved.
//

#import "NewsDetailController.h"

@interface NewsDetailController ()

@end

@implementation NewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone; //fix
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.newsImageview.image = self.image;
    self.titleLabel.text = self.newsTitle;
    self.titleLabel.font = DETAILFONT(IPHONEFONT20);
    self.titleLabel.numberOfLines = 2;
    //[self.titleLabel sizeToFit];
    
    self.detailLabel.text = self.newsDetail;
    self.detailLabel.font = DETAILFONT(IPHONEFONT14);
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.newsImageview;
}


@end
