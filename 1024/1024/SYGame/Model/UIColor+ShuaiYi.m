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

static float _rgbValue[] = {
    255,255,51,
    204,255,0,
    153,255,0,
    102,255,0,
    51,255,0,
    0,255,204,
    0,204,153,
    0,255,255,
    51,204,255,
    0,153,255,
    0,102,255,
    0,51,255,
    51,0,204,
    51,0,153,
    102,0,255,
    153,0,255,
    204,0,255,
    204,51,255,
    153,0,204,
    204,0,153,
    255,51,204,
    255,0,153,
    255,0,102,
    255,0,51,
    255,51,102,
    204,0,51,
    204,51,0,
    255,102,51,
    255,153,0,
    204,102,0,
    153,102,51,
    102,51,0,
    102,51,51,	
    153,51,51,
    153,0,0,
    204,51,51,
    204,102,102,
    255,153,153,
    255,102,102,
    255,51,51,
    255,0,0,
    204,0,102
};

@implementation UIColor(ShuaiYi)

/// 根据number 返回对应背景颜色
+ (UIColor *)colorWithNumber:(NSUInteger)number {
    
    if (!number) {
        return [UIColor whiteColor];
    }

    float r,g,b;
    r = g = b = 0.0f;
    NSUInteger r_index, g_index, b_index;
    r_index = g_index = b_index = 0;
    r_index = (number - 1) * 3;
    g_index = (number - 1) * 3 + 1;
    b_index = (number - 1) * 3 + 2;
    
    r = _rgbValue[r_index];
    g = _rgbValue[g_index];
    b = _rgbValue[b_index];
    
    //  无色 为 黑色
    UIColor *color = [UIColor colorWithRed:r/255.0f
                                     green:g/255.0f
                                      blue:b/255.0f
                                     alpha:1];
    return color;
}

/// 根据number 返回 对于那个 字体颜色 （背景色的反色）
+ (UIColor *)inverseColorWithNumber:(NSUInteger)number {
    UIColor *color = [UIColor colorWithRed:number / 2.0f green:number / 30.0f blue:number / 7.0f alpha:1];
    return color;
}



@end
