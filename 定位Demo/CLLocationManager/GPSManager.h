//
//  GPSManager.h
//  SunshineHealthy
//
//  Created by kr on 2016/10/20.
//  Copyright © 2016年 深圳市凯如科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSModel.h"
#import <CoreLocation/CoreLocation.h>
@protocol GPSLocationMangerDelegate<NSObject>

- (void)GPSManagerDidLocated:(GPSModel*)model
                    location:(CLLocation *)location
                     success:(BOOL)success;
@end

@interface GPSManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong)GPSModel *currentGpsModel;
@property (nonatomic, weak)id <GPSLocationMangerDelegate> gpsDelegate;
@property (nonatomic, strong)CLLocationManager *locationManager;
///授权状态
@property (nonatomic, assign)BOOL gpsState;


+ (GPSManager*)shareGpsManger;

/**
 开启定位
 */
- (void)startGps;

/**
 未开启定位去设置
 
 @param vc 控制器
 */
- (void)goSetUpGps:(UIViewController*)vc;
/**
 关闭定位
 */
- (void)stopGps;
@end
