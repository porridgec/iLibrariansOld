//
//  iLIBBookFloatViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBBookFloatViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic,weak) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)mySegmentValueChanged:(id)sender;

@end
