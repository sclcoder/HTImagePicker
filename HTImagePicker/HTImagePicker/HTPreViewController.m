//
//  HTPreViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/6.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTPreViewController.h"
#import "HTSelectedCounterButton.h"
#import "HTPictureViewController.h"
#import "HTImageSelectedButton.h"

@interface HTPreViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property (nonatomic, strong) HTImageSelectedButton *selectedButton;

@end

@implementation HTPreViewController

{
    UIPageViewController *_pageViewController;
    
    /// 相册模型
    HTAlbum *_album;
    
    /// 预览的素材数组
    NSMutableArray <PHAsset *> *_previewAssets;
    
    /// 最大选择图像数量
    NSInteger _maxPickerCount;

    /// 完成按钮
    UIBarButtonItem *_doneItem;
    /// 选择计数按钮
    HTSelectedCounterButton *_counterButton;
}

- (instancetype)initWithAlbum:(HTAlbum *)album
               selectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount
                    indexPath:(NSIndexPath *)indexPath{
    
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        
        _album = album;
        
        _maxPickerCount = maxPickerCount;
        
        _previewAssets = selectedAssets;
        
        [self preparePageViewControllerWithIndex:indexPath.item];
    }
    
    return self;
}

#pragma mark - viewLifeCricle
- (void) viewDidLoad{
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self prepareNavigationBarAndToolBar];
}

- (void)prepareNavigationBarAndToolBar{
    
    // navBar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectedButton];
    
    // toolBar

}

- (HTImageSelectedButton *)selectedButton{
    
    if (_selectedButton == nil) {
        _selectedButton = [[HTImageSelectedButton alloc]
                           initWithImageName:@"check_box_default"
                           selectedName:@"check_box_right"];
        [_selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}

- (void)selectedButtonClick:(HTImageSelectedButton *)selectedButton{

    NSLog(@"%s",__func__);
}

#pragma mark - privateMethod

- (void)preparePageViewControllerWithIndex:(NSInteger)index{
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey:@(20)};
    
    // 分页控制器
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options:options];
    _pageViewController.view.backgroundColor = [UIColor blueColor];
    
    
    NSArray *viewControllers = @[[self pictureViewControllerWithIndex:index]];
    // Set visible view controllers, optionally with animation. Array should only include view controllers that will be visible after the animation has completed.
    
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    // 注意！！将pageViewController 加到本控制器的viewControllers数组中
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;

}

- (HTPictureViewController *)pictureViewControllerWithIndex:(NSInteger)index{

    HTPictureViewController *pictureVc = [[HTPictureViewController alloc] init];
    pictureVc.index = index;
    pictureVc.asset = [self assetWithIndex:index];
    return pictureVc;
}

- (PHAsset *)assetWithIndex:(NSInteger)index{
    
   return [_album assetWithIndex:index];
}


#pragma mark - UIPageViewController dataSource

// 一下两个方法--当滑动一触发就会调用数据源方法

// 返回前一页控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    return [self pictureViewControllerWithshowingController:viewController isNext:NO];
}
// 返回下一页控制器
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{

    return [self pictureViewControllerWithshowingController:viewController isNext:YES];
}

- (HTPictureViewController *)pictureViewControllerWithshowingController:(UIViewController *)viewController isNext:(BOOL)isNext{
    
    HTPictureViewController *detailVc = (HTPictureViewController *)viewController;

    NSInteger index = detailVc.index;

    index += isNext ? 1 : -1;
    if (index < 0 || index > _album.count - 1) {
        return nil;
    } else {
        return [self pictureViewControllerWithIndex:index];
    }
}


#pragma mark - UIPageViewController delegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
//    NSLog(@"%@",pendingViewControllers);
}
@end
