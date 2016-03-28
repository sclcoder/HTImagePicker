//
//  HTImageGridViewController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAlbum.h"

@interface HTImageGridViewController : UICollectionViewController

/// 构造函数
///
/// @param album          相册模型
/// @param selectedAssets 选中资源数组
/// @param maxPickerCount 最大选择数量
///
/// @return 多图选择控制器

- (instancetype)initWithAlbum:(HTAlbum *)album
               selectedAssets:(NSMutableArray <PHAsset *> *)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount;

@end
