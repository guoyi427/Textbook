//
//  SYGameSizeAlertView.m
//  1024
//
//  Created by guoyi on 15/9/14.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameSizeAlertView.h"

#import "Masonry.h"
#import "AppDelegate.h"

static NSInteger Tag_typeButton = 100;

@implementation SYGameSizeAlertView

/// 便利构造器
+ (instancetype)gameSizeAlertView {
    SYGameSizeAlertView *alertView = [[SYGameSizeAlertView alloc] init];
    return alertView;
}

/// 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareUI {
    self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    /// 添加 隐藏手势
    UITapGestureRecognizer *tapBackgroundGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    [self addGestureRecognizer:tapBackgroundGR];
    
    [self _prepareCenterView];
}

/// 准备中间白色视图
- (void)_prepareCenterView {
    __weak UIView *weakSelf = self;
    UIView *centerView = [[UIView alloc] init];
    centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    /// 上一个按钮
    __weak UIButton *weakLastButton = nil;
    //  所有按钮
    for (int i = 0; i < 5; i ++) {
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [typeButton setTitle:[NSString stringWithFormat:@"%dx%d",i+4,i+4] forState:UIControlStateNormal];
        [typeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        typeButton.tag = Tag_typeButton + i;
        [centerView addSubview:typeButton];
        [typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf);
            if (weakLastButton) {
                make.top.equalTo(weakLastButton.mas_bottom).offset(15);
            } else {
                make.top.equalTo(centerView).offset(15);
            }
        }];
        weakLastButton = typeButton;
    }
}

#pragma mark - Button Action 

/// 类型按钮
- (void)typeButtonAction:(UIButton *)button {
    //  规格
    NSInteger type = button.tag - Tag_typeButton + 4;
    if (_delegate &&
        [_delegate respondsToSelector:@selector(gameSizeAlertView:didSelectedType:)]) {
        [_delegate gameSizeAlertView:self didSelectedType:type];
    }
    //  隐藏
    [self hidden];
}

#pragma mark - Public Methods

/// 显示
- (void)show {
    __weak UIView *weakWindows = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [weakWindows addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakWindows);
    }];
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0f;
    }];
}

/// 隐藏
- (void)hidden {
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         if (_delegate &&
                             [_delegate respondsToSelector:@selector(gameSizeAlertView:didDisappear:)]) {
                             [_delegate gameSizeAlertView:self didDisappear:YES];
                         }
                     }];
}

@end
