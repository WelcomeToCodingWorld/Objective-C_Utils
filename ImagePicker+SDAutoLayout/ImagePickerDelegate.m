//
//  ImagePickerDelegate.m
//  UniteRoute
//
//  Created by zz on 2016/12/8.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import "ImagePickerDelegate.h"

@implementation ImagePickerDelegate

#pragma mark-- ImageViewDelegate
- (void)imagePickerView:(ImagePickerView*)imagePickerView editWithGesture:(UILongPressGestureRecognizer *)gesture imageViewsArr:(NSMutableArray<UIImageView *> *)imageViewsArr{
    UIImageView* imageView =  (UIImageView*)gesture.view;
    self.currentImageView = imageView;
    kWeakSelf(weakSelf);
    
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"编辑照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSInteger index = [imageViewsArr indexOfObject:imageView];
        if (index == imageViewsArr.count - 1) {
            imageView.image = nil;
        }else{
            if (imageViewsArr.count > 1) {
                if (!imageViewsArr.lastObject.image) {
                    [imageView removeFromSuperview];
                }else{
                    imageView.image = nil;
                    [imageViewsArr addObject:imageView];
                }
                [imageViewsArr removeObjectAtIndex:index];
            }
        }
        
        //重新布局，photosView
        [imagePickerView layoutPhotosView];
    }];
    
    
    UIAlertAction* chooseAction = [UIAlertAction actionWithTitle:@"重新选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf imagePickerView:imagePickerView pickImageWithCurrentImageView:imageView];
    }];
    
    
    deleteAction.enabled = imageViewsArr.count>1;
    [alertVC addAction:deleteAction];
    [alertVC addAction:chooseAction];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    if (!alertVC.beingPresented) {
        [self.imagePickerVC presentViewController:alertVC animated:YES completion:nil];
    }
}

- (void)imagePickerView:(ImagePickerView*)imagePickerView pickImageWithCurrentImageView:(UIImageView*)currentImageView{
    self.currentImageView = currentImageView;
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"上传照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]&&[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {//后置摄像头且支持拍照
            if ([self.delegate respondsToSelector:@selector(takePhotoWithCurrentImageView:)]) {
                [self.delegate takePhotoWithCurrentImageView:currentImageView];
            }
        }else{
            [KSAlert weakAlertShowInViewCotroller:self.imagePickerVC withMessage:@"您的摄像头不可用,或不支持拍照"];
            
        }
    }];
    
    kWeakSelf(weakSelf);
    UIAlertAction* choosePhotoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]&&[self cameraSupportsMedia:(NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera]) {//相册可用
            if ([self.delegate respondsToSelector:@selector(choosePictureFromPhotoLibraryWithCurrentImageView:)]) {
                [self.delegate choosePictureFromPhotoLibraryWithCurrentImageView:currentImageView];
            }
        }else{
            [KSAlert weakAlertShowInViewCotroller:weakSelf.imagePickerVC withMessage:@"您的相册不可用"];
        }
    }];
    
    [alertVC addAction:takePhotoAction];
    [alertVC addAction:choosePhotoAction];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    if (!alertVC.beingPresented) {
        [self.imagePickerVC presentViewController:alertVC animated:YES completion:nil];
    }
}


- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    
    __block BOOL result = NO;
    
    if ([paramMediaType length] == 0){
        
        KSLog(@"Media type is empty.");
        
        return NO;
        
    }
    
    NSArray *availableMediaTypes =[UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    
    [availableMediaTypes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop) {
        
        NSString *mediaType = (NSString *)obj;
        
        if ([mediaType isEqualToString:paramMediaType]){
            
            result = YES;
            
            *stop= YES;
        }
        
    }];
    return result;
}
@end
