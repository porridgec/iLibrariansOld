//
//  LIBBookItem.h
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iLIBBookItem : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *barcode;
@property (nonatomic, copy) NSString *callNo;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSDate *dueDate;
@property (nonatomic, copy) NSString *isbn;
@property (nonatomic, assign) BOOL noRenew;
@property (nonatomic, copy) NSString *press;
@property (nonatomic, copy) NSString *title;

@end
