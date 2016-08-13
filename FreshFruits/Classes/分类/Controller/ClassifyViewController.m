//
//  ClassifyViewController.m
//  FreshFruits
//
//  Created by clq on 16/7/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "ClassifyViewController.h"
#import "LQExpandAnimation.h"

@interface ClassifyViewController () <UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,LQExpandAnimationFromViewAnimationsAdapter>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) LQExpandAnimation *expandAnimation;

@end

@implementation ClassifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor greenColor];
    
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

- (BOOL)isHasNavigation
{
    return YES;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
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
        return selectCell.frame;
    };
    
    UIViewController *VC = [[UIViewController alloc] init];
    [VC.view setBackgroundColor:[UIColor redColor]];
    VC.transitioningDelegate  = self;
    VC.modalPresentationStyle = UIModalPresentationCustom;
    VC.view.backgroundColor = selectCell.backgroundColor;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [VC.view addGestureRecognizer:singleTapGestureRecognizer];
    _vc = VC;
    
    [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:VC animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  100;
}

- (void)singleTap:(UIGestureRecognizer *)regesture
{
    [_vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.expandAnimation;
}

-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.expandAnimation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
