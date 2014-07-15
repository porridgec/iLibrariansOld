//
//  iLIBBookFloatDetailViewController.h
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBFloatBookItem;
@interface iLIBBookFloatDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIView *textFieldBackgroundView;
@property (nonatomic,weak) IBOutlet UITextField *textField;
@property (nonatomic,strong) iLIBFloatBookItem *book;

- (IBAction)publishComment:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;

@end
