//
//  iLIBBookCircleItem.h
//  iLibrarians
//
//  Created by Alaysh on 12/21/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iLIBBookCircleItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemIntroduction;
@property (nonatomic, assign) int itemId;

- (void)setItemName:(NSString *)itemName itemItro:(NSString*)itemIntroduction itemId:(int)anItemId;
@end
