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

/**
 *  响应者链条到此被button拦截，如果不调用[super touchBegin:]就只有button响应这个touch事件
 *
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.selected = !self.selected;
    self.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                         // 分发事件
                         
                        id target = self.allTargets.anyObject;
                         
                        NSString *actionStr = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].lastObject;
                         
                         [self sendAction:NSSelectorFromString(actionStr) to:target forEvent:event];
                         
                     }];

}


@end
