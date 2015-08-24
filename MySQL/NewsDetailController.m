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
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:NEWSNAVLOGO]];
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 6.0;
     self.newsImageview.backgroundColor = BACKGROUNDCOLOR;
    
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.newsImageview.contentMode = UIViewContentModeScaleToFill;
        self.titleLabel.font = DETAILFONT(IPADFONT26);
        self.detailLabel.font = DETAILFONT(IPADFONT16);
        self.newsTextview.font = CELL_LIGHTFONT(IPADFONT18);
    } else {
        self.titleLabel.font = DETAILFONT(IPHONEFONT20);
        self.detailLabel.font = DETAILFONT(IPHONEFONT14);
        self.newsTextview.font = CELL_LIGHTFONT(IPHONEFONT16);
    }
    
    self.newsImageview.image = self.image;
    self.titleLabel.text = self.newsTitle;
    self.titleLabel.numberOfLines = 2;
    
    self.detailLabel.text = self.newsDetail;
    self.detailLabel.textColor = [UIColor lightGrayColor];
    [self.detailLabel sizeToFit];
    
    self.newsTextview.text = textviewText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    return self.newsImageview;
}


@end
