//
//  SYGameTapToolBar.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameTapToolBar.h"

//  Model
#import "Masonry.h"
#import "SYGameCellModel.h"

@interface SYGameTapToolBar ()
{
    //  UI
    
    //  Data
}

@end

@implementation SYGameTapToolBar

+ (instancetype)gameTapToolBar {
    SYGameTapToolBar *toolBar = [[SYGameTapToolBar alloc] init];
    return toolBar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreLabelWithNotification:) name:@"kUpdateScore" object:nil];
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareUI {
    self.backgroundColor = [UIColor magentaColor];
    __weak UIView *weakSelf = self;
    
    /// 撤销按钮
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.9 alpha:1];
    undoButton.layer.cornerRadius = 8.0f;
    undoButton.layer.masksToBounds = YES;
    [undoButton setTitle:@"撤销" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undoButton];
    [undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(70, 50));
    }];
    
    /// 分数
    self.scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont systemFontOfSize:20];
    _scoreLabel.textColor = [UIColor whiteColor];
    [self addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-10);
        make.centerY.equalTo(weakSelf);
    }];
}

#pragma mark - Button Action

/// 撤销按钮
- (void)undoButtonAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUndoGame" object:@"undo"];
}

#pragma mark - NotificationCenter Action

- (void)updateScoreLabelWithNotification:(NSNotification *)notification {
    NSLog(@"score = %@",notification.object);
    //  添加到总分中
    [SYGameCellModel instance].score += [notification.object unsignedIntegerValue];
    //  更新到标签上
    _scoreLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[SYGameCellModel instance].score];
}

@end
