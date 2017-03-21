//
//  ImagePickTestViewController.m
//  UniteRoute
//
//  Created by zz on 2016/12/8.
//  Copyright © 2016年 Klaus. All rights reserved.
//

#import "ImagePickTestViewController.h"
#import "ImagePickerView.h"
#import "ImagePickerDelegate.h"
@interface ImagePickTestViewController ()<ImagePickerDelegateDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,retain)ImagePickerDelegate* delegate;
@property (nonatomic,retain)UIImagePickerController* imagePickerController;
@property (nonatomic,retain)UIImageView* currentImageView;
@property (nonatomic,retain)ImagePickerView* photosView;
@property (nonatomic,retain)NSMutableArray* photosArr;
@end

@implementation ImagePickTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self setupNav];
    [self setupView];
}
#pragma mark- Private For View Creaating
- (void)initialize{
    self.photosArr = @[].mutableCopy;
    self.imagePickerController = [UIImagePickerController new];
    self.imagePickerController.delegate = self;
}
- (void)setupNav{
    self.title = @"PhotoTakingTest";
}

- (void)setupView{
    self.photosView = [ImagePickerView new];
    [self.view addSubview:self.photosView];

    self.photosView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topSpaceToView(self.view,100);
    
    self.delegate = [ImagePickerDelegate new];
    self.delegate.imagePickerVC = self;
    self.delegate.delegate = self;
    self.photosView.delegate = self.delegate;
}



#pragma mark-- ImagePickerDelegateDelegate
- (void)takePhotoWithCurrentImageView:(UIImageView *)imageView{
    self.currentImageView = imageView;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)choosePictureFromPhotoLibraryWithCurrentImageView:(UIImageView *)imageView{
    self.currentImageView = imageView;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark-- UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        UIImage* theImage = nil;
        if ([picker allowsEditing]) {
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
//        [_photosArr addObject:theImage];
        self.currentImageView.image = theImage;
        
        //将图片保存到相册
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            SEL selectorToCall = @selector(imageWasSavedSuccessfully: didFinishSavingWithError: contextInfo:);
            UIImageWriteToSavedPhotosAlbum(theImage, self, selectorToCall, NULL);
        }
        
        
        [self.photosView addImageViewForPhotosView];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageWasSavedSuccessfully:(UIImage*)paramImage didFinishSavingWithError:(NSError*)paramError contextInfo:(void*)paramContextInfo{
    if (!paramError) {
        NSLog(@"Image was saved successfully!");
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    KSLog(@"Memory Warning!");
}
@end
