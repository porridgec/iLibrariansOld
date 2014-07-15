//
//  iLIBMoreViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//
#import "iLIBAppDelegate.h"
#import "iLIBMoreViewController.h"
#import "iLIBLoginViewController.h"
#import "iLIBNotificationSettingViewController.h"
#import "iLIBAboutViewController.h"
#import "iLIBMoreAppsViewController.h"
#import "iLIBLocalNotificationManager.h"
@interface iLIBMoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) iLIBEngine *iLibEngine;
@end

@implementation iLIBMoreViewController

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
    [self initUserInterface];
    self.iLibEngine = [[iLIBEngine alloc] init];
    //self.iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
    
}

- (void)initUserInterface
{
    [self setTitle:@"个人中心"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
        //return 3;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 14;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    {
        return 0;
    }
}
// Customize the appearance of table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 3){
        static NSString *logoutIdentifier =@"MoreTableLogoutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logoutIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logoutIdentifier];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        UIColor *color = [[UIColor alloc]initWithRed:255 green:0 blue:0 alpha:0];
        [cell.textLabel setBackgroundColor:color];
        [cell.textLabel setText:@"退出登陆"];
        return cell;
    }
    else{
    static NSString *CellIdentifier = @"MoreTabTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    switch (indexPath.section){
        case 0:
            switch ([indexPath row]) {
                case 0:
                    [cell.textLabel setText:@"提醒设置"];
                    break;
                /*
                case 1:
                    [cell.textLabel setText:@"隐私"];
                    break;
                default:
                    [cell.textLabel setText:@"通用"];
                    break;
                 */
            }
            break;
        case 1:
            [cell.textLabel setText:@"更多应用"];
            break;
        default:
            [cell.textLabel setText:@"关于"];
            break;
    }
    return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0){
        //set notification
        if (indexPath.row == 0){
            [self didTouchOnNotificationSetting];
            return ;
        }
        //set personal secret
        else if (indexPath.row == 1) {
            //TO DO:
            return ;
        }
        //general set
        else{
            // TO DO:
            return ;
        }
    }
    // more app item
    else if(indexPath.section == 1){
        iLIBMoreAppsViewController *moreAppView = [[iLIBMoreAppsViewController alloc] initWithNibName:@"iLIBMoreAppsViewController" bundle:nil];
        [moreAppView setTitle:@"more apps"];
        [self.navigationController pushViewController:moreAppView animated:YES];
    }
    // about us item
    else if(indexPath.section == 2){
        iLIBAboutViewController *aboutView = [[iLIBAboutViewController alloc]initWithNibName:@"iLIBAboutViewController" bundle:nil];
        [aboutView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:aboutView animated:YES];
    }
    else {
        [self didTouchOnLogoutItem];
    }
}
- (void)didTouchOnNotificationSetting{
    iLIBNotificationSettingViewController *settingView = [[iLIBNotificationSettingViewController alloc] initWithNibName:@"iLIBNotificationSettingViewController" bundle:nil];
    [settingView setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:settingView animated:YES];
    
    
}
- (void)didTouchOnLogoutItem{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0){
        
        [iLIBLocalNotificationManager cancelAllLocalNotifications];

        [self.iLibEngine logout:^(void){
            NSLog(@"log out success!");
        }onError:^(NSError *errorEngine){
            NSLog(@"Engine error!Failed to logout!");
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
}
@end
