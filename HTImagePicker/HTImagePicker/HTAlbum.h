//
//  HTAlbum.h
//  HTImagePicker
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface HTAlbum : NSObject

/**
 *  构造函数
 *
 *  @param assetCollection 一个资源合集
 *
 *  @return 相册模型
 */
+ (instancetype)albumWithAssetCollection:(PHAssetCollection *)assetCollection;

@end
