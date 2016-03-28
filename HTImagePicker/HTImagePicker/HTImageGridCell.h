//
//  HTImageGridCell.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTImageSelectedButton.h"

@interface HTImageGridCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) HTImageSelectedButton *seletedButton;


@end
