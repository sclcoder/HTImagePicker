//
//  HTImagePickerController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Photos;

/**
 *  协议声明
 */
@protocol HTImagePickerControllerDelegate;


@interface HTImagePickerController : UINavigationController


/**
 *  构造函数
 *
 *  @param selectedAssets 选中素材数组 用来记录预览之前选中的图片资源集合
 *
 *  @return 图片选择控制器
 */

- (instancetype)initWithSelectedAssets:(NSArray <PHAsset *> *)selectedAssets;

/**
 *   图像选择代理 - 这里代理的名字 不要定义delegate 与导航控制器的delegate冲突
 */

@property(nonatomic,weak) id<HTImagePickerControllerDelegate> pickerDelegate;

/**
 *   最多选几张 默认9张
 */
@property (nonatomic, assign) NSInteger maxPickerCount;

/**
 *  加载图像尺寸 默认(600 * 600)
 */
@property (nonatomic, assign) CGSize targetSize;

@end

/**
 *  图像选择协议
 */
@protocol HTImagePickerControllerDelegate <NSObject>

@optional
/**
 *  图像选择完成方法
 *
 *  @param pickerController 图像选择控制器
 *  @param images           选择的图片数组
 *  @param selectedAssets   选中的素材数组 方便重新定位图像
 */
- (void)imagePickerController:(HTImagePickerController *)pickerController
      didFinishSelectedImages:(NSArray <UIImage *> *)images
               selectedAssets:(NSArray <PHAsset *> *)selectedAssets;

@end




