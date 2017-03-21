//
//  Cache+CoreDataProperties.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cache.h"

//NS_ASSUME_NONNULL_BEGIN

@interface Cache (CoreDataProperties)

//@property (nullable, nonatomic, retain) NSString *path;
@property (nonatomic) NSTimeInterval dateVer;
@property (nonatomic, retain) NSString *cmd;
@property (nonatomic) int16_t pageno;

@end

//NS_ASSUME_NONNULL_END
