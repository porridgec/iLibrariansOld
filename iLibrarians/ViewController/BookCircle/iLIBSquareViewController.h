//
//  iLIBSquareViewController.h
//  iLibrarians
//
//  Created by Alaysh on 12/20/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iLIBSquareViewController : UIViewController<UICollectionViewDelegate,
                                                            UICollectionViewDataSource>
@property (nonatomic,strong) IBOutlet UICollectionView *collectionView;

@end
