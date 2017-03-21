//
//  ImagePickerView.h
//  UniteRoute
//
//  Created by zz on 2016/12/8.
//  Copyright © 2016年 Klaus. All rights reserved.
//test

#import <UIKit/UIKit.h>
@protocol  ImagePickerViewDelegate;
@interface ImagePickerView : UIView


@property (nonatomic,retain)UIImageView* currentImageView;
@property (nonatomic,assign)id<ImagePickerViewDelegate> delegate;
@property (nonatomic,retain)NSMutableArray<UIImageView*>* imageViewsArr;
@property (nonatomic,assign)BOOL edit;




/**
 布局ImageView
 */
- (void)layoutPhotosView;


/**
 设置基本属性

 @param verticalSpace       照片竖直间距
 @param verticalEdgeInset   照片竖直间隙
 @param horizontalEdgeInset 照片水平间隙
 @param itemWidth           照片宽度
 @param hwRatio             高宽比
 */
- (void)setVerticalSpace:(CGFloat)verticalSpace verticalEdgeInset:(CGFloat)verticalEdgeInset horizontalEdgeInset:(CGFloat)horizontalEdgeInset itemWidth:(CGFloat)itemWidth HWRatio:(CGFloat)hwRatio maxPhotosNumber:(NSInteger)maxPhotosNumber;


/**
 继续添加新的照片
 */
- (void)addImageViewForPhotosView;

/**
 以最大照片数初始化实例

 @param maxPhotosNumber 最大照片数
 @return 返回一个新的实例
 */
- (instancetype)initWithMaxPhotosNumber:(NSInteger)maxPhotosNumber;

/**
 用最大照片数和每行的照片数初始化实例

 @param maxPhotosNumber 最大照片数
 @param itemsPerRow 每行的照片数
 @return 一个新的实例
 */
- (instancetype)initWithMaxPhotosNumber:(NSInteger)maxPhotosNumber itemsPerRow:(NSInteger)itemsPerRow;
@end

@protocol  ImagePickerViewDelegate<NSObject>
- (void)imagePickerView:(ImagePickerView*)imagePickerView pickImageWithCurrentImageView:(UIImageView*)currentImageView;

- (void)imagePickerView:(ImagePickerView*)imagePickerView editWithGesture:(UILongPressGestureRecognizer *)gesture imageViewsArr:(NSMutableArray<UIImageView *> *)imageViewsArr;


@end

