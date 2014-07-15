//
//  iLIBComment.h
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iLIBComment : NSObject

@property (nonatomic,copy) NSString* commentId;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString* replyId;
@property (nonatomic,copy) NSString* replyName;
@property (nonatomic,copy) NSString* resId;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString* userId;
@property (nonatomic,copy) NSString *userName;

@end
