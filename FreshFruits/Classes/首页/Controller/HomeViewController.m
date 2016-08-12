//
//  HomeViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "HomeViewController.h"
#import "CityPickerViewController.h"
#import "SDCycleScrollView.h"
#import "HomeButton.h"

@interface HomeViewController () <SDCycleScrollViewDelegate>

@property (nonatomic,assign)  CGFloat centerMargin;
@property (nonatomic,assign)  CGFloat rightMargin;
@property (nonatomic,assign)  CGFloat halveWidth; //二等分宽度
@property (nonatomic,assign)  CGFloat trisectWidth; //三等分宽度

@property (nonatomic,weak) UIButton *rightBtn;

@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,weak) SDCycleScrollView *cycleScrollView;  //轮播图
@property (nonatomic,weak) HomeButton *headlineBtn;      //市场头条
@property (nonatomic,weak) HomeButton *activeBtn;        //市场活动
@property (nonatomic,weak) HomeButton *lifeBtn;          //生活便民
@property (nonatomic,weak) HomeButton *payBtn;           //快速支付
@property (nonatomic,weak) HomeButton *enterpriseBtn;    //企业服务
@property (nonatomic,weak) HomeButton *fruitBtn;         //鲜果
@property (nonatomic,weak) HomeButton *seafoodBtn;       //海鲜

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
   // self.automaticallyAdjustsScrollViewInsets = NO; //不然轮播图顶部绘出现一块空白区域
    
    // 2.导航栏
    [self setupNavigation];
    
    // 3.设置主页面
    [self setupScrollView];
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

- (void)setupScrollView
{
    UIScrollView  *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    scrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    scrollView.backgroundColor = [UIColor whiteColor];
    
    // 1.轮播图
    [self setupCycleView];
    
    // 2.市场头条
    [self setupHeadlineBtn];
    
    // 3.市场活动
    [self setupActiveBtn];
    
    // 4.生活便民
    [self setupLifeBtn];
    
    // 5.快速支付
    [self setupPayBtn];
    
    // 6.企业服务
    [self setupEnterpriseBtn];
    
    // 7.鲜果
    [self setupFruitBtn];
    
    // 8.海鲜
    [self setupSeafoodBtn];
    
    
    
    // 设置scrollview的contentsize自适应
    [scrollView setupAutoContentSizeWithBottomView:_seafoodBtn bottomMargin:10];
}

- (void)setupCycleView
{
    CGFloat cycleW = self.view.frame.size.width;
    CGFloat cycleH = 0.4 * cycleW;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, cycleW, cycleH) delegate:self placeholderImage:[UIImage imageNamed:@"home_cyclePlaceholder"]];
    cycleScrollView.imageURLStringsGroup = @[
                                              @"http://www.bz55.com/uploads/allimg/120629/1-120629104603.jpg",
                                              @"http://g.hiphotos.baidu.com/image/pic/item/b58f8c5494eef01f845ef9d3e3fe9925bc317d5a.jpg",
                                              @"http://img.article.pchome.net/00/43/41/54/pic_lib/wm/3.jpg",
                                              @"http://f.hiphotos.baidu.com/image/h%3D200/sign=658bab6a553d269731d30f5d65fab24f/0dd7912397dda1446853fa12b6b7d0a20cf4863c.jpg"
                                              ];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    [_scrollView addSubview:cycleScrollView];
    _cycleScrollView = cycleScrollView;
}

