//
//  libraryEngine.m
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import "iLIBEngine.h"
#import "MKNetworkEngine.h"
#import "iLIBBookItem.h"
#import "iLIBFloatBookItem.h"
#import "iLIBBookCircleItem.h"
#import "iLIBComment.h"

#define kHostUrl @"libapi.insysu.com"
#define kFloatBookHostUrl @"xiaotest1.sinaapp.com"

@implementation iLIBEngine

- (id)init
{
    self = [super initWithHostName:kHostUrl customHeaderFields:nil];
    _engine = [[MKNetworkEngine alloc] initWithHostName:kFloatBookHostUrl customHeaderFields:nil];
    return self;
}

#pragma mark Search/MyLib

- (id)loginWithName:(NSString*)studentName password:(NSString*)password
        onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc] init];
    [loginDic setValue:studentName forKey:@"sno"];
    [loginDic setValue:password forKey:@"password"];
    MKNetworkOperation *op = (MKNetworkOperation*)[self operationWithPath:@"v1/signin" params:loginDic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"request string :%@",[completedOperation responseJSON]);
        NSDictionary *dic = [completedOperation responseJSON];
        self.studentId = studentName;
        self.studentName = [dic objectForKey:@"name"];
        succeedBlock();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [self enqueueOperation:op];
    return op;
}

- (void)requestSearchBooks:(NSString *)bookName onSucceeded:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSString *book_name = [NSString stringWithFormat:@"v1/search_result_entry?name=ps"];
    MKNetworkOperation *op = (MKNetworkOperation *)[self operationWithPath:book_name params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
        NSLog(@"printing responseJSON : \n%@",[completedOperation responseJSON]);
        NSDictionary *entryInfo = [completedOperation responseJSON];
        NSDictionary *entry = [entryInfo objectForKey:@"entry"];
        NSLog(@"elements in dic entry ＝ %lu",(unsigned long)[entry count]);
        if([entry count] != 2)
        {
            NSString *stringCountOfBooks = [entry objectForKey:@"no_records"];
            NSString *setNumber = [entry objectForKey:@"set_number"];
            int countOfBooks = [stringCountOfBooks intValue];
            NSLog(@"we got %d ------boks",countOfBooks);
            NSMutableArray *searchedBooks = [[NSMutableArray alloc]init];
            NSString *requestString = [NSString stringWithFormat:@"/search_result?set_number=%@&set_entry=%@",setNumber,@"1-10"];
            requestString = [kHostUrl stringByAppendingString:requestString];
            NSLog(@"%@",requestString);
            NSURL* url = [NSURL URLWithString:requestString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSError *dError;
            NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&dError];
            searchedBooks = [dic objectForKey:@"books"];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation,NSError *error){
        NSLog(@"***error***");
    }];
    [self enqueueOperation:op];
    NSLog(@"requestSearchBooks cURL is :\n%@",op);
}

-(MKNetworkOperation *)getSetNumberWithBookName:(NSString *)      bookName
                                   onCompletion:(SetNumberBlock)  completion
                                        onError:(MKNKErrorBlock)  error
{
    NSString *urlString    = [NSString stringWithFormat:@"v1/search_result_entry?name=%@",bookName];
    urlString              = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MKNetworkOperation *op = (MKNetworkOperation *)[self operationWithPath:urlString];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *response = [completedOperation responseJSON];
        NSMutableDictionary *entry    = [response objectForKey:@"entry"];
        if([entry count] != 2)
        {
            //NSLog(@"book number is %@\nwe have %@ items",[entry objectForKey:@"set_number"],[entry objectForKey:@"no_entries"]);
            int tmp       = [[entry objectForKey:@"no_entries"] intValue];
            NSString *num = [entry objectForKey:@"set_number"];
            completion(num,tmp);
        }
        else
        {
            int tmp       = 0;
            NSString *num = @"000000";
            completion(num,tmp);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"get setNumber failed\n");
    }];
    /*
     [op onCompletion:^(MKNetworkOperation *completedOperation){
     //
     NSMutableDictionary *response = [completedOperation responseJSON];
     NSMutableDictionary *entry    = [response objectForKey:@"entry"];
     if([entry count] != 2)
     {
     //NSLog(@"book number is %@\nwe have %@ items",[entry objectForKey:@"set_number"],[entry objectForKey:@"no_entries"]);
     int tmp       = [[entry objectForKey:@"no_entries"] intValue];
     NSString *num = [entry objectForKey:@"set_number"];
     completion(num,tmp);
     }
     else
     {
     int tmp       = 0;
     NSString *num = @"000000";
     completion(num,tmp);
     }
     }onError:^(NSError *error){
     //
     NSLog(@"get setNumber failed\n");
     }];*/
    [self enqueueOperation:op];
    return op;
}



