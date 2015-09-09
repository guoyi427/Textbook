//
//  SYGameCell.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameCell.h"

//  View
#import "Masonry.h"

@interface SYGameCell ()
{
    //  Data
    
    //  UI
    /// 变色块
    UIView *_discolorView;
}

@end

@implementation SYGameCell

/// 便利构造器
+ (instancetype)gameCell {
    SYGameCell *cell = [[SYGameCell alloc] init];
    return cell;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _prepareData];
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare 

- (void)_prepareData {
    
}

- (void)_prepareUI {
    self.backgroundColor = [UIColor whiteColor];
    
    __weak UIView *weakSelf = self;

    /// 背景
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor brownColor];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    //  变色块
    _discolorView = [[UIView alloc] init];
    _discolorView.backgroundColor = [UIColor whiteColor];
    _discolorView.layer.masksToBounds = YES;
    _discolorView.layer.cornerRadius = 4.0f;
    [backgroundView addSubview:_discolorView];
    [_discolorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.equalTo(weakSelf).offset(-4);
        make.height.equalTo(weakSelf).offset(-4);
    }];
}

@end
