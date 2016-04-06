//
//  HTImageGridViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.

#import "HTImageGridViewController.h"
#import "HTImageGridCell.h"
#import "HTImageGridViewLayout.h"
#import "HTSelectedCounterButton.h"

static NSString * const HTImageGridViewCellIdentifier = @"HTImageGridViewCellIdentifier";

@interface HTImageGridViewController () <HTImageGridCellDelegate>
{
    
    HTAlbum *_album;
    
    NSMutableArray *_selectedAssets;
    
    NSInteger _maxPickerCount;
    // 预览
    UIBarButtonItem *_preViewItem;
    // 完成
    UIBarButtonItem *_doneItem;
    
    HTSelectedCounterButton *_counterButton;
}
@end

@implementation HTImageGridViewController

- (void)dealloc{
    
    NSLog(@"%s",__func__);
}

- (instancetype)initWithAlbum:(HTAlbum *)album
               selectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount{
    
    HTImageGridViewLayout *gridLayout = [[HTImageGridViewLayout alloc] init];
    
    self = [super initWithCollectionViewLayout:gridLayout];
    
    if (self) {
        _album = album;
        _selectedAssets = selectedAssets;
        _maxPickerCount = maxPickerCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupToolBarAndCell];
}

#pragma mark - HTImageGridCellDelegate

- (void)gridCell:(HTImageGridCell *)cell didSelected:(BOOL)selected{

    if (_selectedAssets.count == _maxPickerCount && selected) {
        NSString *message = [NSString stringWithFormat:@"最多只能选择%zd张照片",_maxPickerCount];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        cell.seletedButton.selected = NO;
        
        return;
    }
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    PHAsset *asset = [_album assetWithIndex:indexPath.item];
    
    if (selected) {
        [_selectedAssets addObject:asset];
    } else {
        [_selectedAssets removeObject:asset];
    }
    [self updateCounter];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _album.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTImageGridViewCellIdentifier forIndexPath:indexPath];
    
    // 空白图占位
    cell.imageView.image = [_album emptyImageWithSize:cell.bounds.size];
    // 查找获取图片资源
    [_album requestThumbnailWithAssetIndex:indexPath.item size:cell.bounds.size withCompletion:^(UIImage *thumbnail) {
        
        cell.imageView.image = thumbnail;
    }];
    // 将选中的图片选中
    cell.seletedButton.selected =  [_selectedAssets containsObject:[_album assetWithIndex:indexPath.item]];
    
    cell.gridCellDelegate = self;
    
    return cell;
}


#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self showPreViewControllerWithIndexPath:indexPath];
}

- (void)showPreViewControllerWithIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)setupToolBarAndCell{

    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.title = _album.title;
    // 设置toolBar
    _preViewItem = [[UIBarButtonItem alloc] initWithTitle:@"预览"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self
                                                   action:@selector(previewItemDidClick)];
    _preViewItem.enabled = NO;
    
    
    _counterButton = [[HTSelectedCounterButton alloc] init];
    UIBarButtonItem *counterItem = [[UIBarButtonItem alloc] initWithCustomView:_counterButton];
    
    _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                 style:UIBarButtonItemStylePlain
                                                target:self action:@selector(doneItemDidClick)];
    _doneItem.enabled = NO;
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[_preViewItem,spaceItem,counterItem,_doneItem];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"取消"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(closebuttonClick)];
    
    // Register cell classes
    [self.collectionView registerClass:[HTImageGridCell class] forCellWithReuseIdentifier:HTImageGridViewCellIdentifier];
    
    [self updateCounter];
}

- (void)updateCounter{
    
    _counterButton.count = _selectedAssets.count;
    _preViewItem.enabled = _counterButton.count > 0;
    _doneItem.enabled = _counterButton.count > 0;

}

- (void)previewItemDidClick{

    NSLog(@"%s",__func__);
    
}

- (void)doneItemDidClick{
    
    NSLog(@"%s",__func__);
}

- (void)closebuttonClick{
    /**
      HTImagePicker[1128:470463] -[HTImagePickerController dealloc]
      HTImagePicker[1128:470463] -[HTImageGridViewController dealloc]
      HTImagePicker[1128:470463] -[HTAlbumsTableViewController dealloc]
     */
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
