//
//  iLIBDefaultView.m
//  iLibrarians
//
//  Created by Alaysh on 12/21/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBDefaultView.h"

@implementation iLIBDefaultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 200, 200, 100)];
        label.numberOfLines = 0;
        label.text = @"额，还没有任何消息!\n快来发布第一条消息吧!!!";
        label.textColor = [UIColor orangeColor];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
        [self addSubview:label];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
