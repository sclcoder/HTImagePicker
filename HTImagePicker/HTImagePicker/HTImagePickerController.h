//
//  HTImagePickerController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImagePickerController : UINavigationController

// 最多选几张
@property (nonatomic, assign) NSInteger maxPickerCount;

// 加载图像尺寸
@property (nonatomic, assign) NSInteger targetSize;


@end
