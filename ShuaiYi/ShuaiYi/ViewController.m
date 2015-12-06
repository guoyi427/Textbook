//
//  ViewController.m
//  ShuaiYi
//
//  Created by 郭毅 on 15/10/21.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "MovieListViewController.h"

#import "GPUImage.h"

@interface ViewController ()
<
//AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureFileOutputRecordingDelegate
>
{
    //  Data
    /// 后置摄像头
    AVCaptureDevice *_backCaptureDevice;
    /// 前置摄像头
    AVCaptureDevice *_frontCaptureDevice;
    /// 导出文件 output
    AVCaptureMovieFileOutput *_movieFileOutput;
    /// 当前摄像头方向
    BOOL _isCurrentBackCaptureDevice;
    /// 拍摄会话
    AVCaptureSession *_captureSession;
    
    //  UI
    /// 录制 完成 按钮
    UIButton *_recorderButton;
    /// 前后置摄像头标志
    UIView *_captureDeviceFlagView;
    
    //  GPU
    GPUImageVideoCamera *_videoCamera;
    GPUImageMovieWriter *_movieWriter;
    /// 磨皮
    GPUImageBilateralFilter<GPUImageInput> *_filter1;
    GPUImageBrightnessFilter<GPUImageInput> *_filter2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
//    [self _prepareCapture];
    [self _prepareGPUImage_Capture];
    [self _prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - prepare

- (void)_prepareData {

}

- (void)_prepareCapture {
    /// 拍摄会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    /// 设备
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *tempDevice in devices) {
        //  判断 设备位置
        if (tempDevice.position == AVCaptureDevicePositionBack) {
            //  后置摄像头
            _backCaptureDevice = tempDevice;
        } else if (tempDevice.position == AVCaptureDevicePositionFront) {
            //  前置摄像头
            _frontCaptureDevice = tempDevice;
        }
    }
    
    NSError *error = nil;
    /// 输入
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_backCaptureDevice error:&error];
    /// 输出
    _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //  添加 输入 输出管理
    if ([_captureSession canAddInput:deviceInput]) {
        [_captureSession addInput:deviceInput];
        _isCurrentBackCaptureDevice = YES;
    }
    if ([_captureSession canAddOutput:_movieFileOutput]) {
        [_captureSession addOutput:_movieFileOutput];
    }
    
    //  添加 展示视图
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    //  拍摄会话开启
    [_captureSession startRunning];
}

/// 准备GPUImage
- (void)_prepareGPUImage_Capture {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    /// 磨皮
    _filter1 = [[GPUImageBilateralFilter alloc] init];
    [_videoCamera addTarget:_filter1];
    
    /// 美白
    _filter2 = [[GPUImageBrightnessFilter alloc] init];
    [_videoCamera addTarget:_filter2];
    
    /// 滤镜组
//    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
//    filterGroup.initialFilters = @[_filter1,_filter2];
//    filterGroup.terminalFilter = _filter1;
//    [_videoCamera addTarget:filterGroup];

    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:filterView];
    
    [_filter1 addTarget:filterView];
    [_filter2 addTarget:filterView];
    [_videoCamera startCameraCapture];
    
}

- (void)_prepareUI {
    self.view.backgroundColor = [UIColor whiteColor];
//    [self _prepareRecoderUI];
    [self _prepareFilterUI];
}

/// 录像UI
- (void)_prepareRecoderUI {
    /// 录制 完成 按钮
    _recorderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recorderButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) / 2 - 25,
                                       CGRectGetHeight(self.view.frame) - 50,
                                       50, 50);
    _recorderButton.backgroundColor = [UIColor whiteColor];
    _recorderButton.layer.cornerRadius = 25.0f;
    _recorderButton.layer.masksToBounds = YES;
    [_recorderButton addTarget:self action:@selector(_startRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recorderButton];
    
    /// 查看视频列表页面
    UIButton *pushMovieListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushMovieListButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 50,
                                           CGRectGetHeight(self.view.frame) - 50,
                                           50, 50);
    pushMovieListButton.backgroundColor = [UIColor whiteColor];
    [pushMovieListButton addTarget:self action:@selector(pushMoiveListButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushMovieListButton];
    
    /// 切换前后摄像头
    UILongPressGestureRecognizer *changeCaptureDeviceGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeCaptureDeviceGestureRecognizer:)];
    changeCaptureDeviceGR.numberOfTouchesRequired = 2;
    changeCaptureDeviceGR.minimumPressDuration = 1.0f;
    [self.view addGestureRecognizer:changeCaptureDeviceGR];
    
    _captureDeviceFlagView = [[UIView alloc] initWithFrame:CGRectMake(10, 74, 5, 5)];
    _captureDeviceFlagView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_captureDeviceFlagView];

}

