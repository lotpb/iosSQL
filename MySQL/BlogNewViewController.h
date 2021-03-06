//
//  BlogNewViewController.h
//  MySQL
//
//  Created by Peter Balsamo on 10/19/14.
//  Copyright (c) 2014 Peter Balsamo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BlogModel.h"
#import "BlogViewController.h"

@interface BlogNewViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *formStatus;

@property (strong, nonatomic) NSString *textcontentobjectId;
@property (strong, nonatomic) NSString *textcontentmsgNo;
@property (strong, nonatomic) NSString *textcontentdate;
@property (strong, nonatomic) NSString *textcontentpostby;
@property (strong, nonatomic) NSString *textcontentsubject;
@property (strong, nonatomic) NSString *textcontentrating;

@property (strong, nonatomic) NSString *objectId;//Parse
@property (strong, nonatomic) NSString *msgNo;
@property (strong, nonatomic) NSString *msgDate;
@property (strong, nonatomic) NSString *postby;
@property (strong, nonatomic) NSString *rating;
@property (strong, nonatomic) NSString *replyId;

@property (weak, nonatomic) IBOutlet UIButton *Share;
@property (weak, nonatomic) IBOutlet UIButton *Update;
@property (weak, nonatomic) IBOutlet UIButton *Like;

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) UIImageView *activeImage;//star button
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UITextView *subject;
@property (weak, nonatomic) IBOutlet UIImageView *imageBlog;
@property (weak, nonatomic) IBOutlet UILabel *placeholderlabel;

@end