- (MKNetworkOperation *)searchBooksWithBookNumberAndPage:(NSString *)     bookNumber
                                                    page:(int)            pageIndex
                                            onCompletion:(BooksBlock)     completion
                                                 onError:(MKNKErrorBlock) error
{
    int startPage       = 1 + ( pageIndex - 1) * 10;
    int endPage         = pageIndex * 10;
    NSString *urlString = [NSString stringWithFormat:@"v1/search_result?set_number=%@&set_entry=%d-%d",bookNumber,startPage,endPage];
    NSLog(@"%@",urlString);
    
    MKNetworkOperation *op = (MKNetworkOperation *)[self operationWithPath:urlString];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *books = [[completedOperation responseJSON] objectForKey:@"books"];
        //NSLog(@"~~~~~~~~~~~~~~~~%lu",(unsigned long)[books count]);
        completion(books);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"get books failed\n");
    }];
    [self enqueueOperation:op];
    return op;
}

- (MKNetworkOperation *)getBookStatusWithDocNumber:(NSString *)     docNumber
                                      onCompletion:(StatusBlock)    completion
                                           onError:(MKNKErrorBlock) error
{
    NSString *urlString    = [NSString stringWithFormat:@"v1/status?doc_number=%@",docNumber];
    
    MKNetworkOperation *op = (MKNetworkOperation *)[self operationWithPath:urlString];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableArray *status = [[completedOperation responseJSON] objectForKey:@"status"];
        completion(status);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"get stuats failed");
    }];
    [self enqueueOperation:op];
    return op;
}

- (void)requestLoanBooks:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation *op = (MKNetworkOperation*)[self operationWithPath:@"v1/loan_books"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *loanBooksArrayJSON = [responseDic objectForKey:@"books"];
        NSMutableArray *loanBooksArray = [[NSMutableArray alloc] init];
        //NSLog(@"loanBooksArray:%@",loanBooksArrayJSON);
        
        [loanBooksArrayJSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            iLIBBookItem *bookItem = [[iLIBBookItem alloc] init];
            [bookItem setValuesForKeysWithDictionary:obj];
            [loanBooksArray addObject:bookItem];
        }];
        successBlock(loanBooksArray);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error");
    }];
    [self enqueueOperation:op];
}

#pragma mark - BookFloat

- (void)getFloatBooksWithType:(NSString*)type page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"" forKey:@"b_text"];
    [dic setValue:type forKey:@"type"];
    [dic setValue:[NSString stringWithFormat:@"%d",(pageCount-1)*10] forKey:@"item_num"];
    MKNetworkOperation *op = [_engine operationWithPath:@"res_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *floatBooksArray = [responseDic objectForKey:@"ans_list"];
        //NSLog(@"books:%@",idleBooksArray);
        NSMutableArray *floatBooks = [[NSMutableArray alloc] init];
        if ((NSNull*)floatBooksArray != [NSNull null]) {
        [floatBooksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            iLIBFloatBookItem *bookItem = [[iLIBFloatBookItem alloc] init];
            [bookItem setValuesForKeysWithDictionary:obj];
            [floatBooks addObject:bookItem];
            
        }];
        }
        successBlock(floatBooks);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
        //[UIAlertView showWithError:error];
    }];
    [_engine enqueueOperation:op];
}

