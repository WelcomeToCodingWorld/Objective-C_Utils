//
//  UIImage+Color.m
//  CarTransactionService1_0
//
//  Created by Li on 16/6/28.
//  Copyright © 2016年 ZhiZiKeJi. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+ (instancetype) imageWithColor: (UIColor*) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
