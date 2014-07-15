//
//  iLIBBorrowedBookDetailViewController.h
//  iLibrarians
//
//  Created by Alaysh on 11/15/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iLIBEngine;
@class iLIBBookItem;
@interface iLIBBorrowedBookDetailViewController : UIViewController

@property(strong,nonatomic)iLIBBookItem *bookItem;
@property(weak,nonatomic)IBOutlet UILabel *bookNameLabel;
@property(weak,nonatomic)IBOutlet UILabel *bookBarcodeLabel;
@property(weak,nonatomic)IBOutlet UILabel *dueDateLabel;
@property(weak,nonatomic)IBOutlet UILabel *daysLeftLabel;
@property(weak,nonatomic)IBOutlet UILabel *authorLabel;
@property(weak,nonatomic)IBOutlet UILabel *bookPressLabel;
@property(weak,nonatomic)IBOutlet UIImageView *coverView;
@property(weak,nonatomic)UIImage *image;
@property (strong, nonatomic) iLIBEngine *iLibEngine;

- (void)initWithBookItem;

@end
