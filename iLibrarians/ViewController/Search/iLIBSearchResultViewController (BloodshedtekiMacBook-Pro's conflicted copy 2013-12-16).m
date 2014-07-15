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
#import "UIImageView+WebCache.h"
//#import "SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface iLIBSearchResultViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *searchedBooks;
@property (strong, nonatomic) NSString       *setNumber;
@property (strong, nonatomic) NSString       *docNumber;
@property BOOL didFinishedQuerying;
@property int bookCount ;
@property int pageIndex;
@property BOOL resultEmpty;

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
    
    self.didFinishedQuerying = NO;
    self.bookCount           = 0;
    self.pageIndex           = 1;
    self.iLibEngine          = [[iLIBEngine alloc]initWithHostName:kHostUrl];

    [self searchBookWithName:self.searchString];
    
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:YES];
//    if(_didFinishedQuerying == NO)
//        [self searchBookWithName:self.searchString];
//}
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
    if(_didFinishedQuerying == YES && _bookCount != 0 )
    {
        NSLog(@"we found %d books",_bookCount);
        return _bookCount;
        
    }
    else
    {
        NSLog(@"there are no books found so got only 1 cell");
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_didFinishedQuerying == YES && _bookCount == 0)
    {
        UITableViewCell *cell = [_resultTableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        }
        [cell.textLabel setText:@"哇啦，图书馆没有这样的书哟~"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    
    static NSString *CellIdentifier = @"iLIBBookItemCell";
    
    
    iLIBBookItemCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = nib[0];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        
        
    }

    cell.bookTitleLabel.text = [[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.bookAuthorLabel.text = [[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"author"];
    
    NSURL *coverUrl=[NSURL URLWithString:[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"cover"]];
    [cell.bookCoverImage setImageWithURL:coverUrl];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_bookCount != 0)
    {
        iLIBBookItemCell *cell = (iLIBBookItemCell*)[tableView cellForRowAtIndexPath:indexPath];
        iLIBSearchResultDetailViewController *detailView = [[iLIBSearchResultDetailViewController alloc]initWithNibName:@"iLIBSearchResultDetailViewController" bundle:nil];
        
        detailView.title = cell.bookTitleLabel.text;
        detailView.bookTitle = cell.bookTitleLabel.text;
        detailView.bookIndex = [NSString stringWithFormat:@"%@",[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"index"]] ;
        detailView.author = cell.bookAuthorLabel.text;
        detailView.publish = [NSString stringWithFormat:@"%@",[[_searchedBooks objectAtIndex:indexPath.row] objectForKey:@"press"]] ;
        detailView.bookCover = cell.bookCoverImage.image;
        detailView.docNumber = [[self.searchedBooks objectAtIndex:indexPath.row] objectForKey:@"doc_number"];
        [self.navigationController pushViewController:detailView animated:YES];
        
    }
    
}

//- (void)searchBookWithName:(NSString *)bookName{
//    NSString *queryEntry = [NSString stringWithFormat:@"http://%@/search_result_entry?name=%@",kHostUrl,bookName];
//    queryEntry = [queryEntry stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"query entry :%@",queryEntry);
//    NSURL *queryEntryURL = [NSURL URLWithString:queryEntry];
//    NSURLRequest *queryEntryRequest = [NSURLRequest requestWithURL:queryEntryURL];
//    NSError *entryError;
//    NSData *entryResponse = [NSURLConnection sendSynchronousRequest:queryEntryRequest returningResponse:nil error:nil];
//    NSDictionary *entryDic = [NSJSONSerialization JSONObjectWithData:entryResponse options:NSJSONReadingMutableLeaves error:&entryError];
//    NSDictionary *entryInfo = [entryDic objectForKey:@"entry"];
//    if([entryInfo count] != 2)
//    {
//        NSString *bookCountString = [entryInfo objectForKey:@"no_entries"];
//        if([bookCountString integerValue] <= 100)
//            _bookCount = [bookCountString intValue] ;
//        else
//            _bookCount = 100;
//        NSString *setNumber = [entryInfo objectForKey:@"set_number"];
//        NSString *entryString = [entryInfo objectForKey:@"no_entries"];
//        int entryCount = [entryString intValue];
//        NSString *setEntry = [NSString stringWithFormat:@"1-%d",entryCount];
//        NSString *searchBook = [NSString stringWithFormat:@"http://%@/search_result?set_number=%@&set_entry=%@",kHostUrl,setNumber, setEntry];
//        NSLog(@"%@",searchBook);
//        NSURL *searchBookURL = [NSURL URLWithString:searchBook];
//        NSURLRequest  *searchBookRequest = [NSURLRequest requestWithURL:searchBookURL];
//        NSError *bookError;
//        NSData *bookResponse = [NSURLConnection sendSynchronousRequest:searchBookRequest returningResponse:nil error:nil];
//        NSDictionary *bookDic = [NSJSONSerialization JSONObjectWithData:bookResponse options:NSJSONReadingMutableLeaves error:&bookError];
//        _searchedBooks = [bookDic objectForKey:@"books"];
//    }
//    _didFinishedQuerying = YES;
//    [self.resultTableView reloadData];
//}

- (void) searchBookWithName:(NSString *)bookName:(NSString *)searchString
{
    MBProgressHUD *hud       = [[MBProgressHUD alloc]initWithView:self.view];
    hud.dimBackground        = YES;
    [self.view addSubview:hud];
    hud.labelText            = @"loading...";
    [hud show:YES];

    
    
    [self.iLibEngine getSetNumberWithBookName:searchString onCompletion:^(NSString *setNumber,int bookCount){
        //
        self.setNumber = setNumber;
        self.bookCount  = bookCount;
        NSLog(@"%@ has %d items",self.setNumber,self.bookCount);
        [self.iLibEngine searchBooksWithBookNumberAndPage:self.setNumber page:self.bookCount onCompletion:^(NSMutableArray *searchedBooks) {
            NSLog(@"finished searching...");
            self.searchedBooks      = searchedBooks;
            self.didFinishedQuerying = YES;
            [self.resultTableView reloadData];
            [hud removeFromSuperview];
        } onError:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"出错啦！" message:@"网络问题" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [hud removeFromSuperview];
            [alertView show];
        }];
        /*
        [self.iLibEngine searchBooksWithSetNumberAndPage:self.setNumber page:self.bookCount onCompletion:^(NSMutableArray *searchedBooks){
            //
            NSLog(@"finished searching...");
            self.searchedBooks      = searchedBooks;
            self.didFinishedQuerying = YES;
            [self.resultTableView reloadData];
            [hud removeFromSuperview];
            
        }onError:^(NSError *error){
            //
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"出错啦！" message:@"网络问题" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [hud removeFromSuperview];
            [alertView show];
        }];*/
        
    }onError:^(NSError *error){
        //
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"出错啦！" message:@"网络问题" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [hud removeFromSuperview];
        [alertView show];
    }];

}
@end
