//
//  iLIBBookFloatViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBBookFloatViewController.h"
#import "iLIBBookFloatDetailViewController.h"
#import "iLIBPublishFloatBookViewController.h"
#import "ArrayDataSource.h"
#import "iLIBFloatBookItem.h"
#import "iLIBComment.h"
#import "iLIBBookFloatCell.h"
#import "MJRefresh.h"

#define cellBackGroundColor [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]
#define segmentedControlColor [UIColor colorWithRed:0.4784 green:0.9255 blue:0.7098 alpha:1.0]

@interface iLIBBookFloatViewController ()
{
    MJRefreshFooterView *_footer;
}

@property(nonatomic,assign) int pageCount;
@property(nonatomic,strong) NSMutableArray *booksArray;
@property(nonatomic,strong) ArrayDataSource *booksDataSource;
@property(nonatomic,strong) iLIBEngine *iLibEngine;
@property(nonatomic,strong) iLIBPublishFloatBookViewController *iLibPublishFloatBookViewController;
@property(nonatomic,strong) iLIBBookFloatDetailViewController *iLibBookFloatDetailViewController;

@end

@implementation iLIBBookFloatViewController

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
    [self setTitle:@"漂流区"];
    
    _segmentControl.tintColor = segmentedControlColor;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = (id)self;
    _footer.scrollView = self.tableView;
    _pageCount = 1;
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入你想要找的书籍名称";
    _searchBar.barTintColor = segmentedControlColor;
    self.tableView.tableHeaderView = _searchBar;
    CGRect newBounds = self.tableView.bounds;
    newBounds.origin.y = newBounds.origin.y + _searchBar.bounds.size.height;
    _tableView.bounds = newBounds;
    
    //设置navigationItem按钮
    
    UIImage *rightImage = [UIImage imageNamed:@"add.png"];
    UIImage *leftImage = [UIImage imageNamed:@"refresh.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(publishFloatBook:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    _iLibBookFloatDetailViewController = [[iLIBBookFloatDetailViewController alloc] initWithNibName:@"iLIBBookFloatDetailViewController" bundle:nil];
    _iLibPublishFloatBookViewController = [[iLIBPublishFloatBookViewController alloc] initWithNibName:@"iLIBPublishFloatBookViewController" bundle:nil];
    
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    [_iLibEngine getFloatBooksWithType:@"0" page:_pageCount onSuccess:^(NSArray *bookArray) {
        _booksArray = (id)bookArray;
        [self setupTableView];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithText:@"获取漂流图书数据失败，请重试"];
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

#pragma mark - Table view data source

- (void)setupTableView
{
    TableViewConfigureBlock configureBlock = ^(iLIBBookFloatCell *cell,iLIBFloatBookItem *bookItem)
    {
        [cell configureForCell:bookItem];
    };
    _booksDataSource = [[ArrayDataSource alloc] initWithItems:_booksArray cellIndetifier:@"iLIBBookFloatCell" configureCellBlock:configureBlock];
    _booksDataSource.items = _booksArray;
    _tableView.delegate = (id)self;
    _tableView.dataSource = _booksDataSource;
    [_tableView reloadData];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_iLibBookFloatDetailViewController setBook:[_booksArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_iLibBookFloatDetailViewController animated:YES];
}

#pragma mark - Refresh View delegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    NSLog(@"加载更多");
    _pageCount ++;
    NSLog(@"pageCount:%d",_pageCount);
    [_iLibEngine getFloatBooksWithType:[NSString stringWithFormat:@"%d",_segmentControl.selectedSegmentIndex] page:_pageCount onSuccess:^(NSArray *bookArray) {
        NSLog(@"count:%d",bookArray.count);
        [_booksArray addObjectsFromArray:bookArray];
        _booksDataSource.items = _booksArray;
        [_footer endRefreshing];
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        [_footer endRefreshing];
        [UIAlertView showWithTitle:@"获取漂流图书数据错误" message:@"请检查你的网络设置"];
    }];
}

#pragma mark - Searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Find :%@",searchBar.text);
    [_searchBar resignFirstResponder];// 放弃第一响应者
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [_iLibEngine searchFloatBooksWithText:searchBar.text onSuccess:^(NSArray *bookArray) {
        _booksArray = (id)bookArray;
        _booksDataSource.items = self.booksArray;
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithText:@"搜索漂流图书数据错误，请重试"];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - mySelector

- (IBAction)publishFloatBook:(id)sender;
{
    [self.navigationController pushViewController:_iLibPublishFloatBookViewController animated:YES];
}

- (IBAction)refresh:(id)sender
{
    _pageCount = 1;
    [_iLibEngine getFloatBooksWithType:[NSString stringWithFormat:@"%d",_segmentControl.selectedSegmentIndex] page:_pageCount onSuccess:^(NSArray *bookArray) {
        _booksArray = (id)bookArray;
        _booksDataSource.items = self.booksArray;
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithText:@"获取漂流图书数据失败，请重试"];
    }];
}


#pragma mark - Segment Delegate

- (IBAction)mySegmentValueChanged:(id)sender {
    _pageCount = 1;
    [_iLibEngine getFloatBooksWithType:[NSString stringWithFormat:@"%d",_segmentControl.selectedSegmentIndex] page:_pageCount onSuccess:^(NSArray *bookArray) {
        _booksArray = (id)bookArray;
        _booksDataSource.items = self.booksArray;
        [_tableView reloadData];
    } onError:^(NSError *engineError) {
        [UIAlertView showWithText:@"获取漂流图书数据失败，请重试"];
    }];
}

@end