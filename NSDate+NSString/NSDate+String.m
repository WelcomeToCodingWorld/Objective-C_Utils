//
//  NSDate+String.m
//  CarTransactionService1_0
//
//  Created by Li on 16/7/2.
//  Copyright © 2016年 ZhiZiKeJi. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)
@dynamic hour,dateTime,minite,time;
-(NSString *)stringValue {
    NSLocale* local =[NSLocale autoupdatingCurrentLocale];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale: local];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time = [formater stringFromDate:self];
    return time;
}
+ (instancetype)dateWithTimeString:(NSString *)time {
    NSLocale* local =[NSLocale autoupdatingCurrentLocale];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale: local];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate* date = [formater dateFromString:time];
    return date;
}
-(int)hour {
    NSArray *timeArr = [self.time componentsSeparatedByString:@":"];
    return [timeArr.firstObject intValue];
}
- (NSString *)dateTime {
    NSString *date = [self stringValue];
    NSArray *arr = [date componentsSeparatedByString:@" "];
    return arr.firstObject;
}
-(NSString *)time {
    NSString *date = [self stringValue];
    NSArray *arr = [date componentsSeparatedByString:@" "];
    NSString *time = arr.lastObject;
    return time;
}
- (int)minite {
    NSArray *timeArr = [self.time componentsSeparatedByString:@":"];
    return [timeArr.lastObject intValue];
}
+(NSString *)dateCode {
    NSLocale* local =[NSLocale autoupdatingCurrentLocale];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale: local];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *time = [formater stringFromDate:[NSDate date]];
    return time;
}
+(NSString *)weekDate {
    NSLocale* local =[NSLocale autoupdatingCurrentLocale];
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale: local];
    [formater setDateFormat:@"EEE"];
    NSString *time = [formater stringFromDate:[NSDate date]];
    return time;
}
@end