- (void)searchFloatBooksWithText:(NSString*)text onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:text forKey:@"b_text"];
    MKNetworkOperation *op = [_engine operationWithPath:@"res_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *idleBooksArray = [responseDic objectForKey:@"ans_list"];
        NSMutableArray *idleBooks = [[NSMutableArray alloc] init];
        if ((NSNull*)idleBooksArray != [NSNull null]) {
        [idleBooksArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            iLIBFloatBookItem *bookItem = [[iLIBFloatBookItem alloc] init];
            [bookItem setValuesForKeysWithDictionary:obj];
            if (bookItem.type != 2) {
                [idleBooks addObject:bookItem];
            }
            
        }];
        }
        successBlock(idleBooks);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [UIAlertView showWithError:error];
    }];
    [_engine enqueueOperation:op];
}

- (void)publishFloatBooks:(iLIBFloatBookItem*)book onSuccess:(VoidBlock)successBlock onError:(ErrorBlock)errorBlock;
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:book.booktitle forKey:@"b_title"];
    [dic setValue:book.bookAuthor forKey:@"b_author"];
    [dic setValue:book.bookIsBn forKey:@"b_isbn"];
    [dic setValue:book.content forKey:@"content"];
    [dic setValue:book.userId forKey:@"u_id"];
    [dic setValue:book.userName forKey:@"u_name"];
    if (book.type == 0) {
        [dic setValue:@"0" forKey:@"type"];
    }
    else if(book.type == 1){
        [dic setValue:@"1" forKey:@"type"];
    }
    else
        [dic setValue:@"2" forKey:@"type"];
    MKNetworkOperation *op = [_engine operationWithPath:@"add_item.php" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSLog(@"response:%@",responseDic);
        successBlock();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

- (void)getCommentWithId:(NSString*)anID page:(int)pageCount onSucceeded:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:anID forKey:@"res_id"];
    [dic setValue:[NSString stringWithFormat:@"%d",(pageCount-1)*10] forKey:@"item_num"];
    MKNetworkOperation *op = [_engine operationWithPath:@"comment_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *commentArray = [responseDic objectForKey:@"ans_list"];
        //NSLog(@"commentArray:%@",commentArray);
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        if ((NSNull*)commentArray != [NSNull null]) {
            
            [commentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                iLIBComment *comment = [[iLIBComment alloc] init];
                [comment setValuesForKeysWithDictionary:obj];
                [comments addObject:comment];
            }];
        }
        successBlock(comments);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

