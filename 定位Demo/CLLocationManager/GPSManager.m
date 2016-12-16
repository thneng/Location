//
//  GPSManager.m
//  SunshineHealthy
//
//  Created by kr on 2016/10/20.
//  Copyright © 2016年 深圳市凯如科技有限公司. All rights reserved.
//

#import "GPSManager.h"


@implementation GPSManager

+ (GPSManager*)shareGpsManger
{
    static GPSManager *gpsManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gpsManager = [[self alloc]init];
    });
    return gpsManager;
}
- (void)startGps
{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = (id)self;
    //设置定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //请求授权
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}
- (void)stopGps
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
}
- (void)goSetUpGps:(UIViewController *)vc
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"未开启定位,当前位置服务未开启" message:@"请在设置当中开启定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}
#pragma mark --CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取定位点
    CLLocation *location =locations.lastObject;
    //NSLog(@"经度:%f,纬度:%f",location.coordinate.longitude,location.coordinate.latitude);
    // 解析地址
    CLGeocoder *geocoder = [[CLGeocoder alloc ]init];
    __block CLPlacemark *placemark;
    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            NSString *city = @"";
            if (placemarks.count>0 && !error)
            {
                placemark=[placemarks lastObject];
                //获取城市
                city = [NSString stringWithFormat:@"%@ %@ %@",placemark.administrativeArea,placemark.locality,placemark.subLocality];
            }else
            {
                //NSLog(@"%@",error);
            }
            self.currentGpsModel = [GPSModel cityModelWithCity:city
                                                   longitude:location.coordinate.longitude
                                                     latiude:location.coordinate.latitude];
        //使用完就立即关闭定位服务
        [manager stopUpdatingLocation];
        //定位完毕后返回城市模型
        if ([self.gpsDelegate respondsToSelector:@selector(GPSManagerDidLocated:location:success:)])
        {
            [self.gpsDelegate GPSManagerDidLocated:self.currentGpsModel location:location success:YES];
        }
    }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied)
    {
        //定位失败
        if ([self.gpsDelegate respondsToSelector:@selector(GPSManagerDidLocated:location:success:)]) {
            [self.gpsDelegate GPSManagerDidLocated:nil location:nil success:NO];
        }
        return;
    }
    if ([error code] == kCLErrorLocationUnknown) {
        //无法获取位置信息
        return;
    }
    [manager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [manager requestWhenInUseAuthorization];
                [manager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
- (BOOL)gpsState
{
    if (!_gpsState) {
        _gpsState = [CLLocationManager locationServicesEnabled];
        
    }
    return _gpsState;
}






















@end
