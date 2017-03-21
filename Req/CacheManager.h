//
//  CacheManager.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CacheManager : NSObject

/// 启动时间
@property (nonatomic, assign) NSTimeInterval launchTime;

/// 启动默认配置
+(void) initCache;

/// 中间大管家
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/// 负责维护表结构 - 自己用不着
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
/// 负责维护 数据持久化 - 自己用不着
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// 保存数据
- (void)saveContext;
/// Documents的URL路径
- (NSURL *)applicationDocumentsDirectory;

+(CacheManager*) getInstance;

@end