- (void)writeCommentWithId:(iLIBComment*)aComment onSucceeded:(VoidBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:aComment.commentId forKey:@"comment_id"];
    [dic setValue:aComment.resId forKey:@"res_id"];
    [dic setValue:aComment.userId forKey:@"u_id"];
    [dic setValue:aComment.userName forKey:@"u_name"];
    [dic setValue:aComment.replyId forKey:@"reply_id"];
    [dic setValue:aComment.replyName forKey:@"reply_name"];
    [dic setValue:aComment.content forKey:@"content"];
    MKNetworkOperation *op = [_engine operationWithPath:@"add_comment.php" params:dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSLog(@"response:%@",responseDic);
        successBlock();
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

#pragma mark - BookCircle

- (void)getBookCircleMessageWithType:(int)type page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",2] forKey:@"type"];
    [dic setValue:[NSString stringWithFormat:@"%d",(pageCount-1)*10] forKey:@"item_num"];
    MKNetworkOperation *op = [_engine operationWithPath:@"res_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *bookCircleItemsArray = [responseDic objectForKey:@"ans_list"];
        NSMutableArray *bookCircleItems = [[NSMutableArray alloc] init];
        if ((NSNull*)bookCircleItemsArray != [NSNull null]) {
            [bookCircleItemsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                iLIBFloatBookItem *bookItem = [[iLIBFloatBookItem alloc] init];
                [bookItem setValuesForKeysWithDictionary:obj];
                [bookCircleItems addObject:bookItem];
            }];
        }
        successBlock(bookCircleItems);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

- (void)getBookCircleMessageWithId:(int)circleId page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",2] forKey:@"type"];
    [dic setValue:[NSString stringWithFormat:@"%d",(pageCount-1)*10] forKey:@"item_num"];
    MKNetworkOperation *op = [_engine operationWithPath:@"res_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *bookCircleItemsArray = [responseDic objectForKey:@"ans_list"];
        NSMutableArray *bookCircleItems = [[NSMutableArray alloc] init];
        if ((NSNull*)bookCircleItemsArray != [NSNull null]) {
            [bookCircleItemsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                iLIBFloatBookItem *bookItem = [[iLIBFloatBookItem alloc] init];
                [bookItem setValuesForKeysWithDictionary:obj];
                [bookCircleItems addObject:bookItem];
            }];
        }
        successBlock(bookCircleItems);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

- (void)getBookCircleCommentWithType:(int)resId page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"2" forKey:@"type"];
    [dic setValue:[NSString stringWithFormat:@"%d",resId] forKey:@"res_id"];
    [dic setValue:[NSString stringWithFormat:@"%d",(pageCount-1)*10] forKey:@"item_num"];
    MKNetworkOperation *op = [_engine operationWithPath:@"comment_by.php" params:dic httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *responseDic = [completedOperation responseJSON];
        NSMutableArray *commentArray = [responseDic objectForKey:@"ans_list"];
        NSLog(@"commentArray:%@",commentArray);
        NSMutableArray *comments = [[NSMutableArray alloc] init];
        if ((NSNull*)commentArray != [NSNull null]) {
            
            [commentArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                iLIBComment *comment = [[iLIBComment alloc] init];
                [comment setValuesForKeysWithDictionary:obj];
                [comments addObject:comment];
            }];
        }
        successBlock(comments);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [_engine enqueueOperation:op];
}

- (void)getBookCircleItemWithPage:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock
{
    iLIBBookCircleItem *item1 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item2 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item3 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item4 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item5 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item6 = [[iLIBBookCircleItem alloc] init];
    iLIBBookCircleItem *item7 = [[iLIBBookCircleItem alloc] init];
    [item1 setItemName:@"动漫" itemItro:@"动漫哦" itemId:0];
    [item2 setItemName:@"小说" itemItro:@"小说哦" itemId:1];
    [item3 setItemName:@"科技" itemItro:@"科技哦" itemId:2];
    [item4 setItemName:@"艺术" itemItro:@"艺术哦" itemId:3];
    [item5 setItemName:@"旅行" itemItro:@"旅行哦" itemId:4];
    [item6 setItemName:@"摄影" itemItro:@"摄影哦" itemId:5];
    [item7 setItemName:@"诗歌" itemItro:@"诗歌哦" itemId:6];
    NSArray *itemArray = [NSArray arrayWithObjects:item1,item2,item3,item4,item5,item6,item7,nil];
    successBlock(itemArray);
}

#pragma mark - PersonCenter

- (id)logout:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock
{
    MKNetworkOperation *op = (MKNetworkOperation*)[self operationWithPath:@"v1/signout" params:nil httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation){
        NSLog(@"loggout ok\n");
        succeedBlock();
    }errorHandler:^(MKNetworkOperation *completedOperation,NSError *error){
        errorBlock(error);
    }];
    [self enqueueOperation:op];
    NSLog(@"Logout cURL is :\n%@",op);
    return op;
}

- (void)requestAppItems:(SuccessDict)successBlock onError:(ErrorBlock)errorBlock{
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc]initWithHostName:@"www.applesysu.com"];
    
    MKNetworkOperation *op = (MKNetworkOperation*)[engine operationWithURLString:@"/scripts/moreinfo.txt" params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *result = [completedOperation responseJSON];
        NSLog(@"request AppItems finished");
        successBlock(result);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        errorBlock(error);
    }];
    [engine enqueueOperation:op];
}



@end