- (void)setupHeadlineBtn
{
    HomeButton *headlineBtn = [HomeButton new];
    headlineBtn.backgroundColor = kColor(232, 115, 58);
    [headlineBtn setImage:[UIImage imageNamed:@"home_headline"] forState:UIControlStateNormal];
    [headlineBtn setTitle:@"市场头条" forState:UIControlStateNormal];
    [headlineBtn addTarget:self action:@selector(headlineBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:headlineBtn];
    _headlineBtn = headlineBtn;
    
    CGFloat headW = kScreenWidth - 2 * self.rightMargin - self.centerMargin - self.trisectWidth;
    
    headlineBtn.sd_layout
    .leftSpaceToView(_scrollView,self.rightMargin)
    .topSpaceToView(_cycleScrollView,self.rightMargin)
    .widthIs(headW)
    .autoHeightRatio(0.4);
}

- (void)setupActiveBtn
{
    HomeButton *activeBtn = [HomeButton new];
    activeBtn.backgroundColor = kColor(226, 163, 50);
    [activeBtn setImage:[UIImage imageNamed:@"home_active"] forState:UIControlStateNormal];
    [activeBtn setTitle:@"市场活动" forState:UIControlStateNormal];
    [activeBtn addTarget:self action:@selector(activeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:activeBtn];
    _activeBtn = activeBtn;
    
    activeBtn.sd_layout
    .leftSpaceToView(_headlineBtn,self.centerMargin)
    .topEqualToView(_headlineBtn)
    .rightSpaceToView(_scrollView,self.rightMargin)
    .widthIs(self.trisectWidth)
    .heightRatioToView(_headlineBtn,1.0);
}

- (void)setupLifeBtn
{
    HomeButton *lifeBtn = [HomeButton new];
    lifeBtn.backgroundColor = kColor(51, 178, 189);
    [lifeBtn setImage:[UIImage imageNamed:@"home_life"] forState:UIControlStateNormal];
    [lifeBtn setTitle:@"便民生活" forState:UIControlStateNormal];
    [lifeBtn addTarget:self action:@selector(lifeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:lifeBtn];
    _lifeBtn = lifeBtn;
    
    lifeBtn.sd_layout
    .leftEqualToView(_headlineBtn)
    .topSpaceToView(_headlineBtn,self.rightMargin)
    .widthRatioToView(_activeBtn,1.0)
    .heightRatioToView(_activeBtn,1.0);
}

- (void)setupPayBtn
{
    HomeButton *payBtn = [HomeButton new];
    payBtn.backgroundColor = kColor(51, 178, 189);
    [payBtn setImage:[UIImage imageNamed:@"home_pay"] forState:UIControlStateNormal];
    [payBtn setTitle:@"快速支付" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:payBtn];
    _payBtn = payBtn;
    
    payBtn.sd_layout
    .leftSpaceToView(_lifeBtn,self.centerMargin)
    .topEqualToView(_lifeBtn)
    .widthRatioToView(_lifeBtn,1.0)
    .heightRatioToView(_lifeBtn,1.0);
}

- (void)setupEnterpriseBtn
{
    HomeButton *enterpriseBtn = [HomeButton new];
    enterpriseBtn.backgroundColor = kColor(51, 178, 189);
    [enterpriseBtn setImage:[UIImage imageNamed:@"home_enterprise"] forState:UIControlStateNormal];
    [enterpriseBtn setTitle:@"企业服务" forState:UIControlStateNormal];
    [enterpriseBtn addTarget:self action:@selector(enterpriseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:enterpriseBtn];
    _enterpriseBtn = enterpriseBtn;
    
    enterpriseBtn.sd_layout
    .leftSpaceToView(_payBtn,self.centerMargin)
    .topEqualToView(_payBtn)
    .rightSpaceToView(_scrollView,self.rightMargin)
    .widthRatioToView(_payBtn,1.0)
    .heightRatioToView(_payBtn,1.0);
}

- (void)setupFruitBtn
{
    HomeButton *fruitBtn = [HomeButton new];
    fruitBtn.backgroundColor = kColor(180, 192, 54);
    [fruitBtn setImage:[UIImage imageNamed:@"home_fruit"] forState:UIControlStateNormal];
    [fruitBtn setTitle:@"鲜果" forState:UIControlStateNormal];
    [fruitBtn addTarget:self action:@selector(fruitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:fruitBtn];
    _fruitBtn = fruitBtn;
    
    fruitBtn.sd_layout
    .leftEqualToView(_lifeBtn)
    .topSpaceToView(_lifeBtn,self.rightMargin)
    .widthIs(self.halveWidth)
    .heightRatioToView(_lifeBtn,1.0);
}

- (void)setupSeafoodBtn
{
    HomeButton *seafoodBtn = [HomeButton new];
    seafoodBtn.backgroundColor = kColor(98, 180, 62);
    [seafoodBtn setImage:[UIImage imageNamed:@"home_seafood"] forState:UIControlStateNormal];
    [seafoodBtn setTitle:@"海鲜" forState:UIControlStateNormal];
    [seafoodBtn addTarget:self action:@selector(seafoodBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:seafoodBtn];
    _seafoodBtn = seafoodBtn;
    
    seafoodBtn.sd_layout
    .leftSpaceToView(seafoodBtn,self.centerMargin)
    .topEqualToView(_fruitBtn)
    .rightSpaceToView(_scrollView,self.rightMargin)
    .widthRatioToView(_fruitBtn,1.0)
    .heightRatioToView(_fruitBtn,1.0);
}

- (CGRect)calculateRightBtnFrame:(CGFloat)textWidth imgWidth:(CGFloat)imgWidth
{
    CGFloat btnW = textWidth + imgWidth + self.centerMargin;
    CGFloat btnH = 30;
    CGFloat btnX = kScreenWidth - btnW - self.rightMargin;
    CGFloat btnY = (44 - btnH) / 2.0;
    
    return CGRectMake(btnX, btnY, btnW, btnH);
}

#pragma mark 按钮点击事件

- (void)headlineBtnClick
{
    NSLog(@"headlineBtnClick");
}

- (void)activeBtnClick
{
    NSLog(@"activeBtnClick");
}

- (void)lifeBtnClick
{
     NSLog(@"lifeBtnClick");
}

- (void)payBtnClick
{
    NSLog(@"payBtnClick");
}

- (void)enterpriseBtnClick
{
     NSLog(@"enterpriseBtnClick");
}

- (void)fruitBtnClick
{
     NSLog(@"fruitBtnClick");
}

- (void)seafoodBtnClick
{
    NSLog(@"seafoodBtnClick");
}

#pragma mark  属性变量初始化

- (CGFloat)centerMargin
{
    return 8;
}

- (CGFloat)rightMargin
{
    return 10;
}

- (CGFloat)halveWidth
{
    CGFloat halveW = (kScreenWidth - 2 * self.rightMargin - self.centerMargin) / 2.0;
    return halveW;
}

- (CGFloat)trisectWidth
{
    CGFloat trisectW = (kScreenWidth - 2 * self.rightMargin - 2 * self.centerMargin) / 3.0;
    return trisectW;
}

#pragma mark  SDCycleScrollViewDelegate

//点击图片回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
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
