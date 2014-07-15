//
//  iLIBMyLibViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//
#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBMyLibViewController.h"
#import "iLIBBorrowedBookDetailViewController.h"
#import "iLIBMainViewController.h"
#import "MJRefresh.h"
#import "ArrayDataSource.h"
#import "iLIBBookItem.h"
#import "iLIBBorrowedBooksCell.h"

@interface iLIBMyLibViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    iLIBMainViewController *_iLibMainViewController;
    iLIBBorrowedBookDetailViewController *_iLibBorrowedBookDetailViewController;
    iLIBEngine *_iLibEngine;
    ArrayDataSource* _bookArrayDataSource;
    NSArray *_borrowedBooks;
}

@end

@implementation iLIBMyLibViewController

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
    [self setTitle:@"我的书架"];
    //设置Segment
    [_myLibSegment setTitle:@"借阅查询" forSegmentAtIndex:0];
    [_myLibSegment setTitle:@"图书荐购" forSegmentAtIndex:1];
    [_myLibSegment insertSegmentWithTitle:@"个人信息" atIndex:2 animated:NO];
    [_recommendedBooksTableView setHidden:YES];
    [_personalInformationTableView setHidden:YES];
    //设置下拉、上拉列表
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = (id)self;
    _header.scrollView = _borrowedBooksTableView;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = (id)self;
    _footer.scrollView = _borrowedBooksTableView;
    //设置navigationItem
    UIImage *leftImage = [UIImage imageNamed:@"return.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    //设置tableView
    [self setupTableView];
    _iLibMainViewController = [[iLIBMainViewController alloc] initWithNibName:@"iLIBMainViewController" bundle:nil];
    _iLibBorrowedBookDetailViewController = [[iLIBBorrowedBookDetailViewController alloc] initWithNibName:@"iLIBBorrowedBookDetailViewController" bundle:nil];
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    [self.navigationController pushViewController:_iLibMainViewController animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_iLibEngine requestLoanBooks:^(NSArray *bookArray) {
        _borrowedBooks = [NSArray arrayWithArray:bookArray];
        _bookArrayDataSource.items = _borrowedBooks;
        [_borrowedBooksTableView reloadData];
    } onError:^(NSError *engineError) {
        NSLog(@"Request borrowedBooks error");
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iLibEngine cancelAllOperations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View Data Source

- (void)setupTableView
{
    TableViewConfigureBlock configureBlock = ^(iLIBBorrowedBooksCell *cell,iLIBBookItem *bookItem)
    {
        [cell configureForCell:bookItem];
    };
    _bookArrayDataSource = [[ArrayDataSource alloc] initWithItems:_borrowedBooks cellIndetifier:@"iLIBBorrowedBooksCell" configureCellBlock:configureBlock];
    _borrowedBooksTableView.delegate = self;
    _borrowedBooksTableView.dataSource = _bookArrayDataSource;
    [_borrowedBooksTableView reloadData];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    iLIBBookItem *book = [_borrowedBooks objectAtIndex:indexPath.row];
    [_iLibEngine useCache];
    [_iLibEngine imageAtURL:[NSURL URLWithString:book.cover] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        _iLibBorrowedBookDetailViewController.coverView.image = fetchedImage;
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [UIAlertView showWithError:error];
    }];
    [_iLibBorrowedBookDetailViewController setBookItem:book];
    [self.navigationController pushViewController:_iLibBorrowedBookDetailViewController animated:YES];
}

#pragma mark - Segment Delegate

- (IBAction)myLibSegmentValueChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            [_borrowedBooksTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            [_borrowedBooksTableView setHidden:NO];
            [_recommendedBooksTableView setHidden:YES];
            [_personalInformationTableView setHidden:YES];
            break;
        case 1:
            [_recommendedBooksTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            [_recommendedBooksTableView setHidden:NO];
            [_borrowedBooksTableView setHidden:YES];
            [_personalInformationTableView setHidden:YES];
            break;
        case 2:
            [_personalInformationTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
            [_personalInformationTableView setHidden:NO];
            [_borrowedBooksTableView setHidden:YES];
            [_recommendedBooksTableView setHidden:YES];
        default:
            break;
    }
}

#pragma mark - Refresh View Delegate

- (void)refreshBorrowedBooksTableView
{
    [_iLibEngine requestLoanBooks:^(NSArray *bookArray) {
        _borrowedBooks = [NSArray arrayWithArray:bookArray];
        _bookArrayDataSource.items = _borrowedBooks;
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        [self performSelector:@selector(refreshBorrowedBooksTableView) withObject:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadBorrowedBooksTableView) userInfo:nil repeats:NO];
        NSLog(@"刷新");
    } else {
        //[UIAlertView showWithText:@"加载更多"];
    }
    
    
}

- (void)reloadBorrowedBooksTableView
{
    [_borrowedBooksTableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];
}

#pragma mark - mySelector

- (void)pushViewController
{
    [self.navigationController pushViewController:_iLibMainViewController animated:YES];
}

@end