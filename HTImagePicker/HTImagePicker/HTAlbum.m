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

@end
