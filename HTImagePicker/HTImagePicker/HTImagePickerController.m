//
//  HTImagePickerController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTImagePickerController.h"
#import "HTAlbumsTableViewController.h"

/// 全局常量
NSString *const HTImagePickerBundleName = @"HTImagePickerBundle.bundle";

@interface HTImagePickerController ()
{
    HTAlbumsTableViewController *_rootViewController;
    NSMutableArray <PHAsset *> *_selectedAssets;
}
@end

@implementation HTImagePickerController

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithSelectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    self = [super init];
    if (self) {
        
        if (selectedAssets) {
            _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        } else{
            _selectedAssets = [NSMutableArray array];
        }
        
        _rootViewController = [[HTAlbumsTableViewController alloc] initWithSelectedAssets:_selectedAssets];

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

- (void)setMaxPickerCount:(NSInteger)maxPickerCount{
    
    _rootViewController.maxPickerCount = maxPickerCount;
}

- (NSInteger)maxPickerCount{
    
    return _rootViewController.maxPickerCount;
}

#pragma mark - UINavigationController 父类方法

/// 处理toolBar的显示与隐藏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.toolbarHidden = [viewController isKindOfClass:[HTAlbumsTableViewController class]];
    [super pushViewController:viewController animated:animated];
    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    UIViewController *viewController = [super popViewControllerAnimated:animated];
    self.toolbarHidden = self.viewControllers.count == 1;
    return viewController;
}


@end
