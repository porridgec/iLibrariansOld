//
//  iLIBBookFloatDetailViewController.m
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBBookFloatDetailViewController.h"
#import "iLIBPublishCommentViewController.h"
#import "ArrayDataSource.h"
#import "iLIBFloatBookItem.h"
#import "iLIBComment.h"
#import "iLIBBookFloatCell.h"
#import "iLIBCommentCell.h"
#import "iLIBBookFloatDetailCell.h"
#import "NSDate+RFC1123.h"
#import "MJRefresh.h"

#define MAX_HEIGHT 500
#define contentFont [UIFont systemFontOfSize:13]
#define textFieldBackgroundColor [UIColor colorWithRed:0.4784 green:0.9255 blue:0.7098 alpha:1.0]

@interface iLIBBookFloatDetailViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property(nonatomic,assign) int pageCount;
@property(nonatomic,strong) iLIBEngine *iLibEngine;
@property(nonatomic,strong) ArrayDataSource *commentDataSource;
@property(nonatomic,strong) iLIBPublishCommentViewController *iLibPublishCommentViewController;
@property(nonatomic,strong) iLIBComment *comment;
@property(nonatomic,strong) NSMutableArray *commentArray;
@end

@implementation iLIBBookFloatDetailViewController

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
    self.title = @"评论";
    
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    
    //设置navigationItem按钮
    
    UIImage *returnImage = [UIImage imageNamed:@"return.png"];
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [returnButton setBackgroundImage:returnImage forState:UIControlStateNormal];
    [returnButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    [self.navigationItem setLeftBarButtonItem:returnButtonItem];
    
    _textFieldBackgroundView.backgroundColor = textFieldBackgroundColor;
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = (id)self;
    _header.scrollView = _tableView;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = (id)self;
    _footer.scrollView = _tableView;
    _pageCount = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:YES];
    [self performSelector:@selector(refresh) withObject:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [_iLibEngine cancelAllOperations];
    [_textField resignFirstResponder];
    _textField.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        iLIBBookFloatDetailCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"iLIBBookFloatDetailCell" owner:nil options:nil]lastObject];
        [cell configureForCell:_book];
        cell.countLabel.text = [NSString stringWithFormat:@"评论 :%d",_commentArray.count];
        return cell;
    }
    
    static NSString *CellIdentifier = @"iLIBCommentCell";
    iLIBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil]lastObject];
    }
    [cell configureForCell:[_commentArray objectAtIndex:indexPath.row-1]];
    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CGRect rect = [_book.content boundingRectWithSize:CGSizeMake(278, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:contentFont}
                                                     context:nil];
        return 50 + (rect.size.height>80?rect.size.height:80);
    }
    iLIBComment* comment = [_commentArray objectAtIndex:indexPath.row-1];
    CGRect rect = [comment.content boundingRectWithSize:CGSizeMake(232, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:contentFont}
                                              context:nil];
    return 40+rect.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_iLibPublishCommentViewController == nil) {
        _iLibPublishCommentViewController = [[iLIBPublishCommentViewController alloc] initWithNibName:@"iLIBPublishCommentViewController" bundle:nil];
    }
    if (_comment == nil) {
        _comment = [[iLIBComment alloc] init];
    }
    
    iLIBComment *comment = [_commentArray objectAtIndex:indexPath.row-1];
    _comment.userId = comment.replyId;
    _comment.userName = comment.replyName;
    _comment.replyId = _iLibEngine.studentId;
    _comment.replyName = _iLibEngine.studentName;
    _comment.resId = comment.resId;
    _comment.content = [NSString stringWithFormat:@"回复%@:",comment.replyName];
    [_iLibPublishCommentViewController setComment:_comment];
    [self.navigationController pushViewController:_iLibPublishCommentViewController animated:YES];
}

#pragma mark - Refresh View Delegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self performSelector:@selector(refresh) withObject:nil];
        NSLog(@"刷新");
    }
    else {
        NSLog(@"加载更多");
        _pageCount ++;
        NSLog(@"pageCount:%d",_pageCount);
        [self.iLibEngine getCommentWithId:self.book.resId page:_pageCount onSucceeded:^(NSArray *bookArray) {
            [_commentArray addObjectsFromArray:bookArray];
        } onError:^(NSError *engineError) {
            NSLog(@"Get Comments Error");
        }];
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
}

- (void)reloadTableView
{
    [_tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];
}

#pragma mark - Selector

- (IBAction)publishComment:(id)sender
{
    [self performSelector:@selector(textFieldDidEndEditing:) withObject:nil];
    if (_comment == nil) {
        _comment = [[iLIBComment alloc] init];
    }
    _comment.userId = _book.userId;
    _comment.userName = _book.userName;
    _comment.replyId = _iLibEngine.studentId;
    _comment.replyName = _iLibEngine.studentName;
    _comment.resId = _book.resId;
    _comment.content = _textField.text;
    [_iLibEngine writeCommentWithId:_comment onSucceeded:^{
        [UIAlertView showWithText:@"评论成功"];
        _comment.content = @"";
        _textField.text = @"";
        [self performSelector:@selector(refresh) withObject:nil];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithTitle:@"评论失败" message:@"请检查你的网络设置"];
    }];
}

- (void)refresh
{
    _pageCount = 1;
    [self.iLibEngine getCommentWithId:self.book.resId page:_pageCount onSucceeded:^(NSArray *bookArray) {
        _commentArray = (id)bookArray;
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        NSLog(@"Get Comments Error");
    }];
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

@end
