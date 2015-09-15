//
//  UIColor+ShuaiYi.h
//  1024
//
//  Created by guoyi on 15/9/10.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ShuaiYi)

/// 根据number 返回对应 背景颜色
+ (UIColor *)colorWithNumber:(NSUInteger)number;

/// 根据number 返回 对于那个 字体颜色 （背景色的反色）
+ (UIColor *)inverseColorWithNumber:(NSUInteger)number;

@end
