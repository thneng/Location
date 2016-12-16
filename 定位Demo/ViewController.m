//
//  ViewController.m
//  定位Demo
//
//  Created by kairu on 16/11/1.
//  Copyright © 2016年 凯如科技. All rights reserved.
//

#import "ViewController.h"
#import "LocationCenter.h"
#import "GPSManager.h"
#import "GPSModel.h"
@interface ViewController ()<GPSLocationMangerDelegate>

@property (nonatomic, strong) LocationCenter *locationCenter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    // 定位方法1:  ----block方式
    self.locationCenter = [LocationCenter new]; // 必须要用属性进行强引用,否则弹出框后locationCenter对象会立马销毁.
    [self.locationCenter locationWithBlock:^(NSDictionary *dic) {
        NSLog(@"%@,%@,%@",dic[@"name"],dic[@"city"],dic[@"adcode"]);
    }];
    
    // 定位方法2:  ----Delegate方式
//    [GPSManager shareGpsManger].gpsDelegate = self;
//    [[GPSManager shareGpsManger]startGps];
//    
}


#pragma mark - GPSLocationMangerDelegate
-(void)GPSManagerDidLocated:(GPSModel *)model location:(CLLocation *)location success:(BOOL)success
{
    if (success) {
        NSLog(@"%@",model.city);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
