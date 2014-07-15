//
//  iLIBBookCircleViewController.m
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//
#import "iLIBAppDelegate.h"
#import "iLIBBookCircleViewController.h"
#import "iLIBSquareViewController.h"
#import "iLIBEngine.h"
#import "iLIBBookCircleCell.h"
#import "MJRefresh.h"
#import "UIImage+EllipseImage.h"
#import "iLIBDefaultView.h"

#define backGroundColor [UIColor colorWithRed:0.9569 green:0.9569 blue:0.9569 alpha:1.0]
#define iLibGreenColor [UIColor colorWithRed:0.4784 green:0.9255 blue:0.7098 alpha:1.0]

@interface iLIBBookCircleViewController ()
{
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    iLIBDefaultView *_defaultView;
}
@property (nonatomic,strong) iLIBEngine *iLibEngine;
@property (nonatomic,strong) iLIBSquareViewController *iLibSquareController;
@property (nonatomic,assign) int pageCount;
@property (nonatomic,strong) NSArray *postsArray;
@end

@implementation iLIBBookCircleViewController

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
    [self setTitle:@"书友圈"];
    self.view.backgroundColor = backGroundColor;
    _segmentedControl.tintColor = iLibGreenColor;
    _tableView.backgroundColor = backGroundColor;
    
    //设置navigationItem按钮
    
    UIImage *rightImage = [UIImage imageNamed:@"add.png"];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightButton setBackgroundImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightButtonItem];
    
    //设置下拉，上拉列表
    
    _header = [[MJRefreshHeaderView alloc] init];
    _header.delegate = (id)self;
    _header.scrollView = _tableView;
    _footer = [[MJRefreshFooterView alloc] init];
    _footer.delegate = (id)self;
    _footer.scrollView = _tableView;
    _pageCount = 1;
    
    _defaultView = [[iLIBDefaultView alloc] initWithFrame:_tableView.frame];
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    _iLibSquareController = [[iLIBSquareViewController alloc] initWithNibName:@"iLIBSquareViewController" bundle:nil];
    //获取我的圈子数据
    
    [_iLibEngine getBookCircleMessageWithType:0 page:_pageCount onSuccess:^(NSArray *bookArray) {
        _postsArray = bookArray;
        if (_postsArray.count == 0) {
            [self.view addSubview:_defaultView];
        }
        else{
            [_tableView reloadData];
        }
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_postsArray.count == 0 && [_defaultView superview] != self.view) {
        [self.view addSubview:_defaultView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_iLibEngine cancelAllOperations];
    if ([_defaultView superview] == self.view) {
        [_defaultView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (void)pushViewController {
	[self.navigationController pushViewController:_iLibSquareController animated:YES];
}

#pragma mark - SegmentDelegate

- (IBAction)mySegmentValueChanged:(id)sender {
    static int type = 0;
    type = _segmentedControl.selectedSegmentIndex;
    _pageCount = 1;
    [_iLibEngine getBookCircleMessageWithType:type page:_pageCount onSuccess:^(NSArray *bookArray) {
        _postsArray = bookArray;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
    } onError:^(NSError *engineError) {
        
    }];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_postsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"iLIBBookCircleCell";
    iLIBBookCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil]lastObject];
    }
    [cell configureForCell:[_postsArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table View delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 179;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (tableView == self.tableView) {
        if (_iLibBookFloatDetailViewController == nil) {
            _iLibBookFloatDetailViewController = [[iLIBBookFloatDetailViewController alloc] initWithNibName:@"iLIBBookFloatDetailViewController" bundle:nil];
        }
        [_iLibBookFloatDetailViewController setBook:[_booksArray objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:_iLibBookFloatDetailViewController animated:YES];
    }
    else if (tableView == _popoverView) {
        _CurrentSelectRow = indexPath.row;
        _pageCount = 1;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _titleLabel.text = cell.textLabel.text;
        [self performSelector:@selector(dropDown:) withObject:nil];
        [_iLibEngine getFloatBooksWithType:[NSString stringWithFormat:@"%d",indexPath.row] page:_pageCount onSuccess:^(NSArray *bookArray) {
            _booksArray = (id)bookArray;
            _booksDataSource.items = self.booksArray;
            [_tableView reloadData];
        } onError:^(NSError *engineError) {
            [UIAlertView showWithText:@"获取漂流图书数据失败，请重试"];
        }];
    }*/
    
}

#pragma mark - Refresh view delegate

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (_header == refreshView) {
        _pageCount = 1;
    }
    else {
        NSLog(@"加载更多");
        _pageCount ++;
    }
    [_iLibEngine getBookCircleMessageWithType:0 page:_pageCount onSuccess:^(NSArray *bookArray) {
        _postsArray = bookArray;
        if (_postsArray.count != 0 && [_defaultView superview] == self.view) {
            [_defaultView removeFromSuperview];
        }
        if (_postsArray.count == 0) {
            [self.view addSubview:_defaultView];
        }
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableView) userInfo:nil repeats:NO];
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)reloadTableView
{
    [_tableView reloadData];
    [_header endRefreshing];
    [_footer endRefreshing];
}

@end
