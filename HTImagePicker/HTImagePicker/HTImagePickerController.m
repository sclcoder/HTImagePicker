//
//  HTImagePickerController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImagePickerController.h"
#import "HTAlbumsTableViewController.h"


@interface HTImagePickerController ()
{
    HTAlbumsTableViewController *_rootViewController;
    NSMutableArray <PHAsset *> *_selectedAssets;
}
@end

@implementation HTImagePickerController

- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    self = [super init];
    if (self) {
        
        if (selectedAssets) {
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        } else{
            _selectedAssets = [NSMutableArray array];
        }
        
        _rootViewController = [[HTAlbumsTableViewController alloc] init];

        // 默认最多选中9张照片 封装在init放中 外部可以自己设定
        self.maxPickerCount = 9;
        
        [self pushViewController:_rootViewController animated:NO];
    }
    return self;
}

- (instancetype)init{
    
    // #define NSAssert(condition, desc, ...) 当condition为真时 程序继续执行为假时抛出异常
    NSAssert(NO,@"请调用 `-initWithSelectedAssets:`");
    return nil;
}

#pragma - mark setter和getter



@end
