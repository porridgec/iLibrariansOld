//
//  iLIBPublishCommentViewController.m
//  iLibrarians
//
//  Created by Alaysh on 12/17/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBPublishCommentViewController.h"
#import "iLIBComment.h"

@interface iLIBPublishCommentViewController ()

@property (nonatomic,strong) iLIBEngine *iLibEngine;

@end

@implementation iLIBPublishCommentViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.alpha = 1.0;
    _textView.layer.cornerRadius = 5.0;
    _textView.returnKeyType = UIReturnKeySend;
    
    //设置navigationItem按钮
    
    UIImage *returnImage = [UIImage imageNamed:@"return.png"];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [returnButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    [self.navigationItem setLeftBarButtonItem:returnButtonItem];
    
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([textView.text  isEqual: @""]) {
            [UIAlertView showWithTitle:@"评论失败" message:@"请输入你的评论内容"];
        }
        else{
            [self performSelector:@selector(publishComment) withObject:nil];
        }
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

#pragma mark - Publish FloatBook Selector

- (void)publishComment
{
    [_textView resignFirstResponder];
    _comment.content = [NSString stringWithFormat:@"%@%@",_comment.content,_textView.text];
    [_iLibEngine writeCommentWithId:_comment onSucceeded:^{
        [UIAlertView showWithText:@"评论成功"];
        _comment.content = @"";
        _textView.text = @"";
        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithTitle:@"评论失败" message:@"请检查你的网络设置"];
        //[UIAlertView showWithText:@"评论失败"];
    }];
}
@end
