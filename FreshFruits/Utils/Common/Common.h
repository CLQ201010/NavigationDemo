//
//  Common.h
//  FreshFruits
//
//  Created by clq on 16/7/22.
//  Copyright © 2016年 clq. All rights reserved.
//

#ifndef ___Common_h
#define ___Common_h

#define MyFont(s)  [UIFont systemFontOfSize:(s)]
#define WColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define WColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]
//屏幕的宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕的高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define MyDefaults [NSUserDefaults standardUserDefaults]
#define Mynotification [NSNotificationCenter defaultCenter]

#endif
