//
//  PHAsset+select.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/7.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "PHAsset+select.h"
#import <objc/runtime.h>

@implementation PHAsset (select)

const char SelectKey;

- (void)setSelected:(BOOL)selected{
    
    NSString *selectedStr = [NSString stringWithFormat:@"%zd",selected];
    
    objc_setAssociatedObject(self, &SelectKey,selectedStr, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)selected{
    
    NSString *selectedStr = objc_getAssociatedObject(self, &SelectKey);
    
    return selectedStr.boolValue;
}


@end
