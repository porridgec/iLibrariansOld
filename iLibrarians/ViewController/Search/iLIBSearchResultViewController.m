//
//  iLIBSearchResultViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBSearchResultViewController.h"
#import "iLIBSearchResultDetailViewController.h"
#import "iLIBBookItemCell.h"
#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
#import "iLIBBookItem.h"
#import "MBProgressHUD.h"
//#import "SDWebImage/UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
@interface iLIBSearchResultViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *searchedBooks;
@property (nonatomic, strong) NSString *bookNumber;
@property BOOL didFinishedSearching;
@property BOOL didFinishLoadingMore;
@property int bookCount ;
@property int pageCount;
@property int cellCount;
@property int pageIndex;

@end

@implementation iLIBSearchResultViewController
@synthesize iLibEngine = _iLibEngine;

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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"检索结果"];
    
    
    _bookCount            = 0;
    _cellCount            = 0;
    _pageIndex            = 1;
    _pageCount            = 0;
    _didFinishedSearching = NO;
    _didFinishLoadingMore = YES;
    self.iLibEngine       = [[iLIBEngine alloc]initWithHostName:kHostUrl customHeaderFields:nil];
    MBProgressHUD *hud    = [[MBProgressHUD alloc]initWithView:self.view];
    hud.dimBackground     = YES;
    hud.labelText         = @"努力查询中...";
    [self.view addSubview:hud];
    [hud show:YES];
    
    [self.iLibEngine getSetNumberWithBookName:self.searchString
                                 onCompletion:^(NSString *bookNumber,int bookCount){
        self.bookNumber = bookNumber;
        self.bookCount = bookCount;
        if(self.bookCount % 10 == 0){
            self.pageCount = self.bookCount / 10;
        }
        else{
            self.pageCount = (self.bookCount / 10) + 1;
        }
        NSLog(@"%@ has %d",self.bookNumber,self.bookCount);
        if(bookCount != 0)
        {
            [self.iLibEngine searchBooksWithBookNumberAndPage:self.bookNumber
                                                         page:self.pageIndex
                                                 onCompletion:^(NSMutableArray *searchedBooks){
                                                     //
                                                     self.searchedBooks        = searchedBooks;
                                                     self.cellCount            = [self.searchedBooks count];
                                                     self.didFinishedSearching = YES;
                                                     [self.resultTableView reloadData];
                                                     [hud removeFromSuperview];
                                                 }onError:^(NSError *error){
                                                     //
                                                     [hud removeFromSuperview];
                                                     UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"出错了" message:@"网络不太给力呀~" delegate:self cancelButtonTitle:@"寡人知道了" otherButtonTitles:nil];
                                                     [alert show];
                                                 }];
        }
        else{
            self.didFinishedSearching = YES;
            [self.resultTableView reloadData];
            UIAlertView *alert        = [[UIAlertView alloc ]initWithTitle:@"出错了" message:@"找不到这样的书呀~" delegate:self cancelButtonTitle:@"寡人知道了" otherButtonTitles:nil];
            [alert show];
            [hud removeFromSuperview];
            
        }
    }onError:^(NSError *error){
        //
        [hud removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc ]initWithTitle:@"出错了" message:@"网络不太给力呀~" delegate:self cancelButtonTitle:@"寡人知道了" otherButtonTitles:nil];
        [alert show];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.didFinishedSearching == YES){
        if(self.bookCount != 0){
            return self.cellCount + 1;
        }
        else
            return 1;
    }
    else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_didFinishedSearching == YES){
        if(_bookCount == 0)
        {
            UITableViewCell *cell = [_resultTableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            }
            [cell.textLabel setText:@"找不到这样的书呀~"];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
        
        static NSString *CellIdentifier = @"iLIBBookItemCell";
        
        if(indexPath.row < _cellCount)
        {
            iLIBBookItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell==nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
                cell         = nib[0];
                [cell.textLabel setBackgroundColor:[UIColor clearColor]];
                
                
            }
            //NSLog(@"%ld",(long)indexPath.row);
            cell.bookTitleLabel.text  = [[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.bookAuthorLabel.text = [[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"author"];
            
            NSURL *coverUrl = [NSURL URLWithString:[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"cover"]];
            [cell.bookCoverImage setImageWithURL:coverUrl];
            return cell;
        }
        else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                
                [cell.textLabel setBackgroundColor:[UIColor clearColor]];
            }
            
            cell.textLabel.text          = @"load more";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        }
        
        cell.textLabel.text          = @"";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_bookCount != 0 && indexPath.row != self.cellCount)
    {
        iLIBBookItemCell *cell                           = (iLIBBookItemCell*)[tableView cellForRowAtIndexPath:indexPath];
        iLIBSearchResultDetailViewController *detailView = [[iLIBSearchResultDetailViewController alloc]initWithNibName:@"iLIBSearchResultDetailViewController" bundle:nil];

        detailView.title                                 = cell.bookTitleLabel.text;
        detailView.bookTitle                             = cell.bookTitleLabel.text;
        detailView.bookIndex                             = [NSString stringWithFormat:@"%@",[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"index"]] ;
        detailView.author                                = cell.bookAuthorLabel.text;
        detailView.publish                               = [NSString stringWithFormat:@"%@",[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"press"]] ;
        detailView.bookCover                             = cell.bookCoverImage.image;
        detailView.docNumber                             = [[self.searchedBooks objectAtIndex:indexPath.row] objectForKey:@"doc_number"];
        [self.navigationController pushViewController:detailView animated:YES];
        
    }
    if(indexPath.row == self.cellCount && self.didFinishLoadingMore == YES){
        self.pageIndex            += 1;
        self.didFinishLoadingMore = NO;
        [self loadMoreBooks];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footerView                = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    footerView.autoresizesSubviews    = YES;
    
    footerView.autoresizingMask       = UIViewAutoresizingFlexibleWidth;
    
    footerView.userInteractionEnabled = YES;
    
    footerView.hidden                 = YES;
    
    footerView.multipleTouchEnabled   = NO;
    
    footerView.opaque                 = NO;
    
    footerView.contentMode            = UIViewContentModeScaleToFill;
    
    footerView.backgroundColor        = [UIColor whiteColor];
    
    return footerView;
}

- (void)loadMoreBooks
{
    if(self.pageIndex <= self.pageCount){
        [self.iLibEngine searchBooksWithBookNumberAndPage:self.bookNumber page:self.pageIndex onCompletion:^(NSMutableArray *searchedBooks){
            NSMutableArray *newArr    = [[NSMutableArray alloc]initWithArray:self.searchedBooks];
            [newArr addObjectsFromArray:searchedBooks];
            self.searchedBooks        = newArr;
            self.cellCount            = [newArr count];
            self.didFinishLoadingMore = YES;
            [self.resultTableView reloadData];
            NSLog(@"book in display now is %d",[newArr count]);
        }onError:^(NSError *error){
            //
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"木有更多的书啦~" message:@"你已经遍历了所有的书~" delegate:self cancelButtonTitle:@"寡人知道了" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
@end
