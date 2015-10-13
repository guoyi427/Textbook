//
//  ViewController.m
//  Motion
//
//  Created by guoyi on 15/10/13.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "ViewController.h"

//  View
#import "SYPlotView.h"

//  Manager
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
{
    //  Data
    /// 计时器
    NSTimer *_timer;
    /// 屏幕尺寸
    CGSize _screenSize;
    
    //  Manager
    /// 动作管理
    CMMotionManager *_motionManager;
    
    //  UI
    /// 统计图 加速计
    SYPlotView *_plotView_accelerometer;
    /// 统计图 空间方位
    SYPlotView *_plotView_motion_attitude;
    /// 统计图 旋转角
    SYPlotView *_plotView_motion_rotationRate;
    /// 统计图 重力角度
    SYPlotView *_plotView_motion_gravity;
    /// 统计图 磁场
    SYPlotView *_plotView_magnetometer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(_update) userInfo:nil repeats:YES];
    _screenSize = [UIScreen mainScreen].bounds.size;
    /// 准备动作管理
    _motionManager = [[CMMotionManager alloc] init];
    [_motionManager startAccelerometerUpdates];
    [_motionManager startGyroUpdates];
    [_motionManager startMagnetometerUpdates];
    [_motionManager startDeviceMotionUpdates];
    
}

- (void)_prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _plotView_accelerometer = [[SYPlotView alloc] initWithFrame:CGRectMake(0, 20, _screenSize.width, 100)];
    [self.view addSubview:_plotView_accelerometer];

    
    _plotView_motion_attitude = [[SYPlotView alloc] initWithFrame:CGRectMake(0, 130, _screenSize.width, 100)];
    [self.view addSubview:_plotView_motion_attitude];
    
    _plotView_motion_rotationRate = [[SYPlotView alloc] initWithFrame:CGRectMake(0, 240, _screenSize.width, 100)];
    [self.view addSubview:_plotView_motion_rotationRate];
    
    _plotView_motion_gravity = [[SYPlotView alloc] initWithFrame:CGRectMake(0, 350, _screenSize.width, 100)];
    [self.view addSubview:_plotView_motion_gravity];
    
    _plotView_magnetometer = [[SYPlotView alloc] initWithFrame:CGRectMake(0, 460, _screenSize.width, 100)];
    [self.view addSubview:_plotView_magnetometer];
}

#pragma mark - Private Methods

- (void)_update {
    [_plotView_accelerometer addNumber1:[NSNumber numberWithFloat:_motionManager.accelerometerData.acceleration.x]
                                number2:[NSNumber numberWithFloat:_motionManager.accelerometerData.acceleration.y]
                                number3:[NSNumber numberWithFloat:_motionManager.accelerometerData.acceleration.z]];
    
    [_plotView_motion_attitude addNumber1:[NSNumber numberWithFloat:_motionManager.deviceMotion.attitude.roll]
                                  number2:[NSNumber numberWithFloat:_motionManager.deviceMotion.attitude.pitch]
                                  number3:[NSNumber numberWithFloat:_motionManager.deviceMotion.attitude.yaw]];
    
    [_plotView_motion_rotationRate addNumber1:[NSNumber numberWithFloat:_motionManager.deviceMotion.rotationRate.x]
                                      number2:[NSNumber numberWithFloat:_motionManager.deviceMotion.rotationRate.y]
                                      number3:[NSNumber numberWithFloat:_motionManager.deviceMotion.rotationRate.z]];
    
    [_plotView_motion_gravity addNumber1:[NSNumber numberWithFloat:_motionManager.deviceMotion.gravity.x]
                                 number2:[NSNumber numberWithFloat:_motionManager.deviceMotion.gravity.y]
                                 number3:[NSNumber numberWithFloat:_motionManager.deviceMotion.gravity.z]];
    
    [_plotView_magnetometer addNumber1:[NSNumber numberWithFloat:_motionManager.magnetometerData.magneticField.x]
                               number2:[NSNumber numberWithFloat:_motionManager.magnetometerData.magneticField.y]
                               number3:[NSNumber numberWithFloat:_motionManager.magnetometerData.magneticField.z]];
    NSLog(@"x = %f y = %f z = %f",
          _motionManager.magnetometerData.magneticField.x,
          _motionManager.magnetometerData.magneticField.y,
          _motionManager.magnetometerData.magneticField.z);
    
}

@end
