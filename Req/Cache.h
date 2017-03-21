//
//  Cache.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


//NS_ASSUME_NONNULL_BEGIN

@class Command;
@interface Cache : NSManagedObject

/// 获取缓存: cmd
+(id) getCacheWithCmd:(Command*)cmd;

/// 保存缓存: cmd
+(void) savaCacheWithCmd:(Command*)cmd;


@end

//NS_ASSUME_NONNULL_END

#import "Cache+CoreDataProperties.h"

