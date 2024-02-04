//
//  HTImageSelectedButton.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImageSelectedButton.h"
#import "HTImagePickerGlobl.h"


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
//        self.userInteractionEnabled = NO;

    }
    return self;
}


// 方案1 action 交给了控制器处理 按钮的动画处理拦截了touch事件处理
//
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    // 如果不调用super 按钮内部将touch事件拦截  API:重写touch方法时一定要调用super
    // 其实不重写touch方法 button也会将事件拦截 应为默认firstResponser
    [super touchesBegan:touches withEvent:event];
    
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
     
                       // 如果不调用super 此处只有代码告诉target触发action
                       // 分发事件--此时target并不是通过外部触发而是内部通过码触发UIControlEventTouchUpInside
//                        id target = self.allTargets.anyObject;
//
//                        NSString *actionStr = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside].lastObject;
//
//                         [self sendAction:NSSelectorFromString(actionStr) to:target forEvent:event];

                     }];

}


// 方案2 响应者链条找到处理action的对象是selectedButton
//- (void)seletedButtonDidClick:(HTImageSelectedButton *)button{
//    
//    NSLog(@"%s",__func__);
//    
//        self.selected = !self.selected;
//        self.transform = CGAffineTransformMakeScale(0.2, 0.2);
//        [UIView animateWithDuration:0.25
//                              delay:0
//             usingSpringWithDamping:0.5
//              initialSpringVelocity:0
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             self.transform = CGAffineTransformIdentity;
//                         }
//                         completion:nil];
//}

@end
