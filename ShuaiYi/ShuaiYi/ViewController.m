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

@interface ViewController ()
<
//AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureFileOutputRecordingDelegate
>
{
    /// 后置摄像头
    AVCaptureDevice *_backCaptureDevice;
    /// 前置摄像头
    AVCaptureDevice *_frontCaptureDevice;
    
    /// 导出文件 output
    AVCaptureMovieFileOutput *_movieFileOutput;
    
    //  UI
    /// 录制 完成 按钮
    UIButton *_recorderButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareCapture];
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
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
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
    if ([session canAddInput:deviceInput]) {
        [session addInput:deviceInput];
    }
    if ([session canAddOutput:_movieFileOutput]) {
        [session addOutput:_movieFileOutput];
    }
    
    //  添加 展示视图
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    //  拍摄会话开启
    [session startRunning];
}

- (void)_prepareUI {
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

- (void)pushMoiveListButtonAction {
    MovieListViewController *movieListVC = [[MovieListViewController alloc] init];
    [self.navigationController pushViewController:movieListVC animated:YES];
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
