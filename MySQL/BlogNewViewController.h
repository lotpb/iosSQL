//
//  BlogNewViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/19/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogViewController.h"
#import "BlogModel.h"

@interface BlogNewViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *msgNo;
@property (strong, nonatomic) NSString *msgDate;
@property (strong, nonatomic) NSString *postby;
@property (strong, nonatomic) NSString *rating;

@property (weak, nonatomic) IBOutlet UITextView *subject;
@property (weak, nonatomic) IBOutlet UIButton *Share;
@property (weak, nonatomic) IBOutlet UIButton *Reply;
@property (weak, nonatomic) IBOutlet UIButton *Like;

@property (strong, nonatomic) NSString *textcontentmsgNo;
@property (strong, nonatomic) NSString *textcontentdate;
@property (strong, nonatomic) NSString *textcontentpostby;
@property (strong, nonatomic) NSString *textcontentsubject;
@property (strong, nonatomic) NSString *textcontentrating;

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end
