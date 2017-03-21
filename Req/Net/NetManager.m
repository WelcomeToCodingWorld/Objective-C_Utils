//
//  NetManager.m
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import "NetManager.h"
#import "AFNetworking.h"

@implementation NetManager

/// GET请求
+(void) doGetWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;
{
    // url 转码 -> 防止特殊字符出现在url中
    NSString *address = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 如果 url中没有包含 ? 添加
    if ([address rangeOfString:@"?"].location == NSNotFound) {
        address = [address stringByAppendingString:@"?"];
    }
    // 添加参数
    for (NSString* key in [params allKeys])
    {
        address = [address stringByAppendingFormat:@"&%@=%@",key,params[key]];
    }
    
    // 创建 request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:address]];
    request.HTTPMethod = @"GET";

    // header处理
    for (NSString* key in [headers allKeys])
    {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    
    // 创建一个任务
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        id str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"=> 网络请求返回数据 \n %@ \n",str);
        if (callback) {
            callback(str);
        }
    }];
    // 创建完 任务默认是被挂起, 需要手动启动
    [task resume];
}


/// POST请求
+(void) doPostWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;
{
    // url 转码 -> 防止特殊字符出现在url中
    NSString *address = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 如果 url中没有包含 ? 添加
    if ([address rangeOfString:@"?"].location == NSNotFound) {
        address = [address stringByAppendingString:@"?"];
    }
    
    // 创建 request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:address]];
    
    // 添加参数 -> json
    NSData* reqData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPBody = reqData;
    request.HTTPMethod = @"POST";
    
    // header处理
    for (NSString* key in [headers allKeys])
    {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    
    // 创建一个任务
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        if (callback) {
            callback(data);
        }
    }];
    // 创建完 任务默认是被挂起, 需要手动启动
    [task resume];
}

#pragma mark - -------- AFNetworking ----------

#ifdef HAS_AFNETWORKING
/// AF->GET请求
+(void) doAFGetWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@|class=%@|%@", response,[responseObject class],responseObject);
        }
    }];
    [dataTask resume];
}

/// AF->POST请求
+(void) doAFPostWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;
{
    
}

#endif

@end
