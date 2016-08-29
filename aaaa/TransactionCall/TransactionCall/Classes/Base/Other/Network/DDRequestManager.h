//
//  DDRequestManager.h
//  QuizUp
//
//  Created by Normal on 15/6/18.
//  Copyright (c) 2015年 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+Parameters.h"
#import "AFNetworking.h"

#define DDREQUEST [DDRequestManager sharedManager]

typedef NSURLSessionDataTask DDTASK;

/**
 *  服务器有响应时的回调
 *
 *  @warning
 *
 *  @param operation      AF对象
 *  @param object 响应体，result字段一定为 0。如果suc为NO，那么object为nil。
 *  @param suc     是否成功，由于在下一层AF的success回调会被截取，当响应体里result字段不为0时，suc为NO，result为0时，suc为YES
 */
typedef void(^DDRequestSuccess)(DDTASK *task,id object,BOOL suc);

/**
 *  服务器连接失败时的回调
 *  @warning
 *
 *  @param operationm AF对象
 *  @param error      AF生成的error
 */
typedef void(^DDRequestFailure)(DDTASK *task,NSError *error);

DDTASK * DDPOST(NSString *uri,
                NSDictionary *  param,
                DDRequestSuccess  success,
                DDRequestFailure  failure);
DDTASK * DDPOSTDATA(NSString *uri,
                    NSDictionary *  param,
                    NSDictionary *  bodyData,
                    DDRequestSuccess  success,
                    DDRequestFailure  failure);
DDTASK * DDGET(NSString *uri,
               NSDictionary *  param,
               DDRequestSuccess  success,
               DDRequestFailure  failure);

@interface DDRequestManager : NSObject
+ (instancetype)sharedManager;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;

#pragma mark - Tool
- (DDTASK *)fetchAppTools:(DDRequestSuccess)success
                  failure:(DDRequestFailure)failure;

#pragma mark - Home
/**
 *  获取首页动态列表
 *
 *  @param lastQid 分页是的上一条内容的id
 *  @param success
 *  @param failure
 *
 *  @return
 */
- (DDTASK *)fetchHomeFeedList:(NSNumber *)lastQid
                      success:(DDRequestSuccess)success
                      failure:(DDRequestFailure)failure;


@end
