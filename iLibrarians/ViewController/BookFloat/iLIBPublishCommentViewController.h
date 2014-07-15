//
//  iLIBPublishCommentViewController.h
//  iLibrarians
//
//  Created by Alaysh on 12/17/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iLIBComment;

@interface iLIBPublishCommentViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextView *textView;
@property (nonatomic,strong) iLIBComment *comment;

@end
