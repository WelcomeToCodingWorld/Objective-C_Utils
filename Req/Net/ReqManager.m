//
//  ReqManager.m
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import "ReqManager.h"
#import "NetManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Cache.h"

// 缓存的根目录 如:Documents
#define CACHE_ROOT_PATH @"123123"

@implementation ReqManager

//4.请求 -> 先判断 -> 在获取
//-> 本地 -> 返回 -> UI
//-> 网络 -> 网络请求米快 -> 存储 -> 返回 -> UI

/// 处理请求
+(void) doRequest:(Command*) cmd;
{
    // 判断索引  是否有效|| 是否存在
    BOOL hasCache = NO;
    NSString* respStr;
    
    // 取缓存索引
    Cache* cache = [Cache getCacheWithCmd:cmd];
    hasCache = cache!=nil;
    
    if (hasCache) {
        // 读取缓存,处理
        NSString* path = cmd.cachePath;
        
        // 获取文件内容
        respStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (!respStr) {
            hasCache = NO;
        }
    }

    // 判断是否需要缓存 || 判断是否是刷新类 (强制获取网络) || 是否有缓存
    if (!cmd.needCache || cmd.isRefresh || !hasCache) {
        // 网络获取
        [NetManager doGetWithUrl:cmd.url withParams:cmd.reqParams withHeaders:cmd.reqHeaders callback:^(id item) {
            // 请求完成后的处理
            [self requestFinish:item cmd:cmd];
        }];
        return;
    }
    
    // 本地获取的,就不用再写入了
    cmd.needCache = NO;
    NSLog(@"=> 本地读取返回数据 \n %@ \n",respStr);
    [ReqManager requestFinish:respStr cmd:cmd];
}


/// 处理请求完成
+(void) requestFinish:(NSString*)respStr cmd:(Command*)cmd
{
    // 判断需要写缓存
    if (cmd.needCache) {
        // 写文件
        [respStr writeToFile:cmd.cachePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        // 保存索引
        [Cache savaCacheWithCmd:cmd];
    }
    // 解析 -> 字典
    id respData = [respStr dataUsingEncoding:NSUTF8StringEncoding];
    id value = [NSJSONSerialization JSONObjectWithData:respData options:NSJSONReadingMutableContainers error:nil];
    // 字典 -> BaseRespModel
    BaseRespModel* model = [BaseRespModel modelWithDic:value];
    
    // 最终的回调
    if (cmd.callback) {
        cmd.callback(model);
    }
}

@end
