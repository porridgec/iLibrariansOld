//
//  iLIBBorrowedBooksCell.m
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import "iLIBBorrowedBooksCell.h"
#import "iLIBBookItem.h"
#import "NSDate+RFC1123.h"

@implementation iLIBBorrowedBooksCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.bookNameLabel = [[UILabel alloc]init];
        self.dueDateLabel = [[UILabel alloc]init];
        self.daysLeftLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.bookNameLabel];
        [self.contentView addSubview:self.dueDateLabel];
        [self.contentView addSubview:self.daysLeftLabel];
    }
    self.greyBar.backgroundColor = [UIColor grayColor];
    return self;
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"iLIBBorrowedBooksCell" owner:nil options:nil]
             lastObject];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForCell:(iLIBBookItem *)bookItem
{
    
    self.bookNameLabel.text = bookItem.title;
    self.dueDateLabel.text = [bookItem.dueDate stringWithDateFormat:@"应于yyyy年MM月dd日归还"];
    NSTimeInterval remainderTimeInterval = [[bookItem dueDate] timeIntervalSinceDate:[NSDate date]];
    if (remainderTimeInterval > 0) {
        NSTimeInterval secondsOfADay = 24 * 60 * 60;
        NSInteger remainderDays = remainderTimeInterval / secondsOfADay;
        self.daysLeftLabel.text = [NSString stringWithFormat:@"还剩%d天", remainderDays];
    } else {
        self.daysLeftLabel.text = @"过期啦！";
    }
}
@end
