//
//  HTImageGridViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/28.
//  Copyright © 2016年 godHands. All rights reserved.

#import "HTImageGridViewController.h"
#import "HTImageGridCell.h"
#import "HTImageGridViewLayout.h"

static NSString * const HTImageGridViewCellIdentifier = @"HTImageGridViewCellIdentifier";

@interface HTImageGridViewController ()
{
    
    HTAlbum *_album;
    
    NSMutableArray *_selectedAssets;
    
    NSInteger _maxPickerCount;
    
}
@end

@implementation HTImageGridViewController

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


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _album.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HTImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HTImageGridViewCellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [_album emptyImageWithSize:cell.bounds.size];
    
    [_album requestThumbnailWithAssetIndex:indexPath.item size:cell.bounds.size withCompletion:^(UIImage *thumbnail) {
        
        cell.imageView.image = thumbnail;
    }];
    
    return cell;
}

- (void)setupToolBarAndCell{
    
    
    // Register cell classes
    [self.collectionView registerClass:[HTImageGridCell class] forCellWithReuseIdentifier:HTImageGridViewCellIdentifier];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.title = _album.title;
    
    // 设置toolBar
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"取消"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(closebuttonClick)];
    
}


- (void)closebuttonClick{

    NSLog(@"%s",__func__);
}
@end
