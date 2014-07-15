//
//  ArrayDataSource.h
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TableViewConfigureBlock)(id cell,id item);

@interface ArrayDataSource : NSObject<UITableViewDataSource>
@property (nonatomic,strong) NSArray *items;
- (id)initWithItems:(NSArray* )anItemArray cellIndetifier:(NSString*)aCellIdentifier configureCellBlock:(TableViewConfigureBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

@end
