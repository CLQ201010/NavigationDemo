//
//  CityPickerViewController.m
//  FreshFruits
//
//  Created by clq on 16/8/5.
//  Copyright © 2016年 clq. All rights reserved.
//

#import "CityPickerViewController.h"
#import "CCLocationManager.h"

@interface CityPickerViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *citysDic;
@property (nonatomic,strong) NSMutableArray *groupKeys;
@property (nonatomic,strong) NSMutableDictionary *datasDic;

@end

@implementation CityPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化界面
    [self setupUI];
    
    // 2.初始化数据
    [self setupData];
    
    // 3.添加通知
    [self addNotification];
    
    [[CCLocationManager shareLocation] startLocation];
}

#pragma mark 初始化

- (void)setupUI
{
    // 1.背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 2.导航栏
    [self setupNavigation];
    
    // 3.表单
    [self setupTableView];
}

- (void)setupNavigation
{
    // 1.标题
    UILabel *titleLbl = [UILabel new];
    titleLbl.textColor = kColor(16, 16, 16);
    titleLbl.font = kFont(16);
    titleLbl.text = @"城市列表";
    self.navigationItem.titleView = titleLbl;
    
    titleLbl.sd_layout
    .heightIs(44);
    [titleLbl setSingleLineAutoResizeWithMaxWidth:200];
    
    // 2.后退按钮
    self.navigationController.navigationBar.tintColor = [UIColor lightGrayColor];
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);

    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)setupData
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"City" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *provincesArray = [[NSMutableArray alloc] init];
    
    if (array) {
        for (id obj in array)  {
            if ([obj isKindOfClass:[NSArray class]]) {
                NSArray *items = obj;
                for (NSString *item in items) {
                    [provincesArray addObject:item];
                }
                
            }
            else if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = obj;
                
                [self.citysDic addEntriesFromDictionary:dict];
                
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [provincesArray addObject:key];
                }];
            }
        }
    }
    
    [self.groupKeys addObjectsFromArray:@[@"当前位置",@"切换城市"]];
    [self.datasDic addEntriesFromDictionary:@{@"当前位置":@[@"正在定位中.."],@"切换城市":provincesArray}];
}

- (BOOL)isCity:(NSString *)placeName
{
    if ([self.citysDic objectForKey:placeName]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)addNotification
{
    // 定位成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationSuccess) name:kLocationSuccessNotification object:nil];
    //定位失败通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationFailed) name:kLocationFailedNotification object:nil];
}

#pragma mark 通知事件

- (void)locationSuccess
{
    NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
    NSString *locationCity = [standardDefault objectForKey:kLocationCity];
    
    [self.datasDic setObject:@[locationCity] forKey:@"当前位置"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)locationFailed
{
    [self.datasDic setObject:@[@"定位失败"] forKey:@"当前位置"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 属性变量

- (NSMutableArray *)groupKeys
{
    if (_groupKeys == nil) {
        _groupKeys = [[NSMutableArray alloc] init];
    }
    
    return _groupKeys;
}

- (NSMutableDictionary *)datasDic
{
    if (_datasDic == nil) {
        _datasDic = [[NSMutableDictionary alloc] init];
    }
    
    return _datasDic;
}

- (NSMutableDictionary *)citysDic
{
    if (_citysDic == nil) {
        _citysDic = [[NSMutableDictionary alloc] init];
    }
    
    return _citysDic;
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.groupKeys[section];
    NSArray *array = [self.datasDic objectForKey:key];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityTableViewCell"];
    }
    
    NSString *key = self.groupKeys[indexPath.section];
    NSArray *array = [self.datasDic objectForKey:key];
    NSString *cityName = array[indexPath.row];
    
    if ([self isCity:cityName]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = cityName;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupKeys.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groupKeys[section];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
