//
//  ReqManager.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Command.h"

/// 对请求做处理
@interface ReqManager : NSObject

/// 处理请求
+(void) doRequest:(Command*) cmd;

@end


