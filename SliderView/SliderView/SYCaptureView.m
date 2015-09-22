//
//  SYCaptureView.m
//  SliderView
//
//  Created by guoyi on 15/9/22.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "SYCaptureView.h"

#import <AVFoundation/AVFoundation.h>

@implementation SYCaptureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _prepareData];
        [self _prepareUI];
    }
    return self;
}

- (void)_prepareData {

}

- (void)_prepareUI {
    
    /// 拍摄场景
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    /// 拍摄设备
    AVCaptureDevice *backDevice = nil;
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            if ([device position] == AVCaptureDevicePositionBack) {
                backDevice = device;
                break;
            }
        }
    }
    NSError *inputError = nil;
    /// 输入设备
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backDevice error:&inputError];
    if (inputError) {
        NSLog(@"inputError = %@",inputError);
    }
    
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    
    /// 显示层
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = self.bounds;
    [self.layer addSublayer:captureVideoPreviewLayer];
    
    [session startRunning];
    
}

@end
