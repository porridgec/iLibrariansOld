//
//  iLIBBookCircleCell.h
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBFloatBookItem;
@interface iLIBBookCircleCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *commentLabel;
@property (nonatomic,weak) IBOutlet UILabel *bookIntroductionLabel;
@property (nonatomic,weak) IBOutlet UILabel *bookNameLabel;
- (void)configureForCell:(iLIBFloatBookItem *)bookItem;
@end
