//
//  iLIBPublishFloatBookViewController.h
//  iLibrarians
//
//  Created by Alaysh on 11/29/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBPublishFloatBookViewController : UIViewController<UITextViewDelegate>

@property (nonatomic,weak) IBOutlet UITextField *bookNameLabel;
@property (nonatomic,weak) IBOutlet UITextField *bookAuthorLabel;
@property (nonatomic,weak) IBOutlet UITextView *contentTextView;

- (IBAction)resignFirstResponder:(id)sender;
- (IBAction)publishIdleBook:(id)sender;
- (IBAction)publishBegBook:(id)sender;

@end
