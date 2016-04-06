//
//  HTSelectedCounterButton.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/6.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTSelectedCounterButton.h"
#import "HTImagePickerGlobl.h"

@implementation HTSelectedCounterButton


- (void)setCount:(NSInteger)count{
    
    _count = count;
    
    [self setTitle:[NSString stringWithFormat:@"%zd",_count] forState:UIControlStateNormal];
    BOOL isHidden = count <= 0;
    
    self.transform = CGAffineTransformMakeScale(0.2,0.2);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.transform = CGAffineTransformIdentity;
                         self.hidden = isHidden;
                     } completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        NSBundle *mainBundle = [NSBundle bundleForClass:[self class]];
        
        NSURL *url = [mainBundle URLForResource:HTImagePickerBundleName withExtension:nil];
        
        NSBundle *imageBundle = [NSBundle bundleWithURL:url];
        
        UIImage *image = [UIImage imageNamed:@"number_icon" inBundle:imageBundle compatibleWithTraitCollection:nil];
        
        [self setBackgroundImage:image forState:UIControlStateNormal];
        
        [self setTitle:@"0" forState:UIControlStateNormal];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.hidden = YES;
        
        [self sizeToFit];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}
@end
