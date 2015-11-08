//
//  PBGameBackgroundView.m
//  PushBox
//
//  Created by guoyi on 15/11/2.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "PBGameBackgroundView.h"

#import "PBGameManager.h"

/// 背景边缘缝隙
static CGFloat Padding_Background = 5.0f;

/// 盒子边缘缝隙
static CGFloat Padding_Box = 2.0f;

@interface PBGameBackgroundView ()
{
    //  Data
    
    
    //  UI
    /// 盒子的父视图
    UIView *_centerBackgroundView;
    
}

@end

@implementation PBGameBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark - Public Methods

/// 便利构造器
+ (instancetype)gameBackgroundViewWithFrame:(CGRect)frame andHorizontal:(NSInteger)horizontal andVertical:(NSInteger)vertical {
    PBGameBackgroundView *gameBackgroundView = [[PBGameBackgroundView alloc] initWithFrame:frame];
    gameBackgroundView.horizontalCount = horizontal;
    gameBackgroundView.verticalCount = vertical;
    [gameBackgroundView _prepareUI];
    return gameBackgroundView;
}

#pragma mark - Prepare

- (void)_prepareUI {
    
    float float_horizontalCount = _horizontalCount;
    float float_verticalCount = _verticalCount;
    
    /// 横向 单个宽度
    CGFloat width_horizontal = CGRectGetWidth(self.frame) / float_horizontalCount;
    /// 纵向 单个高度
    CGFloat height_vertical = CGRectGetHeight(self.frame) / float_verticalCount;
    
    //  正方形 盒子的 宽度      哪个小 用哪个
    [PBGameManager instance].boxWidth = width_horizontal < height_vertical ? width_horizontal : height_vertical;
    
    /// 其中的视图
    _centerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                    [PBGameManager instance].boxWidth * _horizontalCount,
                                                                    [PBGameManager instance].boxWidth * _verticalCount)];
    _centerBackgroundView.center = self.center;
    _centerBackgroundView.backgroundColor = [UIColor grayColor];
    [self addSubview:_centerBackgroundView];
    
    /// 竖纹
    for (int i = 0; i <= _horizontalCount; i ++) {
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake([PBGameManager instance].boxWidth * i,
                                                                        0,
                                                                        0.5,
                                                                        CGRectGetHeight(_centerBackgroundView.frame))];
        verticalLine.backgroundColor = [UIColor whiteColor];
        [_centerBackgroundView addSubview:verticalLine];
    }
    
    /// 横纹
    for (int i = 0; i <= _verticalCount; i ++) {
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                          [PBGameManager instance].boxWidth * i,
                                                                          CGRectGetWidth(_centerBackgroundView.frame),
                                                                          0.5)];
        horizontalLine.backgroundColor = [UIColor whiteColor];
        [_centerBackgroundView addSubview:horizontalLine];
    }
    
}

@end
