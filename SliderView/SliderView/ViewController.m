//
//  ViewController.m
//  SliderView
//
//  Created by guoyi on 15/9/21.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "ViewController.h"


#import "SYGameView.h"
#import "SYCaptureView.h"

@interface ViewController ()
{
    SYGameView *_gameView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /// 相机视图
    SYCaptureView *captureView = [[SYCaptureView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:captureView];
    
    /// 瞄准视图
    _gameView = [[SYGameView alloc] initWithFrame:CGRectMake(0, 20,
                                                             CGRectGetWidth(self.view.frame),
                                                             CGRectGetHeight(self.view.frame) - 20)];
    _gameView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_gameView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
