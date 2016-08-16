//
//  ViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "LauncherViewController.h"
#import "MainFrameManager.h"
#import "CCLocationManager.h"
#import "LoadingViewController.h"

@interface LauncherViewController ()

@end

@implementation LauncherViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.加载主框架
    [[MainFrameManager sharedmain] loadMainFrame];
    
    // 2.开启定位服务
    [self openLocationService];
    
    // 3.进入主页面动画
    LoadingViewController *loadingVC = [[LoadingViewController alloc] init];
    [[[MainFrameManager sharedmain] tabBarController].view addSubview:loadingVC.view];
}

- (void)openLocationService
{
    [[CCLocationManager shareLocation] openLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
