//
//  LocationCenter.m
//  WeiYP
//
//  Created by erisenxu on 16/5/25.
//  Copyright © 2016年 @itfriday. All rights reserved.
//

#import "LocationCenter.h"
//#import "NetConstants.h"
//#import "Reachability.h"
//#import "Log.h"
typedef void(^ReturnBlock)(NSDictionary *dic);

#import <CoreLocation/CoreLocation.h>

@interface LocationCenter () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* locMgr;

@property(nonatomic,strong) ReturnBlock returnBlock;

@end

@implementation LocationCenter
- (void)locationWithBlock:(void (^) (NSDictionary *dic)) returnBlock {

    self.returnBlock = returnBlock;
}
/**
 * 构造函数
 */
- (instancetype)init {
    if (self = [super init]) {
        [self initLocationManager];
    }
    return self;
}

/**
 * 析构函数
 */
- (void)dealloc {
    // 停止定位服务
    [_locMgr stopUpdatingLocation];
}

/**
 * 初始化位置管理器
 */
- (void) initLocationManager {
    self.locMgr = [[CLLocationManager alloc] init];
    self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
    self.locMgr.distanceFilter = 100;       // 设置每隔100米更新位置
    self.locMgr.delegate = self;
    // 请求在使用时使用位置权限，同时需要在info.plist中添加NSLocationWhenInUseUsageDescription项
    [_locMgr requestWhenInUseAuthorization];
    // 如果是always需要权限，需要调用如下函数，并在info.plist中添加NSLocationAlwaysUsageDescription项
    [self.locMgr requestAlwaysAuthorization];
//     开始定位服务
    [self.locMgr startUpdatingLocation];
}

#pragma mark delegate - CLLocationManagerDelegate

/**
 * 位置更新委托
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* loc = [locations lastObject];
    CLLocationCoordinate2D loc2d = [loc coordinate];
    [self updateCurrentCity:loc2d.latitude longitude:loc2d.longitude];
}

/**
 * 获取城市信息
 */
- (void) updateCurrentCity:(double)latitude longitude:(double)longitude {
    
    // 判断网络是否可用
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
//        //if (complement) complement(NO);
//        return;
//    }
    // 通过腾讯地图的API接口，查询城市
    // 接口文档http://lbs.qq.com/webservice_v1/guide-gcoder.html
    NSString *url = [NSString stringWithFormat:@"http://apis.map.qq.com/ws/geocoder/v1/?location=%lf,%lf&key=RY6BZ-2M5KV-GVIPJ-UUKJJ-NIB4K-RRFGL&get_poi=0", latitude, longitude];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:20];
    NSURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    if (!error) {
        id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:0 error:Nil];
        int status = [[jsonObj valueForKey:@"status"] intValue];
        
        if (status != 0) {
            // 错误
        } else {
            id resultObj = [jsonObj valueForKey:@"result"];
            id adinfoObj = [resultObj valueForKey:@"ad_info"];
            NSString *name = [adinfoObj valueForKey:@"name"];
            NSString *city = [adinfoObj valueForKey:@"city"];
            NSString *adcode = [adinfoObj valueForKey:@"adcode"];
            
//            // TODO: 这里可以用一个delegate，发给调用端
//            LOGING_DEBUG(@"name=%@, city=%@, adcode=%@", name, city, adcode);
            self.returnBlock(@{@"name":name,@"city":city,@"adcode":adcode});
        }
    }
}

@end
