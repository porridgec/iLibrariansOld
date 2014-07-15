//
//  iLIBBookFloatDetailCell.m
//  iLibrarians
//
//  Created by Alaysh on 12/19/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBBookFloatDetailCell.h"
#import "iLIBFloatBookItem.h"
#define idleBookColor [UIColor colorWithRed:136/255.0 green:216/255.0 blue:231/255.0 alpha:1]
#define begBookColor [UIColor colorWithRed:255/255.0 green:202/255.0 blue:110/255.0 alpha:1]
#define readerDiscussColor [UIColor colorWithRed:255/255.0 green:153/255.0 blue:134/225.0 alpha:1]
#define blueDotImage [UIImage imageNamed:@"dot_b.png"]
#define yellowDotImage [UIImage imageNamed:@"dot_o.png"]
#define redDotImage [UIImage imageNamed:@"dot_p.png"]
#define contentFont [UIFont systemFontOfSize:13]
@implementation iLIBBookFloatDetailCell

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
    if (bookItem.type == 0) {
        _usernameLabel.textColor = idleBookColor;
        _countLabel.textColor = idleBookColor;
        _contentTextView.backgroundColor = idleBookColor;
        _dotImageView.image = blueDotImage;
    }
    else if(bookItem.type == 1){
        _usernameLabel.textColor = begBookColor;
        _countLabel.textColor = begBookColor;
        _contentTextView.backgroundColor = begBookColor;
        _dotImageView.image = yellowDotImage;
    }
    else{
        _usernameLabel.textColor = readerDiscussColor;
        _countLabel.textColor = readerDiscussColor;
        _contentTextView.backgroundColor = readerDiscussColor;
        _dotImageView.image = redDotImage;
    }
    _contentTextView.layer.cornerRadius = 8;
    _usernameLabel.text = bookItem.userName;
    _dataLabel.text = [bookItem.date substringFromIndex:5];
    CGRect rect = [bookItem.content boundingRectWithSize:CGSizeMake(278, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:contentFont}
                                              context:nil];
    [_contentTextView setFrame:CGRectMake(22,34, 278,(rect.size.height>80?rect.size.height:80))];
    _contentTextView.scrollEnabled = FALSE;
    _contentTextView.text = bookItem.content;
    _contentTextView.font = contentFont;
}

@end
