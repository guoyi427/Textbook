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

@implementation SYGameTapToolBar

+ (instancetype)gameTapToolBar {
    SYGameTapToolBar *toolBar = [[SYGameTapToolBar alloc] init];
    return toolBar;
}

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
    self.backgroundColor = [UIColor yellowColor];
    __weak UIView *weakSelf = self;
    
    /// 撤销按钮
    UIButton *undoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.backgroundColor = [UIColor blueColor];
    [undoButton setTitle:@"撤销" forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:undoButton];
    [undoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(10);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(70, 50));
    }];
    
    
}

#pragma mark - Button Action

/// 撤销按钮
- (void)undoButtonAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kUndoGame" object:@"undo"];
}

@end
