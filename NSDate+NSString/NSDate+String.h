//
//  NSDate+String.h
//  CarTransactionService1_0
//
//  Created by Li on 16/7/2.
//  Copyright © 2016年 ZhiZiKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)
/**
 *  时间输入字符串格式为2016.07.02 12:00
 */
-(NSString *)stringValue;
/**
 *  时间字符串格式必须为2016.07.02 12:00
 */
+ (instancetype)dateWithTimeString:(NSString *)time;
@property (nonatomic,assign,readonly)int hour;
@property (nonatomic,copy,readonly)NSString *dateTime;
@property (nonatomic,assign,readonly)int minite;
@property (nonatomic,copy,readonly)NSString *time;
+(NSString *)dateCode;//为数据库生成唯一标识符
+(NSString *)weekDate;
@end
