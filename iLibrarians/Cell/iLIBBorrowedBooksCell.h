//
//  iLIBBorrowedBooksCell.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBBookItem;

@interface iLIBBorrowedBooksCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *greyBar;
@property (retain, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *daysLeftLabel;

- (void)configureForCell:(iLIBBookItem *)bookItem;

- (id)init;

@end
