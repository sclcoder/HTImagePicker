//
//  HTImageGridViewLayout.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImageGridViewLayout.h"

/// 最大 Cell 宽高 --- 展示相册cell的宽高影响着图片的targetSize从而影响获取图片质量和获取速度
#define HTGridCellMinWH 104

@implementation HTImageGridViewLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat margin = 2;
    CGFloat ItemHW = [self itemWHWithCount:3 margin:margin];
    // The minimum spacing to use between items in the same row
    self.minimumInteritemSpacing = margin;
    // The minimum spacing to use between lines of items in the grid.
    self.minimumLineSpacing = margin;
    
    self.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);

    self.itemSize = CGSizeMake(ItemHW, ItemHW);
}

- (CGFloat)itemWHWithCount:(NSInteger)count margin:(CGFloat)margin{
    
    CGFloat itemWH = 0;
    CGSize size = self.collectionView.bounds.size;
    // 固定间隙marin itemHW变化
    do {
        itemWH = floor((size.width - (count + 1) * margin) / count);
        count++;
    } while (itemWH > HTGridCellMinWH);
    return itemWH;
}

@end
