//
//  NSString+ShuaiYi.m
//  1024
//
//  Created by guoyi on 15/9/11.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "NSString+ShuaiYi.h"

#import "SYGameCellModel.h"

/// 所有内容的数组

@implementation NSString (ShuaiYi)

/// 根据number返回对应的文字
+ (NSString *)stringWithNumber:(NSUInteger)number {
    NSString *resultString = nil;
    
    if ([SYGameCellModel instance].titlesArray.count > number) {
        resultString = [SYGameCellModel instance].titlesArray[number];
    } else {
        resultString = @"";
    }
    
    return resultString;
}

@end
