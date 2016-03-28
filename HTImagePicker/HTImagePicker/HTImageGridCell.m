//
//  HTImageGridCell.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImageGridCell.h"

@implementation HTImageGridCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.seletedButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    CGFloat offsetX = self.bounds.size.width - _seletedButton.bounds.size.width;
    _seletedButton.frame = CGRectOffset(_seletedButton.bounds,offsetX, 0);

}


- (UIImageView *)imageView{
    
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (HTImageSelectedButton *)seletedButton{
    if (_seletedButton == nil) {
        _seletedButton = [[HTImageSelectedButton alloc]
                          initWithImageName:@"check_box_default"
                          selectedName:@"check_box_right"];
        
        [self.seletedButton addTarget:self action:@selector(seletedButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _seletedButton;
}

- (void)seletedButtonDidClick:(HTImageSelectedButton *)button{
    
    NSLog(@"%s",__func__);
}

@end
