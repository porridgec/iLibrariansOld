//
//  iLIBBookFloatDetailCell.h
//  iLibrarians
//
//  Created by Alaysh on 12/19/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBFloatBookItem;
@interface iLIBBookFloatDetailCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *dataLabel;
@property (nonatomic,weak) IBOutlet UILabel *countLabel;
@property (nonatomic,weak) IBOutlet UITextView *contentTextView;
@property (nonatomic,weak) IBOutlet UIImageView *dotImageView;
- (void)configureForCell:(iLIBFloatBookItem *)bookItem;
@end
