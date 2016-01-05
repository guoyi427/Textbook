//
//  AIBluetoothManager.m
//  AIInsole
//
//  Created by guoyi on 16/1/5.
//  Copyright © 2016年 郭毅. All rights reserved.
//

#import "AIBluetoothManager.h"

#import <CoreBluetooth/CoreBluetooth.h>

static NSString *UUID_String = @"1111";

@interface AIBluetoothManager () <CBCentralManagerDelegate,CBPeripheralManagerDelegate>
{
    /// 总机管理
    CBCentralManager *_centralManager;
    /// 外部设备管理
    CBPeripheralManager *_peripheralManager;
}

@end

@implementation AIBluetoothManager

+ (instancetype)sharedBluetooth {
    static AIBluetoothManager *m_bluetooth = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_bluetooth = [[AIBluetoothManager alloc] init];
    });
    return m_bluetooth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t queue_bluetooth = dispatch_queue_create("bluetooth", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:queue_bluetooth];
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:queue_bluetooth];
    }
    return self;
}

#pragma mark - Public Methods

/// 开始扫描
- (void)scan {
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:UUID_String]]
                                            options:@{
                                                      CBCentralManagerScanOptionSolicitedServiceUUIDsKey : @[[CBUUID UUIDWithString:UUID_String]],
                                                      CBCentralManagerScanOptionAllowDuplicatesKey : @NO
                                                      }];
}

/// 开始广播
- (void)startAdvertising {
    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:UUID_String] primary:YES];
    [_peripheralManager addService:service];
}


#pragma mark - CentralManager - Delegate

//  蓝牙总机 更新状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"扫描总机 蓝牙状态未知");
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"扫描总机 蓝牙未被授权");
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"扫描总机 不支持蓝牙");
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"扫描总机 蓝牙关闭");
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"扫描总机 蓝牙开启");
        }
            break;
        case CBCentralManagerStateResetting:
        {
            NSLog(@"扫描总机 蓝牙重启");
        }
            break;
            
            
        default:
            break;
    }
}

//  蓝牙总机 扫描到设备
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    NSLog(@"discover %@ rssi = %@ advertisementData = %@",peripheral.name,RSSI,advertisementData);
}



#pragma mark - PeripheralManager - Delegate

//  蓝牙外部设备 更新状态
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
        {
            NSLog(@"外部设备 未知");
        }
            break;
        case CBPeripheralManagerStateUnauthorized:
        {
            NSLog(@"外部设备 蓝牙功能未授权");
        }
            break;
        case CBPeripheralManagerStateUnsupported:
        {
            NSLog(@"外部设备 不支持蓝牙");
        }
            break;
        case CBPeripheralManagerStatePoweredOff:
        {
            NSLog(@"外部设备 蓝牙关闭");
        }
            break;
        case CBPeripheralManagerStatePoweredOn:
        {
            NSLog(@"外部设备 蓝牙开启");
        }
            break;
        case CBPeripheralManagerStateResetting:
        {
            NSLog(@"外部设备 重启");
        }
            break;
        default:
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    if (error) {
        NSLog(@"Add service error = %@",error);
        exit(1);
    }
    [_peripheralManager startAdvertising:@{
                                           CBAdvertisementDataLocalNameKey : @"GuoYi",
                                           CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:UUID_String]]
                                           }];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
    if (error) {
        NSLog(@"Advertising fail error = %@",error);
    } else {
        NSLog(@"Advertising %@",peripheral);
    }
    
}

@end
