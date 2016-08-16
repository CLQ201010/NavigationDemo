//
//  LoadingViewController.m
//  FreshFruits
//
//  Created by clq on 16/8/16.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@property (nonatomic, weak) UIImageView *leftImgView;
@property (nonatomic, weak) UIImageView *rightImgView;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatoryView;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat halfW = kScreenWidth / 2.0;
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, halfW, kScreenHeight)];
    leftImgView.backgroundColor = [UIColor clearColor];
    leftImgView.image = [UIImage imageNamed:@"loading_left"];
    [self.view addSubview:leftImgView];
    _leftImgView = leftImgView;
    
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(halfW, 0, halfW, kScreenHeight)];
    rightImgView.backgroundColor = [UIColor clearColor];
    rightImgView.image = [UIImage imageNamed:@"loading_right"];
    [self.view addSubview:rightImgView];
    _rightImgView = rightImgView;
    
    UIActivityIndicatorView *activityIndicatoryView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    activityIndicatoryView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    activityIndicatoryView.hidesWhenStopped = YES;
    [activityIndicatoryView startAnimating];
    [self.view addSubview:activityIndicatoryView];
    _activityIndicatoryView = activityIndicatoryView;
    
    [self performSelector:@selector(loadingViewAnimation) withObject:nil afterDelay:0.6];
}

- (void)loadingViewAnimation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadingViewAnimationDone)];
    [UIView setAnimationDuration:2];
    _leftImgView.frame = CGRectMake(_leftImgView.frame.origin.x - _leftImgView.frame.size.width, _leftImgView.frame.origin.y, _leftImgView.frame.size.width, _leftImgView.frame.size.height);
    _rightImgView.frame = CGRectMake(_rightImgView.frame.origin.x + _rightImgView.frame.size.width, _rightImgView.frame.origin.y, _rightImgView.frame.size.width, _rightImgView.frame.size.height);
    [UIView commitAnimations];
    
    [_activityIndicatoryView stopAnimating];
}

- (void)loadingViewAnimationDone
{
    [self.view removeFromSuperview];
    self.view.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
