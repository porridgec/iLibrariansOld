//
//  iLIBBookFloatCell.h
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBFloatBookItem;

@interface iLIBBookFloatCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *dataLabel;
@property (nonatomic,weak) IBOutlet UILabel *contentLabel;
@property (nonatomic,weak) IBOutlet UILabel *stateLabel;
@property (nonatomic,weak) IBOutlet UIView *backGroundView;
@property (nonatomic,weak) IBOutlet UIImageView *dotImage;

- (void)configureForCell:(iLIBFloatBookItem *)bookItem;

@end
