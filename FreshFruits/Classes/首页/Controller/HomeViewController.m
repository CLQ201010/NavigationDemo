//
//  HomeViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeViewController.h"
#import "CityPickerViewController.h"

@interface HomeViewController ()

@property (nonatomic,assign)  CGFloat centerMargin;
@property (nonatomic,assign)  CGFloat rightMargin;
@property (nonatomic,weak) UIButton *rightBtn;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.rightBtn.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.rightBtn.hidden = NO;
}

#pragma mark 初始化

- (void)setupUI
{
    // 1.背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.导航栏
    [self setupNavigation];
}

- (void)setupNavigation
{
    // 1.标题
    UILabel *titleLbl = [UILabel new];
    titleLbl.textColor = kColor(16, 16, 16);
    titleLbl.font = kFont(16);
    titleLbl.text = @"首页";
    self.navigationItem.titleView = titleLbl;

    titleLbl.sd_layout
    .heightIs(44);
    [titleLbl setSingleLineAutoResizeWithMaxWidth:200];
    
    // 2.右侧按钮
    UIButton *rightBtn = [UIButton new];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightBtn];
    
    CGFloat locationImgW = 20;
    CGFloat locationImgH = 30;
    CGFloat locationImgX = 0;
    CGFloat locationImgY = 0;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(locationImgX, locationImgY, locationImgW, locationImgH)];
    imgView.image = [UIImage imageNamed:@"tabbar_badgeHL"];
    [rightBtn addSubview:imgView];
    
    NSString *strCity = @"福州";
    CGSize citySize = [strCity sizeWithAttributes:@{NSFontAttributeName:kFont(15)}];
    
    CGFloat cityW = citySize.width;
    CGFloat cityH = 30;
    CGFloat cityX = CGRectGetMaxX(imgView.frame) + self.centerMargin;
    CGFloat cityY = 0;
    
    UILabel *cityLbl = [[UILabel alloc] initWithFrame:CGRectMake(cityX, cityY, cityW, cityH)];
    cityLbl.text = strCity;
    cityLbl.textColor = kColor(16, 16, 16);
    cityLbl.font = kFont(15);
    cityLbl.textAlignment = NSTextAlignmentLeft;
    [rightBtn addSubview:cityLbl];
    self.rightBtn = rightBtn;
    
    rightBtn.frame = [self calculateRightBtnFrame:cityLbl.frame.size.width imgWidth:imgView.frame.size.width];
}


- (CGRect)calculateRightBtnFrame:(CGFloat)textWidth imgWidth:(CGFloat)imgWidth
{
    CGFloat btnW = textWidth + imgWidth + self.centerMargin;
    CGFloat btnH = 30;
    CGFloat btnX = kScreenWidth - btnW - self.rightMargin;
    CGFloat btnY = (44 - btnH) / 2.0;
    
    return CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark  属性变量初始化

- (CGFloat)centerMargin
{
    return 5;
}

- (CGFloat)rightMargin
{
    return 10;
}

#pragma mark 按钮点击事件

- (void)rightBtnClick
{
    CityPickerViewController *cityPickerVC = [CityPickerViewController new];
    [self.navigationController pushViewController:cityPickerVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
