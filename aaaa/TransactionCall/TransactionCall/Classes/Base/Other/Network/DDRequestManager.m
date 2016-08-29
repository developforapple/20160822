//
//  DDRequestManager.m
//  QuizUp
//
//  Created by Normal on 15/6/18.
//  Copyright (c) 2015年 Bo Wang. All rights reserved.
//

//#import "ServerConfig.h"
#import "DDRequestManager.h"
#import <AFNetworkActivityIndicatorManager.h>
//#import "SinaUser.h"
#import "AFHTTPSessionManager+Parameters.h"

BOOL
judgeResultState(id object){
    BOOL success = NO;
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSInteger result = [object[@"result"] integerValue];
        if (result == 0) {
            success = YES;
        }else if (result == 1){

        }else if (result == 2){
            
//            if ([DDUSM myStatus] != DDUserStatus_Invalid) {
//                [DDUSM invalidateMe];
//            }
        }
    }
    return success;
}

DDTASK *
DDPOST(NSString *uri,
       NSDictionary * param,
       DDRequestSuccess success,
       DDRequestFailure failure){
    return [DDREQUEST.manager POST:uri parameters:param success:^(DDTASK *task, id object) {
        if ([task task_isCanceled]) return;
        success?success(task,object,judgeResultState(object)):1;
    } failure:^(DDTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}

DDTASK *
DDPOSTDATA(NSString *uri,
           NSDictionary * param,
           NSDictionary * bodyData,
           DDRequestSuccess success,
           DDRequestFailure failure){
    return [DDREQUEST.manager POST:uri parameters:param bodyData:bodyData success:^(DDTASK *task, id object) {
        if ([task task_isCanceled]) return;
        success?success(task,object,judgeResultState(object)):1;
    } failure:^(DDTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}

DDTASK *
DDGET(NSString *uri,
      NSDictionary * param,
      DDRequestSuccess success,
      DDRequestFailure failure){
    return [DDREQUEST.manager GET:uri parameters:param success:^(DDTASK *task, id object) {
        if ([task task_isCanceled]) return;
        success?success(task,object,judgeResultState(object)):1;
    } failure:^(DDTASK *task, NSError *error) {
        if ([task task_isCanceled]) return;
        failure?failure(task,error):1;
    } presetParameterEnabled:YES];
}

@implementation DDRequestManager
{
    NSMutableDictionary *_requestTimeConsumingRecord;
}
+ (instancetype)sharedManager
{
    static DDRequestManager *sharedLRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLRequestManager = [[DDRequestManager alloc] init];
        sharedLRequestManager->_manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self server]]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [[AFNetworkActivityIndicatorManager sharedManager] setActivationDelay:0.4f];
        
        [sharedLRequestManager startMonitoringNetworkingTimeConsuming];
    });
    return sharedLRequestManager;
}

+ (NSString *)server
{
    return @"";
}

+ (NSString *)picServer
{
    return @"";
}

#pragma mark - Monitoring
- (void)startMonitoringNetworkingTimeConsuming
{
#if !DDRelease
    _requestTimeConsumingRecord = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:@"com.alamofire.networking.nsurlsessiontask.resume" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:@"com.alamofire.networking.nsurlsessiontask.suspend" object:nil];
#endif
}

- (void)stopMonitoringNetworkingTimeConsuming
{
#if !DDRelease
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"com.alamofire.networking.nsurlsessiontask.resume"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"com.alamofire.networking.nsurlsessiontask.suspend"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:AFNetworkingTaskDidCompleteNotification];
#endif
}

- (NSString *)requestURLFromAFNetworkingNotification:(NSNotification *)notification
{
    if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        NSString *URL = [[[(NSURLSessionTask *)[notification object] originalRequest] URL] absoluteString];
        URL = [[URL componentsSeparatedByString:@"?"] firstObject];
        return URL;
    } else {
        return nil;
    }
}

- (void)networkRequestDidStart:(NSNotification *)noti
{
    NSString *URL = [self requestURLFromAFNetworkingNotification:noti];
    if (URL) {
        _requestTimeConsumingRecord[URL] = @([[NSDate date] timeIntervalSince1970]);
    }
}

- (void)networkRequestDidFinish:(NSNotification *)noti
{
    NSString *URL = [self requestURLFromAFNetworkingNotification:noti];
    if (URL) {
        NSTimeInterval startTime = [_requestTimeConsumingRecord[URL] doubleValue];
        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
        _requestTimeConsumingRecord[URL] = nil;
        
        // 包括数据解析的时间
//        NSLog(@"2:%@ 请求耗时 %.2f 秒",URL,curTime-startTime);
    }
}

#pragma mark - Tools
- (DDTASK *)fetchAppTools:(DDRequestSuccess)success
                  failure:(DDRequestFailure)failure
{
    return DDGET(@"app/tools", nil, success, failure);
}

#pragma mark - Home
- (DDTASK *)fetchHomeFeedList:(NSNumber *)lastQid
                      success:(DDRequestSuccess)success
                      failure:(DDRequestFailure)failure
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"qid"] = lastQid;
    return DDGET(@"post/feed/list", param, success, failure);
}

@end