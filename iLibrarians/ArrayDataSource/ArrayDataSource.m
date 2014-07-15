//
//  ArrayDataSource.m
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import "ArrayDataSource.h"
#import "iLIBBookFloatDetailViewController.h"
@interface ArrayDataSource()

@property (nonatomic,copy)NSString *cellIdentifier;
@property (nonatomic,copy)TableViewConfigureBlock configureCellBlock;

@end

@implementation ArrayDataSource

- (id)init
{
    return nil;
}

- (id)initWithItems:(NSArray *)anItemArray cellIndetifier:(NSString *)aCellIdentifier configureCellBlock:(TableViewConfigureBlock)aConfigureCellBlock
{
    self = [super init];
    if(self)
    {
        self.items = anItemArray;
        self.cellIdentifier = aCellIdentifier;
        self.configureCellBlock = aConfigureCellBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (cell == nil)
    {
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:self.cellIdentifier owner:nil options:nil]lastObject];
    }
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell,item);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
