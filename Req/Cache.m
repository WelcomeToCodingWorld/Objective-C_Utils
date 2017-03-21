//
//  Cache.m
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import "Cache.h"
#import "Command.h"
#import <QuartzCore/QuartzCore.h>
#import "CacheManager.h"

@implementation Cache

/// 获取缓存: cmd
+(id) getCacheWithCmd:(Command*)cmd;
{
    // 判断机制 1.缓存当次APP启动有效 2.缓存24小时内有效
    // 可以是当前时间
    // 可以是应用启动时间

    // 创建查询器
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Cache"];
    // 设置筛选条件
    id cmdName = cmd.cmd;
    int pageno = cmd.pageno;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self.cmd=%@ AND pageno==%d",cmdName,pageno];
    // 执行查询
    id result = [[CacheManager getInstance].managedObjectContext executeFetchRequest:fetchRequest error:nil];
    // 判断是否有效
    if ([result count] <1) {
        return nil;
    }
    
    Cache* c = result[0];
    // 缓存策略: 档次启动APP有效
    if (c.dateVer > [CacheManager getInstance].launchTime) {
        return c;
    }
    
    return nil;
}

/// 保存缓存: cmd
+(void) savaCacheWithCmd:(Command*)cmd;
{
    // 插入记录
    Cache* ca = [NSEntityDescription insertNewObjectForEntityForName:@"Cache" inManagedObjectContext:[CacheManager getInstance].managedObjectContext];
    // 设置值
    ca.cmd = cmd.cmd;
    ca.pageno = cmd.pageno;
    ca.dateVer = CACurrentMediaTime();
    
    [[CacheManager getInstance] saveContext];
}

@end