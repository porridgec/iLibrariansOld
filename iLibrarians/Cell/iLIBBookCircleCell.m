//
//  iLIBBookCircleCell.m
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBBookCircleCell.h"
#import "UIImage+EllipseImage.h"
#import "iLIBFloatBookItem.h"
#define backGroundColor [UIColor colorWithRed:0.9569 green:0.9569 blue:0.9569 alpha:1.0]
@implementation iLIBBookCircleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForCell:(iLIBFloatBookItem *)bookItem
{
    self.contentView.backgroundColor = backGroundColor;
    _usernameLabel.text = bookItem.userName;
    _timeLabel.text = bookItem.date;
    _commentLabel.text = bookItem.content;
    _bookNameLabel.text = bookItem.booktitle;
}
@end
