//
//  UIColor+ShuaiYi.m
//  1024
//
//  Created by guoyi on 15/9/10.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "UIColor+ShuaiYi.h"

@implementation UIColor (ShuaiYi)

/// 根据number 返回对应颜色
+ (UIColor *)colorWithNumber:(NSUInteger)number {
    UIColor *color = [UIColor colorWithRed:1 - number / 30.0f green:1 - number / 2.0f blue:1 - number / 7.0f alpha:1];
    return color;
}

@end