- (void)_prepareFilterUI {
    UISlider *bilateralFilterSlider = [[UISlider alloc] initWithFrame:CGRectMake(20,
                                                                                 CGRectGetHeight(self.view.frame) - 70,
                                                                                 CGRectGetWidth(self.view.frame) - 40,
                                                                                  30)];
    [bilateralFilterSlider addTarget:self action:@selector(bilateralFilterSliderAction:) forControlEvents:UIControlEventValueChanged];
    bilateralFilterSlider.minimumValue = 0.0f;
    bilateralFilterSlider.maximumValue = 20.0f;
    [self.view addSubview:bilateralFilterSlider];
    
    UISlider *brightnessFilterSlider = [[UISlider alloc] initWithFrame:CGRectMake(20,
                                                                                  CGRectGetHeight(self.view.frame) - 30,
                                                                                  CGRectGetWidth(self.view.frame) - 40,
                                                                                  30)];
    [brightnessFilterSlider addTarget:self action:@selector(brightnessFilterSliderAction:) forControlEvents:UIControlEventValueChanged];
    brightnessFilterSlider.minimumValue = 0.0f;
    brightnessFilterSlider.maximumValue = 0.2f;
    [self.view addSubview:brightnessFilterSlider];
}

#pragma mark - Private Methods 

- (void)_startRecording {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = paths.firstObject;
    
    NSURL* saveLocationURL = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/movie%.0f.mov", documentsDirectory,[[NSDate date] timeIntervalSince1970]]];
    
    [_movieFileOutput startRecordingToOutputFileURL:saveLocationURL
                                  recordingDelegate:self];
    
    [_recorderButton addTarget:self action:@selector(_stopRecoreding) forControlEvents:UIControlEventTouchUpInside];
    _recorderButton.backgroundColor = [UIColor redColor];
}

- (void)_stopRecoreding {
    [_movieFileOutput stopRecording];
    [_recorderButton addTarget:self action:@selector(_startRecording) forControlEvents:UIControlEventTouchUpInside];
    _recorderButton.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Button Action

/// 跳转电影列表
- (void)pushMoiveListButtonAction {
    MovieListViewController *movieListVC = [[MovieListViewController alloc] init];
    [self.navigationController pushViewController:movieListVC animated:YES];
}

/// 切换摄像头
- (void)changeCaptureDeviceGestureRecognizer:(UILongPressGestureRecognizer *)longPressGR {

    if (longPressGR.state == UIGestureRecognizerStateBegan) {
        NSError *error = nil;
        [_captureSession beginConfiguration];
        [_captureSession removeInput:_captureSession.inputs.firstObject];
        if (_isCurrentBackCaptureDevice) {
            //  后置
            AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_frontCaptureDevice error:&error];
            if ([_captureSession canAddInput:deviceInput]) {
                [_captureSession addInput:deviceInput];
                _isCurrentBackCaptureDevice = NO;
                _captureDeviceFlagView.backgroundColor = [UIColor redColor];
            }
        } else {
            //  前置
            AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_backCaptureDevice error:&error];
            if ([_captureSession canAddInput:deviceInput]) {
                [_captureSession addInput:deviceInput];
                _isCurrentBackCaptureDevice = YES;
                _captureDeviceFlagView.backgroundColor = [UIColor greenColor];
            }
        }
        [_captureSession commitConfiguration];
    }
}

/// 磨皮滤镜滚动条
- (void)bilateralFilterSliderAction:(UISlider *)slider {
    NSLog(@"磨皮value = %f",slider.value);
    _filter1.distanceNormalizationFactor = 25 - slider.value;
}

/// 美白滤镜滚动条
- (void)brightnessFilterSliderAction:(UISlider *)slider {
    NSLog(@"美白value = %f",slider.value);
    _filter2.brightness = slider.value;
}


#pragma mark - AVCaptureVideoOutput Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"结束录制");
    NSLog(@"outputFile = %@",outputFileURL.absoluteString);
}

@end
