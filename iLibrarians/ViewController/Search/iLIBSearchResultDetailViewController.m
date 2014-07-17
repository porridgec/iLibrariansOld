//
//  iLIBSearchResultDetailViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-17.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBSearchResultDetailViewController.h"
#import "iLIBEngine.h"
#import "iLIBBookItem.h"
#import "MBProgressHUD.h"

#define kHostUrl @"libapi.insysu.com"

#define aRGB(a,r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/1.0f]

@interface iLIBSearchResultDetailViewController ()
@property (strong, nonatomic) NSMutableArray *status;

@end

@implementation iLIBSearchResultDetailViewController

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
    [self setTitle:@"图书详情"];
    [self.view setBackgroundColor:aRGB(1, 239, 239, 239)];
    self.bookTitleLabel.text  = self.bookTitle;
    self.bookIndexLabel.text  = self.bookIndex;
    self.authorLabel.text     = self.author;
    self.bookCoverImage.image = self.bookCover;
    self.publishLabel.text    = self.publish;
    self.iLibEngine           = [[iLIBEngine alloc]initWithHostName:kHostUrl customHeaderFields:nil];
    //[self queryBookStatusWithDocNumber:self.docNumber];
    MBProgressHUD *hud        = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText             = @"加载中...";
    [hud show:YES];
    [self.statusTableView addSubview:hud];
    [self.iLibEngine getBookStatusWithDocNumber:self.docNumber onCompletion:^(NSMutableArray *status){
        //
        self.status = status;
        [self.statusTableView reloadData];
        [hud removeFromSuperview];
    }onError:^(NSError *error){
        //
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
    return [self.status count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"cellIdentifier";
    NSDictionary *curStatus = [self.status objectAtIndex:indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.status objectAtIndex:indexPath.row]objectForKey:@"sub-library"];
    if([[curStatus valueForKey:@"sub-library"] isEqualToString:@"业务书"]   ||
       [[curStatus valueForKey:@"sub-library"] isEqualToString:@"调拨临时"] ||
       [[curStatus valueForKey:@"sub-library"] isEqualToString:@"院系保留"]   ){
        cell.detailTextLabel.text = @"不外借";
    }
    else{
        if([[curStatus objectForKey:@"loan-status"] isKindOfClass:[NSNull class]] == NO  && [[curStatus valueForKey:@"loan-status"] isEqualToString:@"A"]){
            NSString *dueDate = [NSString stringWithFormat:@"%@",[curStatus objectForKey:@"loan-due-date"]];
            NSString *year    = [dueDate substringWithRange:NSMakeRange(0, 4)];
            NSString *month   = [dueDate substringWithRange:NSMakeRange(4, 2)];
            NSString *day     = [dueDate substringWithRange:NSMakeRange(6, 2)];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"借出至%@年%@月%@日",year,month,day];
            cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        }
        else{
            cell.detailTextLabel.text = @"在馆";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
