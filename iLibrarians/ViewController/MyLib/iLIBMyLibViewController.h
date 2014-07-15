//
//  iLIBMyLibViewController.h
//  iLibrarians
//
//  Created by Bloodshed on 13-11-7.
//  Copyright (c) 2013年 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBMyLibViewController : UIViewController <UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *myLibSegment;
@property (strong, nonatomic) IBOutlet UITableView *borrowedBooksTableView;
@property (strong, nonatomic) IBOutlet UITableView *recommendedBooksTableView;
@property (strong, nonatomic) IBOutlet UITableView *personalInformationTableView;

- (IBAction)myLibSegmentValueChanged:(id)sender;

@end
