//
//  CacheManager.m
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import "CacheManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation CacheManager
#pragma mark - Core Data stack


/// 启动默认配置
+(void) initCache;
{
    [self getInstance].launchTime = CACurrentMediaTime();
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.zhiyou.CoreDataDemo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// 表结构
- (NSManagedObjectModel *)managedObjectModel {
    
    // 理解UIViewController 生命周期
    // 不为空,直接返回
    // 为空 -> 创建
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    // 获取 "CoreDataDemo.momd" 文件路径
    // CoreDataDemo.xcdatamodeld 编译后 -> CoreDataDemo.momd (xib 编译后 -> nib)
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Cache" withExtension:@"momd"];
    // 用该路径,初始化 一个 NSManagedObjectModel 赋值给自己
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// 二进制文件存储
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // 懒加载,不为空,直接返回
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // 创建 NSPersistentStoreCoordinator 对象
    // 用 表结构(managedObjectModel) 创建
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    // 获取 最终二进制文件存储的路径
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalCache.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    // 设置存储: 存储的文件类型,存储配置类型:nil 文件存储地址
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

// 上下文
- (NSManagedObjectContext *)managedObjectContext {
    
    // 懒加载
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // 获取文件存储对象
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    // 初始化上下文
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    // 设置关联存储对象
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

/// 保存操作,  此操作会更新到二进制文件 (所有的增删改查,都要保存)
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

static CacheManager* kInstance;
+(CacheManager*) getInstance{
    if (!kInstance) {
        kInstance = [[CacheManager alloc] init];
    }
    return kInstance;
}

@end
