//
//  GPSModel.m
//  SunshineHealthy
//
//  Created by kr on 2016/10/20.
//  Copyright © 2016年 深圳市凯如科技有限公司. All rights reserved.
//

#import "GPSModel.h"

@implementation GPSModel
+ (instancetype)cityModelWithCity:(NSString*)city
                        longitude:(double)longitude
                          latiude:(double)latiude
{
    GPSModel *model = [[GPSModel alloc]initWithCity:city longitude:longitude latiude:latiude];
    return model;
}
- (instancetype)initWithCity:(NSString*)city
                   longitude:(double)longitude
                     latiude:(double)latiude;
{
    if (self=[super init]) {
        self.city = city;
        self.longitude = longitude;
        self.latiude = latiude;
    }
    return self;
}

@end
