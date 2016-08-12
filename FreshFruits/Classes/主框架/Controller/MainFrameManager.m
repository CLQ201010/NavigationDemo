//
//  MainFrameManager.m
//  FreshFruits
//
//  Created by clq on 16/7/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "MainFrameManager.h"
#import "GTTabBarController.h"
#import "BaseNavigationController.h"

#import "HomeViewController.h"
#import "ClassifyViewController.h"
#import "FeatureViewController.h"
#import "NewsViewController.h"
#import "MeViewController.h"

@interface MainFrameManager () <GTTabBarControllerDelegate>

@property (nonatomic,strong) HomeViewController *homeVC;
@property (nonatomic,strong) ClassifyViewController *classifyVC;
@property (nonatomic,strong) FeatureViewController *featureVC;
@property (nonatomic,strong) MeViewController *meVC;
@property (nonatomic,strong) NewsViewController *newsVC;

@end

@implementation MainFrameManager
SingletonM(main);

- (void)loadMainFrame
{
    NSMutableArray *vcsArray = [[NSMutableArray alloc] init];  //存放controller
    NSMutableArray *imgsArray = [[NSMutableArray alloc] init]; //存放bar按钮图片
    
    // 1.首页
    self.homeVC = [[HomeViewController alloc] init];
    BaseNavigationController *homeNav = [[BaseNavigationController alloc] initWithRootViewController:self.homeVC];
    [vcsArray addObject:homeNav];
    
    NSMutableDictionary *homeDic = [[NSMutableDictionary alloc] init];
    [homeDic setObject:[UIImage imageNamed:@"tabbar_home"] forKey:@"Default"];
    [homeDic setObject:[UIImage imageNamed:@"tabbar_home"] forKey:@"Highlighted"];
    [homeDic setObject:[UIImage imageNamed:@"tabbar_homeHL"] forKey:@"Seleted"];
    [imgsArray addObject:homeDic];
    
    // 2.分类
    self.classifyVC = [[ClassifyViewController alloc] init];
    self.classifyVC.title = @"分类";
    BaseNavigationController *classifyNav = [[BaseNavigationController alloc] initWithRootViewController:self.classifyVC ];
    [vcsArray addObject:classifyNav];
    
    NSMutableDictionary *classifyDic = [[NSMutableDictionary alloc] init];
    [classifyDic setObject:[UIImage imageNamed:@"tabbar_classify"] forKey:@"Default"];
    [classifyDic setObject:[UIImage imageNamed:@"tabbar_classify"] forKey:@"Highlighted"];
    [classifyDic setObject:[UIImage imageNamed:@"tabbar_classifyHL"] forKey:@"Seleted"];
    [imgsArray addObject:classifyDic];
    
    // 3.精选
    self.featureVC = [[FeatureViewController alloc] init];
    self.featureVC.title = @"精选";
    BaseNavigationController *featureNav = [[BaseNavigationController alloc] initWithRootViewController:self.featureVC];
    [vcsArray addObject:featureNav];
    
    NSMutableDictionary *featureDic = [[NSMutableDictionary alloc] init];
    [featureDic setObject:[UIImage imageNamed:@"tabbar_feature"] forKey:@"Default"];
    [featureDic setObject:[UIImage imageNamed:@"tabbar_feature"] forKey:@"Highlighted"];
    [featureDic setObject:[UIImage imageNamed:@"tabbar_featureHL"] forKey:@"Seleted"];
    [imgsArray addObject:featureDic];
    
    // 4.我
    self.meVC = [[MeViewController alloc] init];
    self.meVC.title = @"我";
    BaseNavigationController *meNav = [[BaseNavigationController alloc] initWithRootViewController:self.meVC];
    [vcsArray addObject:meNav];
    
    NSMutableDictionary *meDic = [[NSMutableDictionary alloc] init];
    [meDic setObject:[UIImage imageNamed:@"tabbar_me"] forKey:@"Default"];
    [meDic setObject:[UIImage imageNamed:@"tabbar_me"] forKey:@"Highlighted"];
    [meDic setObject:[UIImage imageNamed:@"tabbar_meHL"] forKey:@"Seleted"];
    [imgsArray addObject:meDic];
    
    // 5.资讯
    self.newsVC = [[NewsViewController alloc] init];
    self.newsVC.title = @"资讯";
    BaseNavigationController *newsNav = [[BaseNavigationController alloc] initWithRootViewController:self.newsVC];
    [vcsArray addObject:newsNav];
    
    NSMutableDictionary *newsDic = [[NSMutableDictionary alloc] init];
    [newsDic setObject:[UIImage imageNamed:@"tabbar_news"] forKey:@"Default"];
    [newsDic setObject:[UIImage imageNamed:@"tabbar_news"] forKey:@"Highlighted"];
    [newsDic setObject:[UIImage imageNamed:@"tabbar_newsHL"] forKey:@"Seleted"];
    [imgsArray addObject:newsDic];
    
    self.tabBarController = [[GTTabBarController alloc] initWithViewControllers:vcsArray imageArray:imgsArray];
    self.tabBarController.delegate = self;
    [self.tabBarController setTabBarTransparent:YES];
    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
}

#pragma mark GTTabBarControllerDelegate
- (BOOL)tabBarController:(GTTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(GTTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
 
}

@end
