//
//  iLIBBookItemCell.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-27.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBBookItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bookCoverImage;
@property (strong, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookAuthorLabel;

@end
