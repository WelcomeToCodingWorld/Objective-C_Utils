//
//  Command.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseRespModel;

typedef void(^CMDBlock)(id item);


@interface Command : NSObject

// --------- 固定的数据配置

/// url
@property (nonatomic,copy)NSString* url;
/// 命令字
@property (nonatomic,copy)NSString* cmd;
/// 页数
@property (nonatomic,assign)int pageno;

/// 请求参数
@property (nonatomic,copy)id reqParams;
/// 请求Header
@property (nonatomic,copy)id reqHeaders;
// 本地缓存路径 cachePath(会自动生成)
@property (nonatomic,copy)NSString* cachePath;

// ------------ 逻辑处理

/// 是否需要缓存 (修改密码)
@property (nonatomic,assign)BOOL needCache;

/// 是否强制取网络数据 (列表下拉刷新)
@property (nonatomic,assign)BOOL isRefresh;

/// 是否需要显示 Loading (提交日志类)
@property (nonatomic,assign)BOOL isWaiting;

/// callback
@property (nonatomic,copy)CMDBlock callback;

/// 设置回调
-(void) setRespCallback:(CMDBlock)callback;

/// 初始化
+(Command*) newCmdWithUrl:(NSString*)url withCmd:(NSString*)cmd;
/// 初始化
+(Command*) newCmdWithUrl:(NSString*)url withCmd:(NSString*)cmd withPageNo:(int)pageno;



@end

#pragma mark - ******** BaseRespModel ********

@interface BaseRespModel : NSObject

/// 是否请求成功
@property (nonatomic,assign)BOOL isSuccess;
/// 返回状态码
@property (nonatomic,assign)int respCode;


/// 当子类没有实现 parseValue 方法 或者没有子类 返回的数据放在 respInfo 中
@property (nonatomic,strong)id respInfo;

/// 字典 -> model
+(id)modelWithDic:(id)dic;

/// 给自己属性赋值
-(void) parseValue:(id)value;

@end