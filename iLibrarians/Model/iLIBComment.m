//
//  iLIBComment.m
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBComment.h"

@implementation iLIBComment

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"comment_id"]) {
        self.commentId = value;
    }
    else if([key isEqualToString:@"content"]){
        self.content = value;
    }
    else if([key isEqualToString:@"reply_id"]){
        self.replyId = value;
    }
    else if ([key isEqualToString:@"reply_name"]){
        self.replyName = value;
    }
    else if([key isEqualToString:@"res_id"]){
        self.resId = value;
    }
    else if ([key isEqualToString:@"time"]){
        self.time = value;
    }
    else if ([key isEqualToString:@"u_id"]){
        self.userId = value;
    }
    else if([key isEqualToString:@"u_name"]){
        self.userName = value;
    }
}
@end
