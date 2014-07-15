//
//  iLIBLoginViewController.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-12.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBAppDelegate.h"
#import "iLIBLoginViewController.h"
#import "iLIBMyLibViewController.h"
#import "iLIBBookFloatViewController.h"
#import "iLIBBookCircleViewController.h"
#import "iLIBMoreViewController.h"
#import "iLIBMainViewController.h"
#import "MBProgressHUD.h"

#define tabbarTintColor [UIColor colorWithRed:0.4157 green:0.9216 blue:0.6784 alpha:1.0]
@interface iLIBLoginViewController ()

@end

@implementation iLIBLoginViewController

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
    [self setTitle:@"登陆"];
    self.usernameTextField.placeholder        = @"默认为学号";
    self.usernameTextField.returnKeyType      = UIReturnKeyNext;
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.placeholder        = @"默认为身份证后六位";
    self.passwordTextField.returnKeyType      = UIReturnKeyDone;
    self.passwordTextField.secureTextEntry    = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text               = [userDefault objectForKey:@"username"];
    self.passwordTextField.text               = [userDefault objectForKey:@"password"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureTabBar
{
    iLIBMainViewController *mainView           = [[iLIBMainViewController alloc] initWithNibName:@"iLIBMainViewController" bundle:nil];
    iLIBMyLibViewController *myLibView         = [[iLIBMyLibViewController alloc] initWithNibName:@"iLIBMyLibViewController" bundle:nil];
    iLIBBookFloatViewController *bookFloatView = [[iLIBBookFloatViewController alloc] initWithNibName:@"iLIBBookFloatViewController" bundle:nil];
    iLIBBookCircleViewController *bookCircleView = [[iLIBBookCircleViewController alloc] initWithNibName:@"iLIBBookCircleViewController" bundle:nil];
    iLIBMoreViewController *moreView           = [[iLIBMoreViewController alloc] initWithNibName:@"iLIBMoreViewController" bundle:nil];
    
    UINavigationController *mainNav            = [[UINavigationController alloc] initWithRootViewController:mainView];
    UINavigationController *myLibNav           = [[UINavigationController alloc] initWithRootViewController:myLibView];
    UINavigationController *bookFloatNav       = [[UINavigationController alloc] initWithRootViewController:bookFloatView];
    UINavigationController *bookCircleNav      = [[UINavigationController alloc]
        initWithRootViewController:bookCircleView];
    UINavigationController *moreNav            = [[UINavigationController alloc] initWithRootViewController:moreView];
    UIColor *barBackgroundColor = [UIColor colorWithRed:106/255.0 green:235/255.0 blue:173/255.0 alpha:1.0];
    self.tabBarController                      = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers      = @[myLibNav,bookFloatNav,bookCircleNav,moreNav];
    //self.tabBarController.viewControllers      = @[mainNav,bookFloatNav,bookCircleNav,moreNav];
    [[UITabBar appearance] setTintColor:barBackgroundColor];
    //[[UITabBar appearance] setBarTintColor:barBackgroundColor];
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar2.png"]];
    //[[UITabBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar2.png"]]];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    //[[UITabBar appearance] setBarTintColor:[UIColor yellowColor]];
    //self.tabBarController.viewControllers      = @[mainNav,myLibNav,bookFloatNav,bookCircleNav,moreNav];
    mainNav.navigationBar.barTintColor = barBackgroundColor;
    myLibNav.navigationBar.barTintColor = barBackgroundColor;
    bookFloatNav.navigationBar.barTintColor = barBackgroundColor;
    bookCircleNav.navigationBar.barTintColor = barBackgroundColor;
    moreNav.navigationBar.barTintColor = barBackgroundColor;
    UITabBarItem *mainItem                     = [[UITabBarItem alloc] initWithTitle:@"书目检索" image:[UIImage imageNamed:@"tabbar_mylib.png"] tag:0];
    [mainView setTabBarItem:mainItem];
    UITabBarItem *myLibItem                    = [[UITabBarItem alloc] initWithTitle:@"我的图书馆" image:[UIImage imageNamed:@"tabbar_mylib.png"] tag:0];
    [myLibView setTabBarItem:myLibItem];
    UITabBarItem *bookFloatItem                = [[UITabBarItem alloc] initWithTitle:@"图书漂流" image:[UIImage imageNamed:@"tabbar_bookfloat.png"] tag:0];
    [bookFloatView setTabBarItem:bookFloatItem];
    UITabBarItem *bookCircleItem               = [[UITabBarItem alloc] initWithTitle:@"书友圈" image:
        [UIImage imageNamed:@"tabbar_bookcircle.png"] tag:0];
    [bookCircleView setTabBarItem:bookCircleItem];
    UITabBarItem *moreItem                     = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"tabbar_personcenter.png"] tag:0];
    [moreView setTabBarItem:moreItem];
}

- (IBAction)backgroundTouchUpInside:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)usernameDidEndOnExit:(id)sender {
    //[self resignFirstResponder];
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)passwordDidEndOnExit:(id)sender {
    [self resignFirstResponder];
    [self login];
}

- (IBAction)loginTouchUpInside:(id)sender {
    
    [self resignFirstResponder];
    [self login];
    
}

- (void)login
{
    self.iLibEngine    = [iLIBAppDelegate sharedDelegate].iLibEngine;
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText      = @"登录中...";
    [hud show:YES];
    hud.dimBackground  = YES;
    [self.view addSubview:hud];
    /*
    [self configureTabBar];
    [hud removeFromSuperview];
    [self presentViewController:self.tabBarController animated:YES completion:nil];
    */
    [self.iLibEngine loginWithName:self.usernameTextField.text password:self.passwordTextField.text onSucceeded:^{
        //NSLog(@"%@ loggin",self.usernameTextField.text);
        NSUserDefaults *userDefaut = [NSUserDefaults standardUserDefaults];
        [userDefaut setObject:self.usernameTextField.text forKey:@"username"];
        [userDefaut setObject:self.passwordTextField.text forKey:@"password"];
        [userDefaut synchronize];
        [self configureTabBar];
        [hud removeFromSuperview];
        [self presentViewController:self.tabBarController animated:YES completion:nil];
    }onError:^(NSError *engineError){
     
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登陆失败" message:@"请检查用户名密码或网络设置" delegate:self cancelButtonTitle:@"寡人知道了" otherButtonTitles:nil];
        [hud removeFromSuperview];
        [alert show];
        NSLog(@"%@ login failed\n",self.usernameTextField.text);
    }];
}
@end
