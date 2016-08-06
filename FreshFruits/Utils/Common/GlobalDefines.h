//
//  Common.h
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#ifndef ___GlobalDefines_h
#define ___GlobalDefines_h

#define kFont(s)  [UIFont systemFontOfSize:(s)]
#define kColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]
//屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kDefaults [NSUserDefaults standardUserDefaults]
#define kNotification [NSNotificationCenter defaultCenter]

#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

#define kCurrentCity @"currentCity"
#define kLocationCity @"locationCity"
#define kLocationSuccessNotification  @"locationSuccessNotification"
#define kLocationFailedNotification  @"locationFailedNotification"

#endif
