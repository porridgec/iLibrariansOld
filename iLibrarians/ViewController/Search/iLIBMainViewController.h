//
//  iLIBMainViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iLIBEngine;

@interface iLIBMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) NSString *searchRequest;
@property (strong, nonatomic) iLIBEngine *iLibEngine;

- (IBAction)backgroundTouchUpInside:(id)sender;
- (IBAction)SearchTextFieldDidEndOnExit:(id)sender;
- (IBAction)SearchTextFieldEditBegin:(id)sender;
- (IBAction)SearchTextFieldEditEnd:(id)sender;


@end
