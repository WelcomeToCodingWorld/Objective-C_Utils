//
//  UIButton+Operate.h
//  UniteRoute
//
//  Created by zz on 2016/12/1.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,FooterButtonType){
    FooterButtonTypeProductDetail = 0,
    FooterButtonTypeToComment = 1,
    FooterButtonTypeToPay = 2,
    FooterButtonTypeLookPickUpCode = 3,
    FooterButtonTypeToLookLogistics = 4,
    FooterButtonTypeConfirmToReceipt = 5,
    FooterButtonTypePurchaseAgain = 6
};
@interface UIButton (Operate)
@property (nonatomic,assign)FooterButtonType operateType;
@end
