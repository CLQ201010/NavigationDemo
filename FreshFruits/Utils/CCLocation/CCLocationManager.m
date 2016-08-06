//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import "CCLocationManager.h"
@interface CCLocationManager ()<UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@end

@implementation CCLocationManager


+ (CCLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        //NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (CLLocationManager *)manager
{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate=self;
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        _manager.distanceFilter=100;
    }
    
    return _manager;
}

- (void)openLocation
{
    if (IS_IOS8) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
}

-(void)startLocation
{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" delegate: self cancelButtonTitle:@"暂不" otherButtonTitles:@"去设置", nil];
        alertView.tag = 10001;
        [alertView show];
        
        [kNotification postNotificationName:kLocationFailedNotification object:nil];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"定位服务未开启" message:@"请到系统设置中开启定位服务" delegate:self cancelButtonTitle:@"暂不" otherButtonTitles: @"去设置",nil];
        alvertView.tag = 10002;
        [alvertView show];
        
        [kNotification postNotificationName:kLocationFailedNotification object:nil];
    }
    else {
        [self openLocation];
    }
}

-(void)stopLocation
{
    [self.manager stopUpdatingLocation];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10001) {
        if (buttonIndex == 0) {  //暂不
            
        }
        else if(buttonIndex == 1){ // 去设置,跳转到隐私－》定位服务
            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    else if (alertView.tag == 10002) {
        if (buttonIndex == 0) { //暂不
            
        }
        else if (buttonIndex == 1) { // 去设置，跳转到设置－》FreshFruits
            NSURL *url = [NSURL URLWithString:@"prefs:root=com.richiequan.FreshFruits"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currLocation = [locations lastObject];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if (placemarks.count > 0) {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             // placemark.country  国家
             // placemark.administrativeArea  //行政区   省、直辖市
             // placemark.locality   //地级市、直辖市
             // placemark.subLocality //县级,区
             // placemark.thoroughfare  //街道
             // placemark.subThoroughfare //门牌号
             
             NSString *city = placemark.locality;
             NSUserDefaults *standardDefault = [NSUserDefaults standardUserDefaults];
             [standardDefault setObject:city forKey:kLocationCity];
             
             [kNotification postNotificationName:kLocationSuccessNotification object:nil];
         }
     }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSLog(@"CCLocationManager error=%@",error.description);
    
    [kNotification postNotificationName:kLocationFailedNotification object:nil];
    
    [self stopLocation];
}

@end
