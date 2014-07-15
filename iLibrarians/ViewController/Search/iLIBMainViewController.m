//
//  iLIBMainViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBMainViewController.h"
#import "iLIBSearchResultViewController.h"

@interface iLIBMainViewController ()
@end

@implementation iLIBMainViewController

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
    //设置标题、背景颜色
    [self setTitle:@"图书馆"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    //设置navigationItem按钮
    UIImage *leftImage = [UIImage imageNamed:@"tabbar_personcenter.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    //设置搜索框
    self.searchTextField.placeholder            = @"书名/作者/ISBNS";
    self.searchTextField.textAlignment          = NSTextAlignmentCenter ;
    self.searchTextField.returnKeyType          = UIReturnKeySearch;
    self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.searchTextField.autocorrectionType     = UITextAutocorrectionTypeNo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//click the background to hide the keyboard
- (IBAction)backgroundTouchUpInside:(id)sender {
    [self.searchTextField resignFirstResponder];
}

#pragma mark - TextField Delegate

//click return to start search
- (IBAction)SearchTextFieldDidEndOnExit:(id)sender {
    [self.searchTextField resignFirstResponder];
    self.searchRequest                                         = self.searchTextField.text;
    iLIBSearchResultViewController *searchResultViewController = [[iLIBSearchResultViewController alloc] initWithNibName:@"iLIBSearchResultViewController" bundle:nil];
    searchResultViewController.searchString                    = self.searchRequest;
    //[searchResultViewController searchBookWithName:self.searchRequest];
    [searchResultViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchResultViewController animated:YES];
}

- (IBAction)SearchTextFieldEditBegin:(id)sender {
}

- (IBAction)SearchTextFieldEditEnd:(id)sender {
}

@end
