//
//  iLIBSearchResultViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "iLIBEngine.h"

#define kHostUrl @"libapi.insysu.com"

@interface iLIBSearchResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) NSString *searchString;
@property (nonatomic,strong) iLIBEngine *iLibEngine;

//- (void)searchBookWithName:(NSString*)bookName;
@end
