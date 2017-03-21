//
//  UIImage+CustomImageBundle.h
//  SDAutoLayoutTest
//
//  Created by ari 李 on 16/10/2016.
//  Copyright © 2016 ari 李. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger){
    imageTypeJpg,
    imageTypeIcon,
    imageTypePng,
    imageTypeNone
}imageType;


@interface UIImage (CustomImageBundle)
+ (instancetype)imageFromCustomBundle:(NSString *)bundleName Named:(NSString *)imageName imageType:(imageType)imageType;
@end
