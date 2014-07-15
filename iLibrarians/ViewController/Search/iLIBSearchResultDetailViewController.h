//
//  iLIBSearchResultDetailViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-17.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLIBSearchResultViewController.h"

@interface iLIBSearchResultDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bookCoverImage;
@property (strong, nonatomic) IBOutlet UILabel *bookIndexLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *publishLabel;
@property (strong, nonatomic) IBOutlet UITableView *statusTableView;

@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSString *bookIndex;
@property (strong, nonatomic) NSString *publish;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *docNumber;
@property (strong, nonatomic) UIImage *bookCover;

@property (strong, nonatomic) iLIBEngine *iLibEngine;
@end
