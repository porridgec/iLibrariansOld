//
//  iLIBBookCircleItem.m
//  iLibrarians
//
//  Created by Alaysh on 12/21/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBBookCircleItem.h"

@implementation iLIBBookCircleItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"itemName"]) {
        _itemName = value;
    }
    else if([key isEqualToString:@"itemIntroduction"]){
        _itemIntroduction = value;
    }
    else if([key isEqualToString:@"itemId"]){
        _itemId = (int)value;
    }
    
}

- (void)setItemName:(NSString *)itemName itemItro:(NSString*)itemIntroduction itemId:(int)anItemId
{
    _itemName = itemName;
    _itemIntroduction = itemIntroduction;
    _itemId = anItemId;
}

@end
