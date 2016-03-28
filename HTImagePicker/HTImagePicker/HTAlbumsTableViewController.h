//
//  HTAlbumsTableViewController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface HTAlbumsTableViewController : UITableViewController

- (instancetype)initWithSelectedAssets:(NSMutableArray<PHAsset *> *)selectedAssets;

@property (nonatomic, assign) NSInteger maxPickerCount;

@end
