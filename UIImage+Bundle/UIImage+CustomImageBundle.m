//
//  UIImage+CustomImageBundle.m
//  SDAutoLayoutTest
//
//  Created by ari 李 on 16/10/2016.
//  Copyright © 2016 ari 李. All rights reserved.
//

#import "UIImage+CustomImageBundle.h"
NSString * const ImageTypeDescription[] = {
    [imageTypeJpg] = @"jpg",
    [imageTypeIcon] = @"icon",
    [imageTypePng] = @"png",
    [imageTypeNone] = nil
};
@implementation UIImage (CustomImageBundle)
+ (instancetype)imageFromCustomBundle:(NSString *)bundleName Named:(NSString *)imageName imageType:(imageType)imageType{
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:bundleName ofType:@"bundle"];
    NSBundle *customBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [customBundle pathForResource:imageName ofType:ImageTypeDescription[imageType]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
@end
