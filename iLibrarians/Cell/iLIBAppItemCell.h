//
//  iLIBAppItemCell.h
//  iLibrarians
//
//  Created by lanny on 12/7/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBAppItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *sideButton;

@end
