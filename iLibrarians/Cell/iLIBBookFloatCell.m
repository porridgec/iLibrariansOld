//
//  iLIBBookFloatCell.m
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBBookFloatCell.h"
#import "iLIBFloatBookItem.h"
#import <QuartzCore/QuartzCore.h>

@implementation iLIBBookFloatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView.layer.cornerRadius = 8.0;
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configureForCell:(iLIBFloatBookItem *)bookItem
{
    if (bookItem.type == 0) {
        _usernameLabel.textColor = [UIColor colorWithRed:136/255.0 green:216/255.0 blue:231/255.0 alpha:1];
        _backGroundView.backgroundColor = [UIColor colorWithRed:136/255.0 green:216/255.0 blue:231/255.0 alpha:1];
        _dotImage.image = [UIImage imageNamed:@"dot_b.png"];
    }
    else if(bookItem.type == 1){
        _usernameLabel.textColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:110/255.0 alpha:1];
        _backGroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:202/255.0 blue:110/255.0 alpha:1];
        _dotImage.image = [UIImage imageNamed:@"dot_o.png"];
    }
    _usernameLabel.text = bookItem.userName;
    _backGroundView.layer.cornerRadius = 8;
    _contentLabel.text = bookItem.content;
    _dataLabel.text = bookItem.date;
    _stateLabel.text = @"";
}

@end
