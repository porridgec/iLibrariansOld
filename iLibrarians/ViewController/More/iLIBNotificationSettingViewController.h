//
//  iLIBNotificationSettingViewController.h
//  iLibrarians
//
//  Created by lanny on 12/6/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBNotificationSettingViewController : UITableViewController
@property (assign) BOOL isChangedSetting;
@property (assign) NSInteger currentSelectedRow;
@property (assign) BOOL isPickerShow;

- (void)didChangeRemindMeSwitchValue:(id)sender;
@end
