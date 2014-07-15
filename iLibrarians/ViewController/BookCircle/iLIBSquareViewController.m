//
//  iLIBSquareViewController.m
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//
#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBSquareViewController.h"
#import "iLIBBookCircleDetailViewController.h"
#import "iLIBSquareItemCell.h"

@interface iLIBSquareViewController ()
{
    NSArray *squareItemArray;
}

@property (nonatomic,strong) iLIBBookCircleDetailViewController *iLibBookCircleDetailViewController;
@property (nonatomic,strong) iLIBEngine *iLibEngine;
@end

@implementation iLIBSquareViewController

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
    [self setTitle:@"分类"];
    
    //设置navigationItem按钮
    
    UIImage *leftImage = [UIImage imageNamed:@"return.png"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setBackgroundImage:leftImage forState:UIControlStateNormal];
    [leftButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:returnButtonItem];
    
    _iLibBookCircleDetailViewController = [[iLIBBookCircleDetailViewController alloc] initWithNibName:@"iLIBBookCircleDetailViewController" bundle:nil];

    [_collectionView registerNib:[UINib nibWithNibName:@"iLIBSquareItemCell" bundle:nil] forCellWithReuseIdentifier:@"iLIBSquareItemCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    _iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    
    //获取圈子分类信息
    
    [_iLibEngine getBookCircleItemWithPage:1 onSuccess:^(NSArray *bookArray) {
        squareItemArray = bookArray;
        [_collectionView reloadData];
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Collection Data Source

- (int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [squareItemArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"iLIBSquareItemCell";
    iLIBSquareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell configureForCell:[squareItemArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Collection Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select %d",indexPath.row);
    [_iLibBookCircleDetailViewController setILibBookCircleItem:[squareItemArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:_iLibBookCircleDetailViewController animated:YES];
}

@end
