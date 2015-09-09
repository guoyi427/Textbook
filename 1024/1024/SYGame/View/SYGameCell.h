//
//  SYGameCell.h
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGameCell : UIView

/// 单元格号码 用于记录被整合了多少次
@property (nonatomic ,assign) NSUInteger number;
/// x坐标
@property (nonatomic, assign) NSUInteger x;
/// y坐标
@property (nonatomic, assign) NSUInteger y;

/// 便利构造器
+ (instancetype)gameCell;

@end
