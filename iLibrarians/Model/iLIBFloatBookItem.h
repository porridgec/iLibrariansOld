//
//  iLIBFloatBookItem.h
//  iLibrarians
//
//  Created by Alaysh on 11/22/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iLIBFloatBookItem : NSObject

@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString *resId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *booktitle;
@property (nonatomic,copy) NSString *bookAuthor;
@property (nonatomic,copy) NSString *bookIsBn;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) BOOL isOk;

@end
