//
//  CCLocationManager.h
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface CCLocationManager : NSObject<CLLocationManagerDelegate>

+ (CCLocationManager *)shareLocation;

- (void)openLocation; //打开定位服务，只有系统首次提示

- (void)startLocation; //打开定位服务，对于未开启服务项进行对应的引导操作

@end
