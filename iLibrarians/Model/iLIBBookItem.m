//
//  LIBBookItem.m
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import "iLIBBookItem.h"
#import "NSDate+RFC1123.h"

@implementation iLIBBookItem

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"call-no"])
    {
        self.callNo = value;
    }
    else if([key isEqualToString:@"due-date"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        self.dueDate = [dateFormatter dateFromString:(NSString*)value];
    }
    else if([key isEqualToString:@"no-renew"])
    {
        self.noRenew = (BOOL)value;
    }
    else
        NSLog(@"Undefined key:%@",key);
}


@end
