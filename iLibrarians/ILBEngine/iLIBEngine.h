//
//  libraryEngine.h
//  TestLibrary
//
//  Created by Alaysh on 11/13/13.
//  Copyright (c) 2013 Alaysh. All rights reserved.
//

#import "MKNetworkEngine.h"

@class iLIBFloatBookItem;
@class iLIBComment;

/**
 *  调用成功回调
 *
 *  @since  1.0
 */
typedef void (^VoidBlock)(void);
/**
 *  调用失败回调
 *
 *  @param  engineError 失败信息
 *
 *  @since  1.0
 */
typedef void (^ErrorBlock)(NSError* engineError);
/**
 *  调用成功回调
 *
 *  @param  bookArray   调用成功返回数据数组
 *
 *  @since  1.0
 */
typedef void (^SuccessBlock)(NSArray *bookArray);
/**
 *  调用成功回调
 *
 *  @param  resultDict   调用成功返回数据字典
 *
 *  @since  1.0
 */
typedef void (^SuccessDict) (NSDictionary *resultDict);
/**
 *  调用成功回调
 *
 *  @param  setNumber   调用成功返回查询字串setNumber
 *  @param  bookCount   调用成功返回书籍数量
 *
 *  @since  1.0
 */
typedef void (^SetNumberBlock)(NSString *setNumber,int bookCount);
/**
 *  调用成功回调
 *
 *  @param  searchedBooks   调用成功返回符合条件书籍数组
 *
 *  @since  1.0
 */
typedef void (^BooksBlock)(NSMutableArray *searchedBooks);
/**
 *  调用成功回调
 *
 *  @param  status   调用成功返回书籍在馆状态
 *
 *  @since  1.0
 */
typedef void (^StatusBlock)(NSMutableArray *status);

@interface iLIBEngine : MKNetworkEngine

/// studentName：当前用户名字
@property(nonatomic,copy) NSString* studentName;
/// studentId:当前用户学工号
@property(nonatomic,copy) NSString* studentId;
/// 漂流区、书友圈网络引擎
@property(nonatomic,strong) MKNetworkEngine* engine;
/**
 *  登录我的图书馆
 *
 *  @param  studentName 学号
 *  @param  password    密码
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (id)loginWithName:(NSString*)studentName password:(NSString*)password
        onSucceeded:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock;
/***
 *  查询图书
 *
 *  @param  bookName    书名
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)requestSearchBooks:(NSString *)bookName onSucceeded:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/***
 *  通过书名查询setNumber
 *
 *  @param  bookName        输入的查询字串
 *  @param  completion      调用成功回调
 *  @param  error           调用失败回调
 *
 *  @since  1.0
 */
- (MKNetworkOperation *)getSetNumberWithBookName:(NSString *)      bookName
                                    onCompletion:(SetNumberBlock)  completion
                                         onError:(MKNKErrorBlock)  error;
/***
 *  通过setNumber和page获得书籍数组
 *
 *  @param  bookNumber      即SetNumber
 *  @param  pageIndex       页码
 *  @param  completion      调用成功回调
 *  @param  error           调用失败回调
 *
 *  @since  1.0
 */
- (MKNetworkOperation *)searchBooksWithBookNumberAndPage:(NSString *)     bookNumber
                                                    page:(int)            pageIndex
                                            onCompletion:(BooksBlock)     completion
                                                 onError:(MKNKErrorBlock) error;
/***
 *  通过docNumber获得书籍在馆状态
 *
 *  @param  docNumber      书籍独有的docNumber
 *  @param  pageIndex      页码
 *  @param  completion     调用成功回调
 *  @param  error          调用失败回调
 *
 *  @since  1.0
 */
- (MKNetworkOperation *)getBookStatusWithDocNumber:(NSString *)     docNumber
                                      onCompletion:(StatusBlock)    completion
                                           onError:(MKNKErrorBlock) error;
/**
 *  请求借阅图书
 *
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)requestLoanBooks:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求漂流图书数据
 *
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getFloatBooksWithType:(NSString*)type page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  搜索漂流图书信息
 *
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)searchFloatBooksWithText:(NSString*)text onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  发布漂流图书信息
 *
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)publishFloatBooks:(iLIBFloatBookItem*)book onSuccess:(VoidBlock)successBlock onError:(ErrorBlock)errorBlock;
/***
 *  获取评论
 *
 *  @param  anID  信息的id
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getCommentWithId:(NSString*)anID page:(int)pageCount onSucceeded:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/***
 *  发表评论
 *
 *  @param  anID  信息的id
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)writeCommentWithId:(iLIBComment*)aComment onSucceeded:(VoidBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求书友圈信息数据
 *
 *  @param  type        0:我的圈子  1:广场
 *  @param  pageCount   帖子页数
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getBookCircleMessageWithType:(int)type page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求圈子信息数据
 *
 *  @param  circleId    圈子Id
 *  @param  pageCount   帖子页数
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getBookCircleMessageWithId:(int)circleId page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求书友圈评论数据
 *
 *  @param  resId       帖子Id
 *  @param  pageCount   评论列表页数
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getBookCircleCommentWithType:(int)resId page:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求书友圈圈子数据
 *
 *  @param  pageCount   圈子列表页数
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)getBookCircleItemWithPage:(int)pageCount onSuccess:(SuccessBlock)successBlock onError:(ErrorBlock)errorBlock;
/***
 *  退出登录
 *
 *  @param  succeedBlock    调用成功回调
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (id)logout:(VoidBlock)succeedBlock onError:(ErrorBlock)errorBlock;
/**
 *  请求AppItems
 *
 *  @param  successBlock    调用成功回调,返回字典
 *  @param  errorBlock  调用失败回调
 *
 *  @since  1.0
 */
- (void)requestAppItems:(SuccessDict)successBlock onError:(ErrorBlock)errorBlock;

@end
