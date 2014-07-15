//
//  iLIBSquareItemCell.h
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBBookCircleItem;

@interface iLIBSquareItemCell : UICollectionViewCell

@property (nonatomic,weak) IBOutlet UILabel *squareItemNamelabel;

- (void)configureForCell:(iLIBBookCircleItem *)item;

@end
