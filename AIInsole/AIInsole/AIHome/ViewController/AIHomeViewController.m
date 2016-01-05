//
//  AIHomeViewController.m
//  AIInsole
//
//  Created by guoyi on 16/1/4.
//  Copyright © 2016年 郭毅. All rights reserved.
//

#import "AIHomeViewController.h"

//  Manager
#import "AIBluetoothManager.h"

@interface AIHomeViewController ()
{
    NSTimer *_scanTimer;
}
@end

@implementation AIHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    [AIBluetoothManager sharedBluetooth];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    scanButton.frame = CGRectMake(10, 100, 50, 50);
    scanButton.backgroundColor = [UIColor redColor];
    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];

    UIButton *startAdvertisingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startAdvertisingButton.frame = CGRectMake(70, 100, 50, 50);
    startAdvertisingButton.backgroundColor = [UIColor yellowColor];
    [startAdvertisingButton setTitle:@"广播" forState:UIControlStateNormal];
    [startAdvertisingButton addTarget:self action:@selector(startAdvertisingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startAdvertisingButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (void)scanButtonAction {
    if (_scanTimer) {
        [_scanTimer invalidate];
        _scanTimer = nil;
    }
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scanTimerAction) userInfo:nil repeats:YES];
}

- (void)startAdvertisingButtonAction {
    [[AIBluetoothManager sharedBluetooth] startAdvertising];
}

#pragma mark - Private Methods

- (void)scanTimerAction {
    NSLog(@"__%s__",__FUNCTION__);
    [[AIBluetoothManager sharedBluetooth] scan];
}

@end
