//
//  ImagePickerView.m
//  UniteRoute
//
//  Created by zz on 2016/12/8.
//  Copyright © 2016年 Klaus. All rights reserved.
//test

#import "ImagePickerView.h"
#define KEdgeWidth 15
@interface ImagePickerView ()
{
    UIView* _photosView;
}

@property (nonatomic,assign)CGFloat verticalSpace;
@property (nonatomic,assign)CGFloat verticalEdgeInset;
@property (nonatomic,assign)CGFloat horizontalEdgeInset;
@property (nonatomic,assign)CGFloat itemWidth;
@property (nonatomic,assign)CGFloat HWRatio;
@property (nonatomic,assign)NSInteger itemsPerRow;
@property (nonatomic,assign)NSInteger maxPhotosNumber;
@property (nonatomic,retain)UIButton* photoAddButton;
@end
@implementation ImagePickerView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialize];
        [self setupView];
    }
    return self;
}

- (void)initialize{
    self.imageViewsArr = @[].mutableCopy;
    self.verticalSpace = 12;
    self.verticalEdgeInset = KEdgeWidth;
    self.horizontalEdgeInset = 12;
    self.itemWidth = 80;
    self.itemsPerRow = 4;
    self.HWRatio = 1;
    self.maxPhotosNumber = 4;
}

- (instancetype)initWithMaxPhotosNumber:(NSInteger)maxPhotosNumber{
    self = [super init];
    if (self) {
        [self initialize];
        self.maxPhotosNumber = maxPhotosNumber;
        [self setupView];
    }
    return self;
}


- (instancetype)initWithMaxPhotosNumber:(NSInteger)maxPhotosNumber itemsPerRow:(NSInteger)itemsPerRow{
    self = [super init];
    if (self) {
        [self initialize];
        self.maxPhotosNumber = maxPhotosNumber;
        self.itemsPerRow = itemsPerRow;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    [self addImageViewForPhotosView];
}

- (void)addImageViewForPhotosView{
    if (_imageViewsArr.count == self.maxPhotosNumber) {
        _imageViewsArr.lastObject.userInteractionEnabled = YES;
        [_photoAddButton removeFromSuperview];
        _photoAddButton = nil;
        return;
    }
    UIImageView* imageView = [UIImageView new];
    imageView.layer.borderColor = [UIColor colorWithHexString:@"#dcdcdc"].CGColor;
    imageView.layer.borderWidth = 1;
    if (self.currentImageView) {
        self.currentImageView.userInteractionEnabled = YES;
    }
    
    self.currentImageView = imageView;
    
    [_imageViewsArr addObject:imageView];
    
    [self addSubview:imageView];
    
    imageView.sd_layout.autoHeightRatio(1);
    
    UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(edit:)];
    longPressGesture.minimumPressDuration = 0.5;
    longPressGesture.allowableMovement = 5;
    [imageView addGestureRecognizer:longPressGesture];
    [self layoutPhotosView];
}

- (UIButton *)photoAddButton{
    if (!_photoAddButton) {
        _photoAddButton = [UIButton buttonAddTarget:self action:@selector(imagePick) withTitle:nil imageNamed:@"js_camera"];
        [self addSubview:_photoAddButton];
        _photoAddButton.sd_layout
        .widthIs(44)
        .heightIs(44);
        
    }
    return _photoAddButton;
}

#pragma mark-- Public
- (void)setVerticalSpace:(CGFloat)verticalSpace verticalEdgeInset:(CGFloat)verticalEdgeInset horizontalEdgeInset:(CGFloat)horizontalEdgeInset itemWidth:(CGFloat)itemWidth HWRatio:(CGFloat)hwRatio maxPhotosNumber:(NSInteger)maxPhotosNumber{
    self.verticalSpace = verticalSpace;
    self.verticalEdgeInset = verticalEdgeInset;
    self.horizontalEdgeInset = horizontalEdgeInset;
    self.HWRatio = hwRatio;
    self.itemWidth = itemWidth;
    self.maxPhotosNumber = maxPhotosNumber;
}

- (void)layoutPhotosView{
    CGFloat horizontalSpace = (kScreenWidth - 2*self.horizontalEdgeInset - self.itemsPerRow*self.itemWidth)/(self.itemsPerRow - 1);
    
    UIView* lastView = self;
    NSInteger index = 0;
    for (UIImageView* imageView in self.imageViewsArr) {
        if (index <= self.itemsPerRow - 1) {
            if (index == 0) {
                imageView.sd_resetLayout
                .leftSpaceToView(lastView,KEdgeWidth)
                .topSpaceToView(lastView,self.verticalEdgeInset)
                .heightIs(self.itemWidth*self.HWRatio)
                .widthIs(self.itemWidth);
            }else{
                imageView.sd_resetLayout
                .leftSpaceToView(lastView,horizontalSpace)
                .topEqualToView(lastView)
                .heightIs(self.itemWidth*self.HWRatio)
                .widthIs(self.itemWidth);
            }
        }else{
            NSInteger idx = index - self.itemsPerRow;
            lastView = [self.imageViewsArr objectAtIndex:idx];
            imageView.sd_resetLayout
            .leftEqualToView(lastView)
            .rightEqualToView(lastView)
            .topSpaceToView(lastView,self.verticalEdgeInset)
            .heightIs(self.itemWidth*self.HWRatio);
        }
        index ++;
        lastView = imageView;
    }
    [self setupAutoHeightWithBottomView:self.imageViewsArr.lastObject bottomMargin:self.verticalEdgeInset];

    self.photoAddButton.sd_layout
    .centerXEqualToView(self.imageViewsArr.lastObject)
    .centerYEqualToView(self.imageViewsArr.lastObject);
    
    [self layoutSubviews];
}

#pragma mark-- RespondSelector
- (void)edit:(UILongPressGestureRecognizer*)gesture{
    self.edit = YES;
    if ([self.delegate respondsToSelector:@selector(imagePickerView:editWithGesture:imageViewsArr:)]) {
        [self.delegate imagePickerView:self editWithGesture:gesture imageViewsArr:self.imageViewsArr];
    }
}

- (void)imagePick{//选择照片或拍照
    self.edit = NO;
    if ([self.delegate respondsToSelector:@selector(imagePickerView:pickImageWithCurrentImageView:)]) {
        [self.delegate imagePickerView:self pickImageWithCurrentImageView:self.imageViewsArr.lastObject];
    }
}
                                      
@end
