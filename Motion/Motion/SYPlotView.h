//
//  SYPlotView.h
//  Motion
//
//  Created by guoyi on 15/10/13.
//  Copyright © 2015年 郭毅. All rights reserved.
//  SY 为 帅毅 或者 傻金 的缩写
//  曲线图

#import <UIKit/UIKit.h>

@interface SYPlotView : UIView

/// 添加曲线的点
- (void)addNumber:(NSNumber *)number;

/// 添加 三个曲线
- (void)addNumber1:(NSNumber *)number1 number2:(NSNumber *)number2 number3:(NSNumber *)number3;

@end
