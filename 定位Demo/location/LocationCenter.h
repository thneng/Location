//
//  LocationCenter.h
//  WeiYP
//
//  Created by erisenxu on 16/5/25.
//  Copyright © 2016年 @itfriday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationCenter : NSObject

- (void)locationWithBlock:(void (^) (NSDictionary *dic)) returnBlock;

@end
