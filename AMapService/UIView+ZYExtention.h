//
//  UIView+ZYExtention.h
//  UniteRoute
//
//  Created by zz on 2016/12/1.
//  Copyright © 2016年 Klaus. All rights reserved.
//test

#import <UIKit/UIKit.h>
@protocol ZYViewExtentionDelegate;
@interface UIView (ZYExtention)
+ (UIView*)viewWithTitle:(NSString*)title titleFont:(UIFont*)titleFont titleColor:(UIColor*)titleColor subTitle:(NSString*)subTitle subTitleFont:(UIFont*)subTitleFont subTitltColor:(UIColor*)subTitltColor;
+ (UIView *)addSeparatorLineBelow:(BOOL)below view:(UIView *)view toParentView:(UIView*)parentView margin:(CGFloat)margin leftMargin:(CGFloat)leftMargin rightMargin:(CGFloat)rightMargin height:(CGFloat)height;

+ (UIView *)addSeparatorLineRight:(BOOL)right toView:(UIView *)view parentView:(UIView*)parentView margin:(CGFloat)margin topMargin:(CGFloat)topMargin bottomMargin:(CGFloat)bottomMargin width:(CGFloat)width;

+ (UIView*)viewWithTitle:(NSString*)title leftSubTitle:(NSString*)leftSubTitle rightSubTitle:(NSString*)rightSubTitle colors:(NSArray<UIColor*>*)colors fonts:(NSArray<UIFont*>*)fonts;

+ (CGFloat)labelHeightWithAttributes:(NSDictionary*)attrDic line:(NSUInteger)lineNum;
@end
@protocol ZYViewExtentionDelegate <NSObject>

- (void)buttonItemClicked:(UIButton*)button;
@end

