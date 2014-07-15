//
//  iLIBBorrowedBookDetailViewController.m
//  iLibrarians
//
//  Created by Alaysh on 11/15/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBBorrowedBookDetailViewController.h"
#import "iLIBBookItem.h"
#include "NSDate+RFC1123.h"
#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"

@interface iLIBBorrowedBookDetailViewController ()

@end

@implementation iLIBBorrowedBookDetailViewController

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
    [self.navigationItem setTitle:@"续借"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    UIImage *returnImage = [UIImage imageNamed:@"return.png"];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [returnButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    [self.navigationItem setLeftBarButtonItem:returnButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initWithBookItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iLibEngine cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup View

- (void)initWithBookItem
{
    _bookNameLabel.text = _bookItem.title;
    _bookBarcodeLabel.text = _bookItem.barcode;
    _authorLabel.text = _bookItem.author;
    _dueDateLabel.text = [_bookItem.dueDate stringWithDateFormat:@"应于yyyy年MM月dd日归还"];
    NSTimeInterval remainderTimeInterval = [[_bookItem dueDate] timeIntervalSinceDate:[NSDate date]];
    if (remainderTimeInterval > 0) {
        NSTimeInterval secondsOfADay = 24 * 60 * 60;
        NSInteger remainderDays = remainderTimeInterval / secondsOfADay;
        _daysLeftLabel.text = [NSString stringWithFormat:@"还剩%d天", remainderDays];
    } else {
        _daysLeftLabel.text = @"过期啦！";
    }
    _bookPressLabel.text = _bookItem.press;
}
@end
