//
//  HTImagePickerController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImagePickerController.h"
#import "HTAlbumsTableViewController.h"
#import "PHAsset+select.h"
/// 全局常量
NSString *const HTImagePickerBundleName = @"HTImagePickerBundle.bundle";
NSString *const HTImagePickerSelectedNotification = @"HTImagePickerSelectedNotification";

@interface HTImagePickerController ()
{
    HTAlbumsTableViewController *_rootViewController;
    NSMutableArray <PHAsset *> *_selectedAssets;
}
@end

@implementation HTImagePickerController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HTImagePickerSelectedNotification object:nil];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    self = [super init];
    if (self) {
        
        if (selectedAssets) {            
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        } else{
            _selectedAssets = [NSMutableArray array];
        }
        
        _rootViewController = [[HTAlbumsTableViewController alloc] initWithSelectedAssets:_selectedAssets];

        // 默认最多选中9张照片 封装在init放中 外部可以自己设定
        self.maxPickerCount = 9;
        
        [self pushViewController:_rootViewController animated:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishSelectedAssets:)
                                                     name:HTImagePickerSelectedNotification
                                                   object:nil];
    }
    return self;
}

- (void)didFinishSelectedAssets:(NSNotification *)notification{
    
    
    if (![self.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishSelectedImages:selectedAssets:)]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];

        return;
    }
    
    [self  requestImages:_selectedAssets completed:^(NSArray<UIImage *> *images) {
       
        [self.pickerDelegate imagePickerController:self
                           didFinishSelectedImages:images
                                    selectedAssets:_selectedAssets];

    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (instancetype)init{
    
    // #define NSAssert(condition, desc, ...) 当condition为真时 程序继续执行为假时抛出异常
    NSAssert(NO,@"请调用 `-initWithSelectedAssets:`");
    return nil;
}

#pragma - mark setter和getter

- (void)setMaxPickerCount:(NSInteger)maxPickerCount{
    
    _rootViewController.maxPickerCount = maxPickerCount;
}

- (NSInteger)maxPickerCount{
    
    return _rootViewController.maxPickerCount;
}


#pragma mark - 请求图像方法 -- 核心方法

/// 根据 PHAsset 数组，统一查询用户选中图像
///
/// @param selectedAssets 用户选中 PHAsset 数组
/// @param completed      完成回调，缩放后的图像数组在回调参数中

- (void)requestImages:(NSArray <PHAsset *> *)selectedAssets completed:(void (^)(NSArray <UIImage *> *images))completed {
    
    
    /// 图像请求选项
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    // 设置 resizeMode 可以按照指定大小缩放图像
    
    /** PHImageRequestOptionsResizeModeFast:
     Photos efficiently resizes the image to a size similar to, or slightly larger than, the target size.
     */
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    // 设置 deliveryMode 为 HighQualityFormat 可以只回调一次缩放之后的图像，否则会调用多次
    /** deliveryMode:
     Use this property to tell Photos to provide an image quickly (possibly sacrificing image quality), to provide a high-quality image (possibly sacrificing speed), or to provide both automatically if needed. See PHImageRequestOptionsDeliveryMode.
     
     PHImageRequestOptionsDeliveryModeHighQualityFormat:
     Photos provides only the highest-quality image available, regardless of how much time it takes to load.
     */
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // 设置加载图像尺寸(以像素为单位)
    CGSize targetSize = self.targetSize;
    
    NSMutableArray <UIImage *> *images = [NSMutableArray array];
    
    // gcd组 ：可以知道所有异步任务都执行完成
    dispatch_group_t group = dispatch_group_create();
    
    for (PHAsset *asset in selectedAssets) {
        
        dispatch_group_enter(group);
        
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:targetSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             
             [images addObject:result];
             dispatch_group_leave(group);
         }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completed(images.copy);
    });
}


#pragma mark - UINavigationController 父类方法

/// 处理toolBar的显示与隐藏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.toolbarHidden = [viewController isKindOfClass:[HTAlbumsTableViewController class]];
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    self.toolbarHidden = self.viewControllers.count == 1;
    return viewController;
}


@end
