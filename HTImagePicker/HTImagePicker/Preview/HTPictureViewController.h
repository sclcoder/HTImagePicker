//
//  HTPictureViewController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/7.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

/// 负责展示图片放大缩小
@interface HTPictureViewController : UIViewController

/// 图像索引
@property (nonatomic) NSUInteger index;
/// 图像资源
@property (nonatomic) PHAsset *asset;

@end
