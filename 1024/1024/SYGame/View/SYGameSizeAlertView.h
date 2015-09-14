//
//  SYGameSizeAlertView.h
//  1024
//
//  Created by guoyi on 15/9/14.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYGameSizeAlertView;
@protocol SYGameSizeAlertViewDelegate <NSObject>

/// 点击结束
- (void)gameSizeAlertView:(SYGameSizeAlertView *)alertView didSelectedType:(int)type;
/// 界面隐藏代理
- (void)gameSizeAlertView:(SYGameSizeAlertView *)alertView didDisappear:(int)animation;

@end

@interface SYGameSizeAlertView : UIView

/// 代理
@property (nonatomic, weak) id<SYGameSizeAlertViewDelegate> delegate;

/// 便利构造器
+ (instancetype)gameSizeAlertView;

/// 显示
- (void)show;


@end
