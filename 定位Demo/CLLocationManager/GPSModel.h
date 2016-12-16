//
//  GPSModel.h
//  SunshineHealthy
//
//  Created by kr on 2016/10/20.
//  Copyright © 2016年 深圳市凯如科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSModel : NSObject
///城市名称
@property(nonatomic, copy)NSString  *city;
///经度
@property(nonatomic, assign)double longitude;
///纬度
@property(nonatomic, assign)double latiude;

- (instancetype)initWithCity:(NSString*)city
                   longitude:(double)longitude
                     latiude:(double)latiude;

+ (instancetype)cityModelWithCity:(NSString*)city
                        longitude:(double)longitude
                          latiude:(double)latiude;

@end
