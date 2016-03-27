//
//  HTAlbumsTableViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTAlbumsTableViewController.h"
#import "HTAlbumsTableViewCell.h"
#import "HTAlbum.h"

static NSString *const HTAlbumsTableViewCellIdentifer = @"HTAlbumsTableViewCellIdentifer";

typedef void(^HTFecthResultBlock)(NSArray <HTAlbum *> *assetCollections, BOOL isAuthorized);

@interface HTAlbumsTableViewController ()
{
    /**
     *  相册资源合集 存放相册模型
     */
    NSArray<HTAlbum *> *_assetCollections;
    /**
     *  已经选中的资源数组
     */
    NSMutableArray<PHAsset *> *selectedAssets;
    
}
@end

@implementation HTAlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册薄";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancleButton)];
    
    [self checkAuthorizationStatusWithCompletion:^(NSArray<HTAlbum *> *assetCollections, BOOL isAuthorized) {
        if (isAuthorized) {
            
            _assetCollections = assetCollections;
            NSLog(@"%zd",_assetCollections.count);
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无权访问相册，请授权" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return ;
        }
    }];
}



- (void)clickCancleButton{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  检测访问相册权限
 *
 *  @param completion 回调
 */
- (void)checkAuthorizationStatusWithCompletion:(HTFecthResultBlock)completion{

    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
            
            // 授权
        case PHAuthorizationStatusAuthorized:
            
            NSLog(@"PHAuthorizationStatusAuthorized");
            // 拉取相册
            [self fetchResultWithCompletion:completion];
            break;

            // 拒绝
        case PHAuthorizationStatusDenied:
            
            NSLog(@"PHAuthorizationStatusDenied");
            // 没有授权
        case PHAuthorizationStatusRestricted:
            
            NSLog(@"PHAuthorizationStatusRestricted");
            completion(nil,NO);
            break;
            
            // 未决定
        case PHAuthorizationStatusNotDetermined:
            
            NSLog(@"PHAuthorizationStatusNotDetermined");
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    [self fetchResultWithCompletion:completion];
                }
            }];
            break;
    }
}

/**
 *  获取相册
 *
 *  @param complete
 */
- (void)fetchResultWithCompletion:(HTFecthResultBlock)completion{
    
    // 相机胶卷
    /**
     Retrieves asset collections of the specified type and subtype.
     
     PHAssetCollectionTypeSmartAlbum:
     A smart album whose contents update dynamically.
     The Photos app displays built-in smart albums to group certain kinds of related assets (see Asset Collection Subtypes).
     
     PHAssetCollectionSubtypeSmartAlbumUserLibrary:
     A smart album that groups all assets that originate in the user’s own library (as opposed to assets from iCloud Shared Albums).
     
     */

    PHFetchResult *userLibrary = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                             subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                             options:nil];
    
    NSMutableArray *result = [NSMutableArray array];
    [userLibrary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // obj 就是 assetCollection 一个相册对象
        [result addObject:[HTAlbum albumWithAssetCollection:obj]];
        
    }];
    
    
    // 同步回调
    if (completion) {
        completion(result.copy,YES);
    }
    
}


#pragma -mark HTAlbumsTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTAlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HTAlbumsTableViewCellIdentifer];
    
    if (cell == nil) {
        cell = [[HTAlbumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HTAlbumsTableViewCellIdentifer];
    }
    
    cell.album = _assetCollections[indexPath.row];
    
    return cell;
}
@end