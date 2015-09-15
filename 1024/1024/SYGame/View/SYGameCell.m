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

//  Model
#import "UIColor+ShuaiYi.h"
#import "NSString+ShuaiYi.h"

@interface SYGameCell ()
{
    //  Data
    
    //  UI
    /// 变色块
    UIView *_discolorView;
    /// 标签
    UILabel *_titleLabel;
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
    _number = 0;
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
    
    //  标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:40];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [backgroundView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_discolorView);
        make.width.equalTo(_discolorView).offset(-10);
    }];
}

#pragma mark - Set Action

- (void)setNumber:(NSUInteger)number {
    if (_number != number) {
        _number = number;
        /// 更新 cell 背景颜色
        _discolorView.backgroundColor = [UIColor colorWithNumber:number];
        _titleLabel.textColor = [UIColor inverseColorWithNumber:number];
        _titleLabel.text = [NSString stringWithNumber:number];
    }
}

#pragma mark - Get Action

//- (NSString *)description {
//    NSString *description = [NSString stringWithFormat:@"number = %lu",(unsigned long)_number];
//    return description;
//}

@end
