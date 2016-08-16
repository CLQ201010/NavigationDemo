//
//  FeatureViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "FeatureViewController.h"
#import "LQExpandAnimation.h"

@interface FeatureViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, LQExpandAnimationFromViewAnimationsAdapter>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) LQExpandAnimation *expandAnimation;

@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.delegate = self;
    
    [self setupTableView];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    _tableView = tableView;
}

#pragma mark 属性变量

- (LQExpandAnimation *)expandAnimation
{
    if (_expandAnimation == nil) {
        _expandAnimation = [[LQExpandAnimation alloc] init];
        _expandAnimation.animationDuration = 1.0;
        _expandAnimation.fromViewAnimationsAdapter = self;
    }
    
    return _expandAnimation;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:10];
        [_datas addObject:[UIColor greenColor]];
        [_datas addObject:[UIColor redColor]];
        [_datas addObject:[UIColor yellowColor]];
        [_datas addObject:[UIColor lightGrayColor]];
        [_datas addObject:[UIColor grayColor]];
        [_datas addObject:[UIColor blueColor]];
        [_datas addObject:[UIColor brownColor]];
        [_datas addObject:[UIColor purpleColor]];
        [_datas addObject:[UIColor orangeColor]];
        [_datas addObject:[UIColor blackColor]];
    }
    
    return _datas;
}

#pragma mark LQExpandAnimationFromViewAnimationsAdapter

- (BOOL)shouldSlideApart
{
    return YES;
}

- (BOOL)isPush
{
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classfyTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classfyTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger colorIndex = indexPath.row % 9;
    cell.backgroundColor = self.datas[colorIndex];
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.expandAnimation.collapsedViewFrame = ^(){
        CGRect rect = selectCell.frame;
        rect.origin.y = selectCell.frame.origin.y - tableView.bounds.origin.y;
        return rect;
    };
    
    UIViewController *VC = [[UIViewController alloc] init];
    [VC.view setBackgroundColor:[UIColor redColor]];
    VC.view.backgroundColor = selectCell.backgroundColor;
    _vc = VC;
    
    [self.navigationController pushViewController:VC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
}

#pragma mark - UINavigationControllerDelegate iOS7新增的2个方法
// 动画特效
- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    self.expandAnimation.navOperation = operation;
    return self.expandAnimation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
