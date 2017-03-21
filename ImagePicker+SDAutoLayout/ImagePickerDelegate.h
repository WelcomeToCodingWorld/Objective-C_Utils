//
//  ImagePickerDelegate.h
//  UniteRoute
//
//  Created by zz on 2016/12/8.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerView.h"
@protocol ImagePickerDelegateDelegate;
@interface ImagePickerDelegate : NSObject<ImagePickerViewDelegate>
@property (nonatomic,retain)UIViewController* imagePickerVC;
@property (nonatomic,assign)id<ImagePickerDelegateDelegate> delegate;
@property (nonatomic,retain)UIImageView* currentImageView;
@property (nonatomic,retain)ImagePickerView* imagePickerView;
@end

@protocol ImagePickerDelegateDelegate <NSObject>
@optional
- (void)takePhotoWithCurrentImageView:(UIImageView*)imageView;
- (void)choosePictureFromPhotoLibraryWithCurrentImageView:(UIImageView*)imageView;
@end
