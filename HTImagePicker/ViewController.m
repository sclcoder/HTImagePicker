//
//  ViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "ViewController.h"

#import "HTImagePickerController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)clickCamera:(id)sender {
    
    
    HTImagePickerController *picker = [[HTImagePickerController alloc] initWithSelectedAssets:nil];
    
    picker.targetSize = CGSizeMake(400, 400);
    
    picker.maxPickerCount = 6;
    
    [self presentViewController:picker animated:YES completion:^{
    
    }];
}


@end
