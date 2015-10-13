//
//  SYPlotView.m
//  Motion
//
//  Created by guoyi on 15/10/13.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "SYPlotView.h"

@interface SYPlotView ()
{
    //  Data
    /// 记录所有点的数组
    NSMutableArray<NSNumber *> *_numberList1;
    /// 记录所有点的数组
    NSMutableArray<NSNumber *> *_numberList2;
    /// 记录所有点的数组
    NSMutableArray<NSNumber *> *_numberList3;
    
}

@end


/// 数组最大值
static NSUInteger Count_NumberList = 20;

/// 描点 Y轴 零点坐标
static CGFloat Origin_Y = 50.0f;

/// 描点 X轴 零点坐标
static CGFloat Origin_X = 10.0f;

/// Y轴 缩放比
static CGFloat Scale_Y = 20;

@implementation SYPlotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberList1 = [NSMutableArray arrayWithCapacity:Count_NumberList];
        _numberList2 = [NSMutableArray arrayWithCapacity:Count_NumberList];
        _numberList3 = [NSMutableArray arrayWithCapacity:Count_NumberList];
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    /// 最上面的分界线
    UIBezierPath *topBezierPath = [UIBezierPath bezierPath];
    [topBezierPath moveToPoint:CGPointMake(0, 0)];
    [topBezierPath addLineToPoint:CGPointMake(CGRectGetWidth(self.frame), 0)];
    [[UIColor grayColor] setStroke];
    topBezierPath.lineWidth = 0.5f;
    [topBezierPath stroke];
    
    if (_numberList1.count) {
        [self _drawBezierPathWithPointList:_numberList1 andLineColor:[UIColor redColor]];
    }
    
    if (_numberList2.count) {
        [self _drawBezierPathWithPointList:_numberList2 andLineColor:[UIColor yellowColor]];
    }
    
    if (_numberList3.count) {
        [self _drawBezierPathWithPointList:_numberList3 andLineColor:[UIColor greenColor]];
    }
}

/// 根据点 画线
- (void)_drawBezierPathWithPointList:(NSArray *)pointList andLineColor:(UIColor *)lineColor {
    /// 以第一个点为起点开始画
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(Origin_X, Origin_Y + [pointList.firstObject floatValue] * Scale_Y)];
    
    //  画所有的点
    NSUInteger count = pointList.count;
    for (unsigned int i = 1; i < count - 1; i ++) {
        /// x轴间隔
        CGFloat padding_x = (CGRectGetWidth(self.frame) - Origin_X * 2) / Count_NumberList + 2;
        [bezierPath addLineToPoint:CGPointMake(Origin_X + padding_x * i, Origin_Y + [pointList[i] floatValue] * Scale_Y)];
    }
    //  颜色
    [lineColor setStroke];
    //  宽度
    bezierPath.lineWidth = 1.0f;
    //  描线
    [bezierPath stroke];

}

#pragma mark - Public Methods

/// 添加曲线的点 传进来一个 浮点型的值
- (void)addNumber:(NSNumber *)number {
    if (_numberList1.count >= Count_NumberList) {
        [_numberList1 removeObjectsInRange:NSMakeRange(0, Count_NumberList - _numberList1.count + 1)];
    }
    [_numberList1 addObject:number];
    [self setNeedsDisplay];
}

/// 添加 三个曲线
- (void)addNumber1:(NSNumber *)number1 number2:(NSNumber *)number2 number3:(NSNumber *)number3 {
    if (_numberList1.count >= Count_NumberList) {
        [_numberList1 removeObjectsInRange:NSMakeRange(0, Count_NumberList - _numberList1.count + 1)];
    }
    [_numberList1 addObject:number1];
    
    if (_numberList2.count >= Count_NumberList) {
        [_numberList2 removeObjectsInRange:NSMakeRange(0, Count_NumberList - _numberList2.count + 1)];
    }
    [_numberList2 addObject:number2];
    
    if (_numberList3.count >= Count_NumberList) {
        [_numberList3 removeObjectsInRange:NSMakeRange(0, Count_NumberList - _numberList3.count + 1)];
    }
    [_numberList3 addObject:number3];
    
    [self setNeedsDisplay];
}

@end
