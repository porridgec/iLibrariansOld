//
//  iLIBPublishFloatBookViewController.m
//  iLibrarians
//
//  Created by Alaysh on 11/29/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBPublishFloatBookViewController.h"
#import "iLIBFloatBookItem.h"

@interface iLIBPublishFloatBookViewController ()

@property(nonatomic,strong)iLIBEngine *iLibEngine;
@property(nonatomic,strong)iLIBFloatBookItem *book;

@end

@implementation iLIBPublishFloatBookViewController

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
    [self setTitle:@"发布消息"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    _contentTextView.backgroundColor = [UIColor whiteColor];
    _contentTextView.alpha = 1.0;
    _contentTextView.layer.cornerRadius = 5.0;
    
    _book = [[iLIBFloatBookItem alloc] init];
    
    UIImage *returnImage = [UIImage imageNamed:@"return.png"];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [returnButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    [self.navigationItem setLeftBarButtonItem:returnButtonItem];
    
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iLibEngine cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TextView Delegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)resignFirstResponder:(id)sender
{
    [_bookNameLabel resignFirstResponder];
    [_bookAuthorLabel resignFirstResponder];
    [_contentTextView resignFirstResponder];
}

#pragma mark - Publish FloatBook Selector

- (IBAction)publishIdleBook:(id)sender
{
    _book.type = 0;
    [self performSelector:@selector(publishFloatBook) withObject:nil];
}

- (IBAction)publishBegBook:(id)sender
{
    _book.type = 1;
    [self performSelector:@selector(publishFloatBook) withObject:nil];
}

- (void)publishFloatBook
{
    [_contentTextView resignFirstResponder];
    _book.booktitle = _bookNameLabel.text;
    _book.bookAuthor = _bookAuthorLabel.text;
    _book.content = _contentTextView.text;
    _book.userId = _iLibEngine.studentId;
    _book.userName = _iLibEngine.studentName;
    [_iLibEngine publishFloatBooks:self.book onSuccess:^{
            [UIAlertView showWithText:@"发布消息成功"];
            _bookAuthorLabel.text = @"";
            _bookNameLabel.text = @"";
            _contentTextView.text = @"";
            NSLog(@"发布消息成功");
        } onError:^(NSError *engineError) {
            [UIAlertView showWithTitle:@"发布消息失败" message:@"请检查你的网络设置"];
            NSLog(@"发布消息失败");
        }];
}

@end
