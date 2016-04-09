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
#import "PHAsset+select.h"
#import "HTImagePickerGlobl.h"

@interface HTPreViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

/**
 *  这里写成属性的方式 是为了访问getter
 */
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
        
        NSInteger index = (indexPath != nil) ? indexPath.item : 0;
        
        [self preparePageViewControllerWithIndex:index];
        
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
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc]
                                   initWithTitle:@"取消"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancleItemClick:)];
    cancleItem.enabled = YES;

    _counterButton = [[HTSelectedCounterButton alloc] init];
    UIBarButtonItem *countItem = [[UIBarButtonItem alloc] initWithCustomView:_counterButton];
    
    _doneItem = [[UIBarButtonItem alloc]
                 initWithTitle:@"完成"
                 style:UIBarButtonItemStylePlain
                 target:self
                 action:@selector(doneItemClick:)];
    _doneItem.enabled = YES;

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil
                                  action:nil];
    
    self.toolbarItems = @[cancleItem,spaceItem,countItem,_doneItem];
    
    [self updateCounter];
    
}

- (void)updateCounter{
    
    _counterButton.count = _previewAssets.count;

}

- (void)cancleItemClick:(UIBarButtonItem *)cancleItem{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)doneItemClick:(UIBarButtonItem *)doneItem{
 
    [[NSNotificationCenter defaultCenter] postNotificationName:HTImagePickerSelectedNotification object:self userInfo:nil];
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

- (void)selectedButtonClick:(HTImageSelectedButton *)button{
    
    // 选中asset
    if ([self.delegate respondsToSelector:@selector(preViewController:didChangeAsset:selected:)]) {
        
        // 获取当前展示的asset
        HTPictureViewController *picVc = _pageViewController.viewControllers.lastObject;

        // 回调代理方法---此代理方法有返回值
        BOOL canSelected = [self.delegate preViewController:self didChangeAsset:[self assetWithIndex:picVc.index] selected:button.selected];
        
        [self updateCounter];
        
        // 如果不能再选中了就取消选中
        if (!canSelected) {
            
            button.selected = !button.selected;
        }
        
    }
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
    
    // runtime
    PHAsset *asset = [self assetWithIndex:index];
    self.selectedButton.selected = asset.selected ;
    
    
    
    
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

// 将要过渡时调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    HTPictureViewController *picVc = (HTPictureViewController *)pendingViewControllers.lastObject;
    PHAsset *asset = [self assetWithIndex:picVc.index];
    self.selectedButton.selected = asset.selected;
    
}

// 当animation结束的时候调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    // 注意:这里使用的是 _pageViewController.viewControllers.lastObject 就是当前正在显示的控制器
    
    HTPictureViewController *picVc = _pageViewController.viewControllers.lastObject;
    PHAsset *asset = [self assetWithIndex:picVc.index];
    self.selectedButton.selected = asset.selected;

}


@end
