//
//  HTPreViewController.h
//  HTImagePicker
//
//  Created by sunchunlei on 16/4/6.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTAlbum.h"



@interface HTPreViewController : UIViewController

- (instancetype)initWithAlbum:(HTAlbum *)album
               selectedAssets:(NSMutableArray<PHAsset *>*)selectedAssets
               maxPickerCount:(NSInteger)maxPickerCount
                    indexPath:(NSIndexPath *)indexPath;

@end
