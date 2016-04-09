//
//  ViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "ViewController.h"

#import "HTImagePickerController.h"
#import "ViewCell.h"

@interface ViewController ()<HTImagePickerControllerDelegate>

/// 选中照片数组
@property (nonatomic) NSArray *images;

/// 选中资源素材数组，用于定位已经选择的照片
@property (nonatomic) NSArray *selectedAssets;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (IBAction)clickCamera:(id)sender {

    HTImagePickerController *picker = [[HTImagePickerController alloc] initWithSelectedAssets:self.selectedAssets];
    
    picker.targetSize = CGSizeMake(400, 400);
    
    picker.maxPickerCount = 3;
    
    picker.pickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - HTImagePickerController Delegate

- (void)imagePickerController:(HTImagePickerController *)pickerController
      didFinishSelectedImages:(NSArray<UIImage *> *)images
               selectedAssets:(NSArray<PHAsset *> *)selectedAssets{
    
    // 记录图像，方便在 CollectionView 显示
    self.images = images;
    
    // 记录选中资源集合，方便再次选择照片定位
    self.selectedAssets = selectedAssets;
    
    [self.collectionView reloadData];

}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.images.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.iconView.image = self.images[indexPath.item];
    
    return cell;
}


@end
