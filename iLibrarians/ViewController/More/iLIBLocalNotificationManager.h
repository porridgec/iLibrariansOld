//
//  iLIBLocalNotificationManage.h
//  iLibrarians
//
//  Created by lanny on 12/8/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iLIBBookItem.h"

@interface iLIBLocalNotificationManager : NSObject

+ (void)cancelAllLocalNotifications;
// schedule local notification with bokitems array
+ (void)scheduleLocalNoticationWithBookItems:(NSArray *)bookItems;

// schedule local notification with bookitem
+ (void)scheduleLocalNotificationWithBookItem:(iLIBBookItem *)bookItem;


// schedule local notification with the date and userinfo
+ (void)scheduleLocalNotificationWithDate:(NSDate *)date userinfo:(NSDictionary *)userinfo;



@end
