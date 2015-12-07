//
//  ViewController.m
//  ScrollView
//
//  Created by guoyi on 15/11/4.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "ViewController.h"

#import "Masonry.h"

@interface ViewController ()
{
    //  UI
    
    /// 第一个视图
    UIView *_view1;
    /// 第二个视图
    UIView *_view2;
    /// 当前展示的视图
    
    /// 触摸开始的点
    CGPoint _startTouchPoint;
    /// 触摸开始的视图坐标
    CGRect _startViewRect;
    
    /// 上一个触摸过程中的点
    CGFloat _moveTouchPoint_x;
    /// 触摸移动的偏差
    CGFloat _moveTouchOffset_x;
    
    /// 减速Timer
    NSTimer *_decelerationTimer;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _moveTouchPoint_x = 0;

    __weak UIView *weakSelfView = self.view;
    
    _view1 = [[UIView alloc] init];
    _view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:_view1];
    [_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelfView);
        make.top.equalTo(weakSelfView);
        make.width.equalTo(weakSelfView).offset(50);
        make.height.equalTo(weakSelfView).offset(-50);
    }];
    
    _view2 = [[UIView alloc] init];
    _view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_view2];
    [_view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_view1.mas_right);
        make.top.equalTo(weakSelfView);
        make.width.equalTo(weakSelfView).offset(50);
        make.height.equalTo(weakSelfView).offset(-50);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _startTouchPoint = [touches.anyObject locationInView:self.view];
    _startViewRect = touches.anyObject.view.frame;
    [_decelerationTimer invalidate];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    UIView *view = touch.view;
    CGPoint point = [touch locationInView:self.view];
    
    if (view == _view1 || view == _view2) {
        //  位移触摸的视图
        CGRect rect = view.frame;
        rect.origin.x = _startViewRect.origin.x + (point.x - _startTouchPoint.x);
        view.frame = rect;
        
        //  位移右面视图
        if (view.frame.origin.x + view.frame.size.width <= CGRectGetWidth(self.view.frame)) {
            //  需要位移
            if (view == _view1) {
                //  位移 view2
                CGRect rect_view2 = _view2.frame;
                rect_view2.origin.x = CGRectGetMaxX(rect);
                _view2.frame = rect_view2;
            } else if (view == _view2) {
                //  位移 view 1
                CGRect rect_view1 = _view1.frame;
                rect_view1.origin.x = CGRectGetMaxX(rect);
                _view1.frame = rect_view1;
            }
        }
        
        //  位移左边视图
        if (view.frame.origin.x > 0 && view.frame.origin.x < CGRectGetWidth(self.view.frame)) {
            if (view == _view1) {
                //  位移 View2
                CGRect rect_view2 = _view2.frame;
                rect_view2.origin.x = CGRectGetMinX(rect) - CGRectGetWidth(rect_view2);
                _view2.frame = rect_view2;
            } else if (view == _view2) {
                //  位移 View1
                CGRect rect_view1 = _view1.frame;
                rect_view1.origin.x = CGRectGetMinX(rect) - CGRectGetWidth(rect_view1);
                _view1.frame = rect_view1;
            }
        }
        if (_moveTouchPoint_x) {
            _moveTouchOffset_x = point.x - _moveTouchPoint_x;
        }
        _moveTouchPoint_x = point.x;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    UIView *view = touch.view;
    if (view == _view1 || view == _view2) {
        _moveTouchOffset_x = _moveTouchOffset_x;
        [_decelerationTimer invalidate];
        _decelerationTimer = nil;
        _decelerationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                              target:self
                                                            selector:@selector(decelerationTimerAction:)
                                                            userInfo:@{
                                                                       @"view":view
                                                                       }
                                                             repeats:YES];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

#pragma mark - Private Methods

- (void)decelerationTimerAction:(NSTimer *)timer {
    
    UIView *view = timer.userInfo[@"view"];
    NSLog(@"view = %@  rate = %f",view,_moveTouchOffset_x);
    
    CGFloat abs_deceleration = fabs(_moveTouchOffset_x);
    
    abs_deceleration -= 15;
    
    _moveTouchOffset_x = _moveTouchOffset_x > 0 ? abs_deceleration : -abs_deceleration;
    
    if (abs_deceleration <= 0) {
        [timer invalidate];
    }
    
    //  更新view坐标
    CGRect rect = view.frame;
    rect.origin.x += _moveTouchOffset_x;
    view.frame = rect;
}

@end
