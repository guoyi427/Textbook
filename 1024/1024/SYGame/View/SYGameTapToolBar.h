//
//  SYGameTapToolBar.h
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYGameTapToolBar : UIView

/// 分数标签
@property (nonatomic, strong) UILabel *scoreLabel;

/// 便利构造器
+ (instancetype)gameTapToolBar;

@end
