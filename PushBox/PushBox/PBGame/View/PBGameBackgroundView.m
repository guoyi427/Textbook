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
    /// Data
    
    
    /// UI
    
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
//    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [PBGameManager instance].boxWidth = (CGRectGetWidth(self.frame) - Padding_Background * 2) / _horizontalCount;
    
    /// 其中的视图
    UIView *centerBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), [PBGameManager instance].boxWidth * _verticalCount)];
    centerBackgroundView.center = self.center;
    [self addSubview:centerBackgroundView];
    
    
    for (int i = 1; i < _horizontalCount; i ++) {
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake([PBGameManager instance].boxWidth * i, 0,
                                                                        0.5, CGRectGetHeight(self.frame))];
        verticalLine.backgroundColor = [UIColor whiteColor];
        [self addSubview:verticalLine];
    }
    
}

@end
