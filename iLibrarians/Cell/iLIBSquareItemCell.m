//
//  iLIBSquareItemCell.m
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBSquareItemCell.h"
#import "iLIBBookCircleItem.h"
#define cellBackgroundColor [UIColor colorWithRed:0.4784 green:0.9255 blue:0.7098 alpha:1.0]

@implementation iLIBSquareItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureForCell:(iLIBBookCircleItem *)item
{
    _squareItemNamelabel.text = item.itemName;
    self.contentView.backgroundColor = cellBackgroundColor;
}

@end
