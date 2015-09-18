//
//  UIColor+ShuaiYi.m
//  1024
//
//  Created by guoyi on 15/9/10.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "UIColor+ShuaiYi.h"

//  Model
#import "SYGameCellModel.h"

@implementation UIColor(ShuaiYi)

/// 根据number 返回对应背景颜色
+ (UIColor *)colorWithNumber:(NSUInteger)number {
    /// count
    float count = [SYGameCellModel instance].count_gameCell * [SYGameCellModel instance].count_gameCell;
    
    /// 颜色最大值
    float maxColorValue = 200.0f;
    
    float r,g,b;
    r = number < (2.0f / 5.0f * count) ? number / 30.0f * maxColorValue / 255.0f : maxColorValue / 255.0f;
    
    //  无色 为 黑色
    UIColor *color = [UIColor colorWithRed:0
                                     green:0
                                      blue:0
                                     alpha:1];
    return color;
}

/// 根据number 返回 对于那个 字体颜色 （背景色的反色）
+ (UIColor *)inverseColorWithNumber:(NSUInteger)number {
    UIColor *color = [UIColor colorWithRed:number / 2.0f green:number / 30.0f blue:number / 7.0f alpha:1];
    return color;
}

@end
