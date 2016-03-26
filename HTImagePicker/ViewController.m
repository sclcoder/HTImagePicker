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
    
    
    HTImagePickerController *picker = [[HTImagePickerController alloc] init];
    
    [self presentViewController:picker animated:YES completion:^{
    
    }];
    

    
}


@end
