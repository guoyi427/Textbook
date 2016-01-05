//
//  AIBluetoothManager.h
//  AIInsole
//
//  Created by guoyi on 16/1/5.
//  Copyright © 2016年 郭毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIBluetoothManager : NSObject

/// 单例
+ (instancetype)sharedBluetooth;

/// 开始扫描
- (void)scan;

/// 开始广播
- (void)startAdvertising;

@end
