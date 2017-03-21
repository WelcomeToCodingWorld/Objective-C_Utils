//
//  NetManager.h
//  IODemo
//
//  Created by LiuTao on 16/5/11.
//  Copyright © 2016年 ZhiYou. All rights reserved.
//

#define HAS_AFNETWORKING 1

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

/// 网络请求
@interface NetManager : NSObject

/// GET请求
+(void) doGetWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;

/// POST请求
+(void) doPostWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;

#ifdef HAS_AFNETWORKING

/// AF->GET请求
+(void) doAFGetWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;

/// AF->POST请求
+(void) doAFPostWithUrl:(NSString*)url withParams:(id)params withHeaders:(id)headers callback:(void(^)(id item))callback;

#endif
@end
