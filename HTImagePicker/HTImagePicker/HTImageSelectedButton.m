//
//  HTImageSelectedButton.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImageSelectedButton.h"

NSString *const HTImagePickerBundleName = @"HTImagePickerBundle.bundle";

@implementation HTImageSelectedButton

- (instancetype)initWithImageName:(NSString *)imageName selectedName:(NSString *)selectedName{

    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        // 这里获取的就是mainBundle
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
        
        NSURL *imageBundleUrl = [mainBundle URLForResource:HTImagePickerBundleName withExtension:nil];
        
        NSBundle *imageBundle = [NSBundle bundleWithURL:imageBundleUrl];
        
        UIImage *normalImage = [UIImage imageNamed:imageName inBundle:imageBundle compatibleWithTraitCollection:nil];
        [self setImage:normalImage forState:UIControlStateNormal];
        
        UIImage *selectedImage = [UIImage imageNamed:selectedName inBundle:imageBundle compatibleWithTraitCollection:nil];
        
        [self setImage:selectedImage forState:UIControlStateSelected];
        
        [self sizeToFit];

    }
    return self;
}
@end
