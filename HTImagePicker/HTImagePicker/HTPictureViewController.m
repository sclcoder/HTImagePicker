//
//  HTPictureViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/7.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTPictureViewController.h"

@implementation HTPictureViewController

{
    UIImageView *_imageView;
}

- (void)setAsset:(PHAsset *)asset{

    _asset = asset;

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = NO;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    
    [[PHImageManager defaultManager] requestImageForAsset:_asset
                                               targetSize:[UIScreen mainScreen].bounds.size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                _imageView.image = result;
                                            }];

}


- (void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    _imageView = [[UIImageView alloc] init];
    
    _imageView.backgroundColor = [UIColor yellowColor];
    
    _imageView.frame = self.view.bounds;
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:_imageView];
}


@end
