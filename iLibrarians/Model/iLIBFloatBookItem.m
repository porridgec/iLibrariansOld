//
//  iLIBFloatBookItem.m
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBFloatBookItem.h"

@implementation iLIBFloatBookItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"type"]) {
        self.type = (int)value;
    }
    else if([key isEqualToString:@"u_id"]){
        self.userId = value;
    }
    else if([key isEqualToString:@"b_title"]){
        self.booktitle = value;
    }
    else if ([key isEqualToString:@"b_author"]){
        self.bookAuthor = value;
    }
    else if([key isEqualToString:@"b_isbn"]){
        self.bookIsBn = value;
    }
    else if ([key isEqualToString:@"content"]){
        self.content = value;
    }
    else if ([key isEqualToString:@"isok"]){
        self.isOk = (BOOL)value;
    }
    else if([key isEqualToString:@"id"]){
        self.resId = value;
    }
    else if([key isEqualToString:@"u_name"]){
        self.userName = value;
    }
    else
        self.date = value;
}
@end
