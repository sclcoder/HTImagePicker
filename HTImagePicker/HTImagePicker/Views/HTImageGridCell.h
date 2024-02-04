//
//  HTImageGridCell.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTImageSelectedButton.h"

@protocol HTImageGridCellDelegate;

/// 多图选择视图cell
@interface HTImageGridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) HTImageSelectedButton *seletedButton;

@property (nonatomic, weak)  id<HTImageGridCellDelegate> gridCellDelegate;

@end

@protocol HTImageGridCellDelegate <NSObject>
/// 图像 Cell 选中事件
///
/// @param cell     图像 cell
/// @param selected 是否选中
- (void)gridCell:(HTImageGridCell *)cell didSelected:(BOOL)selected;

@end
