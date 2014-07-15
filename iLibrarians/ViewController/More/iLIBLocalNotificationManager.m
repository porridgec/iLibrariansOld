//
//  iLIBLocalNotificationManage.m
//  iLibrarians
//
//  Created by lanny on 12/8/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBLocalNotificationManager.h"
#import "iLIBBookItem.h"
#import "NSDate+RFC1123.h"

@implementation iLIBLocalNotificationManager

+ (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

// schedule local notification with bokitems array
+ (void)scheduleLocalNoticationWithBookItems:(NSArray *)bookItems
{
    for (iLIBBookItem *bookItem in bookItems) {
        [self scheduleLocalNotificationWithBookItem:bookItem];
    }
}

// schedule local notification with bookitem
+ (void)scheduleLocalNotificationWithBookItem:(iLIBBookItem *)bookItem
{
    
    NSInteger beforeDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeBeforeDay"];
    NSInteger everyDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeEveryDay"];
    NSDate* reminderDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"remindeTime"];
    NSDateComponents *reminderDateComponents = [[NSCalendar currentCalendar] components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:reminderDate];
    
    NSDateComponents *duedateComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:bookItem.dueDate];
    
    [duedateComponents setHour:reminderDateComponents.hour];
    [duedateComponents setMinute:reminderDateComponents.minute];
    
    NSDate *notificationDate = [[NSCalendar currentCalendar] dateFromComponents:duedateComponents];
    
    
    
    NSTimeInterval secondsOfADay = 24 * 60 * 60;
    
    NSDictionary *userInfo = @{
                               @"title": bookItem.title,
                               @"dueDate": bookItem.dueDate
                               };
    
    NSDate *beginRemindDate = [bookItem.dueDate dateByAddingTimeInterval:-(secondsOfADay * beforeDays)];
    
    while ([notificationDate timeIntervalSinceNow] >= 0
           && [notificationDate timeIntervalSinceDate:beginRemindDate] >= 0) {
        NSTimeInterval timeInterval = secondsOfADay * everyDays;
        
        NSTimeInterval remainderTimeInterval = [bookItem.dueDate timeIntervalSinceDate:notificationDate];
        NSInteger reminderDays = remainderTimeInterval / secondsOfADay;
        
        if (reminderDays <= beforeDays) {
            NSMutableDictionary *thisUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
            [thisUserInfo setValue:[NSNumber numberWithInt:reminderDays] forKey:@"remindeDays"];
            
            [self scheduleLocalNotificationWithDate:notificationDate userinfo:thisUserInfo];
        }
        
        notificationDate = [notificationDate dateByAddingTimeInterval:-timeInterval];
    };
    
}

// schedule local notification with the date
+ (void)scheduleLocalNotificationWithDate:(NSDate *)date userinfo:(NSDictionary *)userinfo
{
    NSString *title = [userinfo valueForKey:@"title"];
    NSDate *dueDate = [userinfo valueForKey:@"dueDate"];
    NSInteger reminderDays = [[userinfo valueForKey:@"remindeDays"] integerValue];
    NSString *alertBody;
    if (reminderDays == 0) {
        alertBody = [NSString stringWithFormat:@"《%@》马上就要到期啦！今天就去还书吧", title];
    } else {
        alertBody = [NSString stringWithFormat:@"《%@》还有%d天到期，记得在%@前还书哦", title, reminderDays, [dueDate stringWithDateFormat:@"MM月dd日"]];
    }
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    [localNotification setFireDate:date];
    [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
    [localNotification setAlertBody:alertBody];
    [localNotification setAlertAction:@"查看"];
    [localNotification setSoundName:UILocalNotificationDefaultSoundName];
    [localNotification setUserInfo:userinfo];
}


@end
