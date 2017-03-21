//
//  Command.m
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import "Command.h"

@implementation Command

/// 初始化
+(Command*) newCmdWithUrl:(NSString*)url withCmd:(NSString*)cmd;
{
    return [self newCmdWithUrl:url withCmd:cmd withPageNo:0];
}

/// 初始化
+(Command*) newCmdWithUrl:(NSString*)url withCmd:(NSString*)cmd withPageNo:(int)pageno;
{
    Command* tCmd = [[self alloc] init];
    tCmd.cmd = cmd?cmd:@"unknown";
    tCmd.url = url;
    tCmd.pageno = 0;
    return tCmd;
}

-(id) init
{
    self = [super init];
    self.cmd = @"unknown";
    self.pageno = 0;
    
    self.isRefresh = NO;
    self.isWaiting = YES;
    self.needCache = YES;
    
    return self;
}

-(NSString*)cachePath
{
    // 不为空 直接返回
    if (_cachePath) {
        return _cachePath;
    }
    
    // 为空创建
    NSString* name = self.cmd;
#ifdef DEBUG
    name = [name stringByAppendingString:@".json"];
#endif
    _cachePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",name];
    return _cachePath;
}

/// 设置回调
-(void) setRespCallback:(CMDBlock)callback;
{
    self.callback = callback;
}

@end

@implementation BaseRespModel

/// 字典 -> model
+(id)modelWithDic:(id)dic;
{
    // 凡是用子类 调用父类 静态方法(+号方法), 而且需要创建对象, 都用 [[self class] alloc]
    id model = [[[self class] alloc] init];
    
    // ------ 每个项目自己的处理
    if (dic) {
        // 设置是否成功
        [model setIsSuccess:YES];
        // 设置返回状态码
        [model setRespCode:0];
    }
    
    // 解析自己属性 -> 由子类 自己去完成
    [model parseValue:dic];
    return model;
}

-(id) init
{
    self = [super init];
    self.isSuccess = NO;
    self.respCode = -1;
    return self;
}

/// 给自己属性赋值
-(void) parseValue:(id)value;
{
    NSLog(@"该方法需要子类自己处理");
    self.respInfo = value;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"%@| Code=%d | isSuccess = %d",self.class,self.respCode,self.isSuccess];
}

@end
