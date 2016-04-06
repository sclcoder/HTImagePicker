//
//  HTAlbum.m
//  HTImagePicker
//
//  Created by mac on 16/3/27.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTAlbum.h"

@implementation HTAlbum{

    /**
     *  当前相册资源集合
     */
    PHAssetCollection *_assetCollection;
    /**
     *  当前相册内的资源查询结果
     */
    PHFetchResult *_fetchResult;

}
///  使用了readonly不会生成setter 又重写了getter 这时没法访问_desc 使用synthesize 生成_desc一个私有的成员变量
@synthesize desc = _desc;

+ (instancetype)albumWithAssetCollection:(PHAssetCollection *)assetCollection{
    
    return [[self alloc] initWithCollection:assetCollection];
}

- (instancetype)initWithCollection:(PHAssetCollection *)assetCollection{
    
    self = [super init];
    if (self) {
        
        // PHAsset -> mediaType
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
        
        // PHAsset -> creationDate
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
        _assetCollection = assetCollection;
        
        /**
         *  查询当前相册中的资源-PHAsset
         */
        _fetchResult = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:option];
    }
    return self;
}

#pragma - mark 只读属性
- (NSString *)title{
    return _assetCollection.localizedTitle;
}

- (NSInteger)count{
    return _fetchResult.count;
}

- (NSAttributedString *)desc{
    
    // 相册描述
    if (_desc == nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        
        [attributedString appendAttributedString:
         [[NSAttributedString alloc] initWithString:_assetCollection.localizedTitle]
         ];
        [attributedString appendAttributedString:
         [[NSAttributedString alloc]
          initWithString:[NSString stringWithFormat:@"\n%zd", _fetchResult.count]
          attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}]
         ];
        
        _desc = attributedString.copy;
    }
    return _desc;

}

#pragma - mark  HTAlbum提供的接口实现

- (PHAsset *)assetWithIndex:(NSInteger)index{
    
    if ( index < 0 || index >= _fetchResult.count) {
        return nil;
    }
    return _fetchResult[index];
}

- (UIImage *)emptyImageWithSize:(CGSize)size{
    
    UIGraphicsBeginImageContext(size);
    // 先设置颜色
    [[UIColor redColor] setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// 根据index获取image
- (void)requestThumbnailWithAssetIndex:(NSInteger)index size:(CGSize)size withCompletion:(HTAlbumCompletion)complition{
    
    PHAsset *asset = _fetchResult[index];
    [[PHImageManager defaultManager]
     requestImageForAsset:asset
     targetSize:[self sizeMutliplyScale:size]
     contentMode:PHImageContentModeAspectFill
     options:[self imageRequestOptions]
     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         complition(result);
     }];

}

// 获取3张缩略图
- (void)request3ThumbnailWithSize:(CGSize)size withCompletion:(HTAlbumCompletion)complition{
    
    NSMutableArray *images = [NSMutableArray array];
    
    CGSize imageSize = [self sizeMutliplyScale:size];
    
    PHImageRequestOptions *options = [self imageRequestOptions];

    // gcd组
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 3 && i < (_fetchResult.count - 1); i++) {
        
        PHAsset *asset = _fetchResult[i];

        dispatch_group_enter(group);
        
        // 此方法设置为异步
        [[PHImageManager defaultManager]
         requestImageForAsset:asset
         targetSize:imageSize
         contentMode:PHImageContentModeAspectFill
         options:options
         resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

             [images addObject:result];
             // 异步任务完成后离开gcd组
             dispatch_group_leave(group);
         }];
    }
    
    // 所有异步任务都完成后进行回调  -- 全局队列
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        UIImage *resultImage = [self thumbnailWithImages:images size:imageSize];

        // 在主线程上赋值
        dispatch_async(dispatch_get_main_queue(), ^ {complition(resultImage); });

    });
    
}

- (CGSize)sizeMutliplyScale:(CGSize)size{

    CGFloat scale = [UIScreen mainScreen].scale;
    
    return CGSizeMake(size.width * scale, size.height * scale);
}

- (PHImageRequestOptions *)imageRequestOptions{
    
    // 影响图片质量 大小
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];

    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    options.synchronous = NO;
    
    return options;
}

/// 使用图像数组生成层叠的缩略图
///
/// @param images 图像数组
/// @param size   图像尺寸
///
/// @return 层叠缩略图

// 将三张图叠加到一块
- (UIImage *)thumbnailWithImages:(NSArray <UIImage *> *)images size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat margin = 3.0 * [UIScreen mainScreen].scale;
    NSInteger index = 0;
    for (UIImage *image in images.reverseObjectEnumerator) {
        
        CGContextSaveGState(ctx);
        
        CGFloat top = index * margin;
        index++;
        CGFloat left = (images.count - index) * margin;
        
        UIRectClip(CGRectMake(left, top, size.width - left * 2, size.height - top));
        
        CGFloat x = (size.width - image.size.width) * 0.5;
        CGFloat y = (size.height - image.size.height) * 0.5;
        
        CGRect rect = CGRectMake(x, y, image.size.width, image.size.height);
        
        [image drawInRect:rect];
        
        CGContextRestoreGState(ctx);
    }
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}

@end
