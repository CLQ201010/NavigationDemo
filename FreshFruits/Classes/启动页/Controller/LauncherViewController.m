//
//  ViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "LauncherViewController.h"
#import "MainFrameManager.h"

@interface LauncherViewController ()

@end

@implementation LauncherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 加载主框架
    [[MainFrameManager sharedmain] loadMainFrame];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
