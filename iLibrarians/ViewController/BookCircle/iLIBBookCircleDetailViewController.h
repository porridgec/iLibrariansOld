//
//  iLIBBookCircleDetailViewController.h
//  iLibrarians
//
//  Created by Alaysh on 12/21/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBBookCircleItem;

@interface iLIBBookCircleDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) iLIBBookCircleItem *iLibBookCircleItem;
@property (nonatomic,weak) IBOutlet UITableView *tableView;
@property (nonatomic,weak) IBOutlet UIView *textFieldBackgroundView;
@property (nonatomic,weak) IBOutlet UITextField *textField;
@property (nonatomic,weak) IBOutlet UILabel *circleIntroductionLabel;
@property (nonatomic,weak) IBOutlet UIView *circleIntroductionView;

- (IBAction)publishMessage:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;
@end
