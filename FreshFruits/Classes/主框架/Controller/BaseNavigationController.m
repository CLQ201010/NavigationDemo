//
//  BaseNavigationController.m
//  FreshFruits
//
//  Created by clq on 16/8/11.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "BaseNavigationController.h"
#import "MainFrameManager.h"

@interface BaseNavigationController ()

@property (nonatomic,assign) CGFloat slideDistance;
@property (nonatomic,assign) CGFloat slideOriginX;

@property (nonatomic,strong) UIImageView *leftImgView;  //用于右滑，左侧快照
@property (nonatomic,strong) UIImageView *rightImgView; //用于左滑时，右侧快照

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage  *navigateBgImg = [UIImage imageNamed:@"nav_bg"];
    navigateBgImg = [navigateBgImg stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.navigationBar setBackgroundImage:navigateBgImg forBarMetrics:UIBarMetricsDefault];
    
    // 添加手势
    [self addPanGesture];
}

- (void)viewDidAppear:(BOOL)animated{
    GTTabBarController *tabBar = [MainFrameManager sharedmain].tabBarController;
    NSUInteger selectedIndex = [tabBar selectedIndex];

    if (selectedIndex > 0) {
        UIViewController* v1 = [tabBar.viewControllers objectAtIndex:selectedIndex-1];
        UIImage* image1 = [self imageByCropping:v1.view toRect:v1.view.bounds];
        self.leftImgView = [[UIImageView alloc] initWithImage:image1];
        self.leftImgView.frame = CGRectMake(self.leftImgView.frame.origin.x - kScreenWidth, 0 , self.leftImgView.frame.size.width, self.leftImgView.frame.size.height);
        [self.view addSubview:self.leftImgView];
    }
    
    if (selectedIndex < tabBar.viewControllers.count - 1) {
        UIViewController* v2 = [tabBar.viewControllers objectAtIndex:selectedIndex+1];
        UIImage* image2 = [self imageByCropping:v2.view toRect:v2.view.bounds];
        self.rightImgView = [[UIImageView alloc] initWithImage:image2];
        self.rightImgView.frame = CGRectMake(self.rightImgView.frame.origin.x + kScreenWidth, 0, self.rightImgView.frame.size.width, self.rightImgView.frame.size.height);
        [self.view addSubview:self.rightImgView];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    GTTabBarController *tabBar = [MainFrameManager sharedmain].tabBarController;
    NSUInteger selectedIndex = [tabBar selectedIndex];
    
    if (selectedIndex > 0) {
        [self.leftImgView removeFromSuperview];
    }
    
    if (selectedIndex < tabBar.viewControllers.count - 1) {
        [self.rightImgView removeFromSuperview];
    }
}

//与pan结合使用 截图方法，图片用来做动画
-(UIImage*)imageByCropping:(UIView*)imageToCrop toRect:(CGRect)rect
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize pageSize = CGSizeMake(scale * rect.size.width, scale * rect.size.height) ;
    UIGraphicsBeginImageContext(pageSize);
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    
    CGContextRef resizedContext =UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(resizedContext, -1 * rect.origin.x, -1 * rect.origin.y);
    [imageToCrop.layer renderInContext:resizedContext];
    UIImage*imageOriginBackground =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageOriginBackground = [UIImage imageWithCGImage:imageOriginBackground.CGImage scale:scale orientation:UIImageOrientationUp];
    
    return imageOriginBackground;
}

- (void)addPanGesture
{
    self.slideDistance = 0;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark Pan手势
- (void)handlePanGesture:(UIPanGestureRecognizer*)recongizer{
    GTTabBarController *tabBar = [MainFrameManager sharedmain].tabBarController;
    NSUInteger selectedIndex = [tabBar selectedIndex];
    
    CGPoint point = [recongizer translationInView:self.view];
    
    if (selectedIndex == 0) {
        if (recongizer.view.center.x + point.x >  kScreenWidth / 2) {
            recongizer.view.center = CGPointMake(kScreenWidth / 2, recongizer.view.center.y);
        } else {
            recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
        }
    } else if (selectedIndex == tabBar.viewControllers.count - 1 ) {
        if (recongizer.view.center.x + point.x <  kScreenWidth / 2) {
            recongizer.view.center = CGPointMake(kScreenWidth / 2, recongizer.view.center.y);
        } else {
            recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
        }
    } else {
        recongizer.view.center = CGPointMake(recongizer.view.center.x + point.x, recongizer.view.center.y);
    }
    
    [recongizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (recongizer.state == UIGestureRecognizerStateEnded) {
        if (recongizer.view.center.x < kScreenWidth && recongizer.view.center.x > 0 ) {
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                recongizer.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
            }completion:^(BOOL finished) {
                
            }];
        } else if (recongizer.view.center.x <= 0 ){
            if (selectedIndex < tabBar.viewControllers.count - 1) {
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    recongizer.view.center = CGPointMake(-kScreenWidth / 2, kScreenHeight / 2);
                }completion:^(BOOL finished) {
                    [tabBar setSelectedIndex:selectedIndex + 1];
                    recongizer.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
                }];
            }
        } else {
            if (selectedIndex > 0) {
                [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    recongizer.view.center = CGPointMake(kScreenWidth * 1.5, kScreenHeight / 2);
                }completion:^(BOOL finished) {
                    [tabBar setSelectedIndex:selectedIndex - 1];
                    recongizer.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
                }];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
