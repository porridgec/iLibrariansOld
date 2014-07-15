//
//  iLIBLoginViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-12.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLIBEngine.h"

@class iLIBEngine;

@interface iLIBLoginViewController : UIViewController<UITabBarControllerDelegate>

@property (strong,nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) iLIBEngine *iLibEngine;

- (IBAction)loginTouchUpInside:(id)sender;
- (IBAction)backgroundTouchUpInside:(id)sender;
- (IBAction)usernameDidEndOnExit:(id)sender;
- (IBAction)passwordDidEndOnExit:(id)sender;



@end
