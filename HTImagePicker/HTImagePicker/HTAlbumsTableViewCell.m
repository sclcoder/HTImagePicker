//
//  HTAlbumsTableViewCell.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTAlbumsTableViewCell.h"

@implementation HTAlbumsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        
        self.textLabel.numberOfLines = 0;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整image 和 label的位置
    
    CGRect rect = self.contentView.bounds;
    
    CGFloat iconMargin = 8.0;
    CGFloat iconWH = rect.size.height - 2 * iconMargin;
    self.imageView.frame = CGRectMake(iconMargin, iconMargin, iconWH, iconWH);
    
    CGFloat labelMargin = 12.0;
    CGFloat labelX = iconMargin + iconWH + labelMargin;
    CGFloat labelW = rect.size.width - labelX - labelMargin;
    self.textLabel.frame = CGRectMake(labelX, iconMargin, labelW, iconWH);
}

#pragma mark - 设置数据
- (void)setAlbum:(HTAlbum *)album {

    _album = album;
    
    self.textLabel.attributedText = _album.desc;
    
    CGSize imageSize = CGSizeMake(80, 80);
    // 设置空白图像
    self.imageView.image = [album emptyImageWithSize:imageSize];
    
    // 异步获取缩略图
    [album request3ThumbnailWithSize:imageSize withCompletion:^(UIImage *thumbnail) {
        
        self.imageView.image = thumbnail;
        
    }];
}

@end
