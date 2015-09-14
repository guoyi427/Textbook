//
//  GameViewController.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "GameViewController.h"

//  View
#import "SYGameTapToolBar.h"
#import "SYGameView.h"
#import "Masonry.h"

//  Model
#import "SYGameCellModel.h"

const CGFloat Height_GameTapToolBar = 100.0f;

@interface GameViewController ()
{
    //  Data
    
    //  UI
    /// 顶部工具栏
    SYGameTapToolBar *_gameTapToolBar;
    /// 游戏背景
    SYGameView *_gameView;
}
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //  获取本地分数
    NSNumber *scoreNumber = [NSDictionary dictionaryWithContentsOfFile:[SYGameCellModel instance].cacheFilePath][k_Socre];
    if ([scoreNumber unsignedIntegerValue]) {
        _gameTapToolBar.scoreLabel.text = [NSString stringWithFormat:@"%@",scoreNumber];
    }

}

#pragma mark - Prepare

- (void)_prepareData {
    
}

- (void)_prepareUI {
    //  背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak UIView *weakSelfView = self.view;
    
    //  顶部工具栏
    _gameTapToolBar = [SYGameTapToolBar gameTapToolBar];
    [self.view addSubview:_gameTapToolBar];
    [_gameTapToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelfView);
        make.top.equalTo(weakSelfView);
        make.width.equalTo(weakSelfView);
        make.height.mas_equalTo(Height_GameTapToolBar);
    }];
    
    //  游戏视图
    _gameView = [SYGameView gameView];
    [self.view addSubview:_gameView];
    [_gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelfView);
        make.top.equalTo(_gameTapToolBar.mas_bottom);
        make.width.equalTo(weakSelfView);
        make.height.equalTo(weakSelfView).offset(-Height_GameTapToolBar);
    }];
    
}

@end
