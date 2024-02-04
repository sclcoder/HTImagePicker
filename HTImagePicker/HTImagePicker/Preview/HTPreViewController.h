//
//  HTPreViewController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/6.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAlbum.h"

@protocol HTPreViewControllerDelegate;

@interface HTPreViewController : UIViewController

- (instancetype)initWithAlbum:(HTAlbum *)album
               selectedAssets:(NSMutableArray<PHAsset *>*)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount
                    indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,weak) id<HTPreViewControllerDelegate> delegate;

@end

@protocol HTPreViewControllerDelegate <NSObject>
/**
 *  HTPreViewController代理方法
 *
 *  @param previewVc 预览控制器
 *  @param asset     一个图片资源
 *  @param selected  选中状态
 *
 *  @return 是否允许选中
 */
- (BOOL)preViewController:(HTPreViewController *)previewVc didChangeAsset:(PHAsset *)asset selected:(BOOL)selected;


@end