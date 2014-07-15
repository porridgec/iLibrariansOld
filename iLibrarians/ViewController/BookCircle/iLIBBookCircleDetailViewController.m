//
//  iLIBBookCircleDetailViewController.m
//  iLibrarians
//
//  Created by Alaysh on 12/21/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBBookCircleDetailViewController.h"
#import "iLIBBookCircleItem.h"
#import "iLIBBookCircleCell.h"
#import "iLIBDefaultView.h"

#define textFieldBackgroundColor [UIColor colorWithRed:0.4784 green:0.9255 blue:0.7098 alpha:1.0]

@interface iLIBBookCircleDetailViewController ()
{
    iLIBDefaultView *_defaultView;
}

@property(nonatomic,strong)iLIBEngine *iLibEngine;
@property(nonatomic,strong)NSArray *bookCircleMessagesArray;
@end

@implementation iLIBBookCircleDetailViewController

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
    //设置navigationItem按钮
    UIImage *leftImage = [UIImage imageNamed:@"return.png"];
    UIImage *rightImage = [UIImage imageNamed:@"add.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [leftButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    //设置textField背景颜色
    _textFieldBackgroundView.backgroundColor = textFieldBackgroundColor;
    _tableView.delegate = (id)self;
    _tableView.dataSource = (id)self;
    _tableView.tableHeaderView = _circleIntroductionView;
    
    _defaultView = [[iLIBDefaultView alloc] initWithFrame:_tableView.frame];
    [_defaultView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-40)];
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    _bookCircleMessagesArray = [[NSArray alloc] init];
    [_circleIntroductionView setFrame:CGRectMake(0, 0, 320, 100)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self setTitle:_iLibBookCircleItem.itemName];
    _circleIntroductionLabel.text = _iLibBookCircleItem.itemIntroduction;
    [_iLibEngine getBookCircleMessageWithId:_iLibBookCircleItem.itemId page:1 onSuccess:^(NSArray *bookArray) {
        _bookCircleMessagesArray = bookArray;
        if (_bookCircleMessagesArray.count == 0) {
            [self.view addSubview:_defaultView];
        }
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self performSelector:@selector(textFieldDidEndEditing:) withObject:nil];
    [_iLibEngine cancelAllOperations];
    [_textField resignFirstResponder];
    _textField.text = @"";
    if ([_defaultView superview] == self.view) {
        [_defaultView removeFromSuperview];
    }
}

- (IBAction)publishMessage:(id)sender
{
    [self performSelector:@selector(textFieldDidEndEditing:) withObject:nil];
    #warning did't complish
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float  offset = -250; //view向上移动的距离
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    self.view.frame = rect;
    [UIView  commitAnimations];
}

- (IBAction)textFieldDidEndEditing:(id)sender
{
    [_textField resignFirstResponder];
    float offset = 0.0;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    CGRect rect = CGRectMake(0.0f, offset , width, height);
    self.view.frame = rect;
    [UIView commitAnimations];
}

#pragma TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_bookCircleMessagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iLIBBookCircleCell";
    iLIBBookCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil]lastObject];
    }
    [cell configureForCell:[_bookCircleMessagesArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 179;
}

@end
