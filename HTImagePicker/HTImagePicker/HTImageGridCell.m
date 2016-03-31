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
        
        
        // 方案1 target是控制器 按钮seletedButton内部拦截touch事件
        [self.seletedButton addTarget:self action:@selector(seletedButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 方案2 targer是nil 这时会沿着响应者链条寻找实现action的对象 在此方案中在selectedButton内部实现action 这样按钮内部不需要在touch方法中做事情 直接在action中处理
//        [self.seletedButton addTarget:self.seletedButton action:@selector(seletedButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _seletedButton;
}

- (void)seletedButtonDidClick:(HTImageSelectedButton *)button{
    
    NSLog(@"%s",__func__);
}

@end
