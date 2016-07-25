//
//  MainFrameManager.h
//  FreshFruits
//
//  Created by clq on 16/7/23.
//  Copyright © 2016年 clq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTTabBarController.h"

@interface MainFrameManager : NSObject
SingletonH(main);

@property (nonatomic,strong) GTTabBarController *tabBarController;


- (void)loadMainFrame;

@end
