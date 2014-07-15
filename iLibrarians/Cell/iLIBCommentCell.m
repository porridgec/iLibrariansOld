//
//  iLIBCommentCell.m
//  iLibrarians
//
//  Created by Alaysh on 11/23/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBCommentCell.h"
#import "iLIBComment.h"
#define contentFont [UIFont systemFontOfSize:13]
@implementation iLIBCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configureForCell:(iLIBComment *)aComment
{
    UIFont *font = [UIFont systemFontOfSize:13];
    CGRect rect = [aComment.content boundingRectWithSize:CGSizeMake(238, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:contentFont}
                                                 context:nil];
    [self.commentLabel setFrame:CGRectMake(26,26, 238,rect.size.height+20)];
    self.commentLabel.text = aComment.content;
    self.commentLabel.font = font;
    self.userNameLabel.text = aComment.replyName;
    self.dateLabel.text = [aComment.time substringFromIndex:5];
}
@end
