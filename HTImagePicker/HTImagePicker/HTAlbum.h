//
//  HTAlbum.h
//  HTImagePicker
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

typedef void(^HTAlbumCompletion)(UIImage * thumbnail);

@interface HTAlbum : NSObject

/**
 *  构造函数
 *
 *  @param assetCollection 一个资源合集
 *
 *  @return 相册模型
 */
+ (instancetype)albumWithAssetCollection:(PHAssetCollection *)assetCollection;

/// 相册标题
@property (nonatomic, readonly) NSString *title;
/// 相册描述 readonly不会生成 setter 又重写了getter ？？
@property (nonatomic, readonly) NSAttributedString *desc;
/// 照片数量
@property (nonatomic, readonly) NSInteger count;

/**
 *  获取空白图像
 */
- (UIImage *)emptyImageWithSize:(CGSize)size;

/**
 *  获取缩略图3张 用来展示一个相册的外表
 */
- (void)request3ThumbnailWithSize:(CGSize)size withCompletion:(HTAlbumCompletion)complition;

/// 请求指定资源索引的缩略图
///
/// @param index      资源索引
/// @param size       缩略图尺寸
/// @param completion 完成回调
- (void)requestThumbnailWithAssetIndex:(NSInteger)index size:(CGSize)size withCompletion:(HTAlbumCompletion)complition;


@end
