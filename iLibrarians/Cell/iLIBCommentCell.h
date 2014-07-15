//
//  iLIBCommentCell.h
//  iLibrarians
//
//  Created by Alaysh on 11/23/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBComment;

@interface iLIBCommentCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *commentLabel;
@property (nonatomic,weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic,weak) IBOutlet UILabel *dateLabel;

- (void)configureForCell:(iLIBComment *)aComment;

@end
