//
//  UIButton+Operate.m
//  UniteRoute
//
//  Created by zz on 2016/12/1.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import "UIButton+Operate.h"
static NSString* operateKey = @"ZZOperateKey";
@implementation UIButton (Operate)
- (FooterButtonType)operateType{
    return [objc_getAssociatedObject(self, &operateKey) integerValue];
}

- (void)setOperateType:(FooterButtonType)operateType{
    objc_setAssociatedObject(self, &operateKey, @(operateType), OBJC_ASSOCIATION_ASSIGN);
}
@end
