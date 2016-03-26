//
//  HTAlbumsTableViewController.m
//  HTImagePicker
//
//  Created by sunchunlei on 16/3/26.
//  Copyright © 2016年 godHands. All rights reserved.
//

#import "HTAlbumsTableViewController.h"
#import "HTAlbumsTableViewCell.h"

static NSString *const HTAlbumsTableViewCellIdentifer = @"HTAlbumsTableViewCellIdentifer";

@interface HTAlbumsTableViewController ()

@end

@implementation HTAlbumsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.title = @"相册薄";
}


#pragma -mark HTAlbumsTableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTAlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HTAlbumsTableViewCellIdentifer];
    
    if (cell == nil) {
        cell = [[HTAlbumsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:HTAlbumsTableViewCellIdentifer];
    }
    
    cell.textLabel.text = @"一个相册";
    
    return cell;
}
@end
