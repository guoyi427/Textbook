//
//  SYGameView.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameView.h"

//  View
#import "Masonry.h"
#import "SYGameCell.h"
#import "SYGameSizeAlertView.h"

//  Model
#import "SYGameCellModel.h"

@interface SYGameView () <SYGameSizeAlertViewDelegate>
{
    //  Data
    /// 屏幕宽
    CGFloat _screenWidth;
    /// 屏幕高
    CGFloat _screenHeight;
    /// 所有游戏单元的缓存数组
    NSMutableArray *_gameCellsCache;
    /// 单元格宽
    CGFloat _width_cell;
    
    //  UI
    /// 中间视图
    UIView *_centerView;
    /// alertView
    SYGameSizeAlertView *_alertView;
}

@end

@implementation SYGameView

+ (instancetype)gameView {
    SYGameView *gameView = [[SYGameView alloc] init];
    return gameView;
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Prepare

- (void)_prepareData {
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _gameCellsCache = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
    for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
        [_gameCellsCache addObject:sectionArray];
    }
    //  单元格宽
    _width_cell = (_screenWidth - 8) / [SYGameCellModel instance].count_gameCell;
    
    //  注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undoButtonNotification:) name:@"kUndoGame" object:nil];
}

- (void)_prepareUI {
    self.backgroundColor = [UIColor whiteColor];
    
    __weak UIView *weakSelf = self;
    _centerView = [[UIView alloc] init];
    _centerView.backgroundColor = [UIColor brownColor];
    _centerView.layer.masksToBounds = YES;
    _centerView.layer.cornerRadius = 8.0f;
    [self addSubview:_centerView];
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf);
        make.width.equalTo(weakSelf);
        make.height.equalTo(weakSelf.mas_width);
    }];

    [self _prepareToolBar];
    [self _prepareGameCells];
    [self _prepareSwipeGR];
}

/// 准备上部工具栏
- (void)_prepareToolBar {
    __weak UIView *weakSelf = self;
    /// 设置按钮
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    settingButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [settingButton addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.top.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
}

/// 准备 游戏单元 6 * 6
- (void)_prepareGameCells {
    /// 判断是否有本地缓存
    NSDictionary *cacheDic = [NSDictionary dictionaryWithContentsOfFile:[SYGameCellModel instance].cacheFilePath];
    NSArray *gameCellIndex = cacheDic[k_Numbers];
    
    if (gameCellIndex) {
        //  本地存在缓存
        //  本地不存在缓存
        for (int i = 0; i < gameCellIndex.count; i ++) {
            NSArray *sectionArray = gameCellIndex[i];
            for (int j = 0; j < sectionArray.count; j ++) {
                NSLog(@"%@",sectionArray[j]);
            }
        }
        
        /// 准备所有按钮
        for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
            for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
                SYGameCell *cell = [SYGameCell gameCell];
                cell.frame = CGRectMake(j * _width_cell + 4, i * _width_cell + 4, _width_cell, _width_cell);
                //  对比 number
                NSNumber *number = gameCellIndex[i][j];
                cell.number = [number unsignedIntegerValue];
                [_centerView addSubview:cell];
                //  加到缓存
                NSMutableArray *sectionArray = _gameCellsCache[i];
                [sectionArray addObject:cell];
            }
        }
        
        //  记录历史    记录 单元的 number
        [[SYGameCellModel instance].historyCache addObject:gameCellIndex];

    } else {
        //  随机两个单元格位置
        NSUInteger x_cell1 = arc4random()%[SYGameCellModel instance].count_gameCell;
        NSUInteger y_cell1 = arc4random()%[SYGameCellModel instance].count_gameCell;
        
        NSUInteger x_cell2 = arc4random()%[SYGameCellModel instance].count_gameCell;
        NSUInteger y_cell2 = arc4random()%[SYGameCellModel instance].count_gameCell;
        
        while (x_cell1 == x_cell2 &&
               y_cell1 == y_cell2) {
            //  不能重合 重新来
            x_cell2 = arc4random()%[SYGameCellModel instance].count_gameCell;
            y_cell2 = arc4random()%[SYGameCellModel instance].count_gameCell;
        }
        
        /// 准备所有按钮
        for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
            for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
                SYGameCell *cell = [SYGameCell gameCell];
                cell.frame = CGRectMake(j * _width_cell + 4, i * _width_cell + 4, _width_cell, _width_cell);
                if ((j == x_cell1 && i == y_cell1) ||
                    (j == x_cell2 && i == y_cell2)) {
                    cell.number = 1;
                }
                [_centerView addSubview:cell];
                //  加到缓存
                NSMutableArray *sectionArray = _gameCellsCache[i];
                [sectionArray addObject:cell];
            }
        }
        
        //  记录历史    记录 单元的 number
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
        for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
            for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
                SYGameCell *cell = _gameCellsCache[i][j];
                [sectionArray addObject:[NSNumber numberWithUnsignedInteger:cell.number]];
            }
            [numberArray addObject:sectionArray];
        }
        [[SYGameCellModel instance].historyCache addObject:numberArray];
    }
}

/// 准备骚动手势
- (void)_prepareSwipeGR {
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(swipeGestureRecognizerAction:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGR];
    
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(swipeGestureRecognizerAction:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGR];
    
    UISwipeGestureRecognizer *upSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(swipeGestureRecognizerAction:)];
    upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:upSwipeGR];
    
    UISwipeGestureRecognizer *downSwipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(swipeGestureRecognizerAction:)];
    downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:downSwipeGR];
}

#pragma mark - GestureRecognizer & Butotn Action

/// 滑动屏幕
- (void)swipeGestureRecognizerAction:(UISwipeGestureRecognizer *)swipeGR {
    //  记录历史
    NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
    for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
        for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
            SYGameCell *cell = _gameCellsCache[i][j];
            [sectionArray addObject:[NSNumber numberWithUnsignedInteger:cell.number]];
        }
        [numberArray addObject:sectionArray];
    }
    [[SYGameCellModel instance].historyCache addObject:numberArray];
    
    /// 记录是否需要 添加新的单元
    BOOL needAddNewCell = NO;
    /// 记录本次 合并 需要加多少分
    NSUInteger needPlusScore = 0;
    switch (swipeGR.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            //  向左滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j < [SYGameCellModel instance].count_gameCell - 1; j ++) {
                    /// 永远从 最右侧 向左推进
                    int k = 0;
                    /// 左边为0  就交换
                    while (k < [SYGameCellModel instance].count_gameCell-1) {
                        SYGameCell *rightCell = _gameCellsCache[i][[SYGameCellModel instance].count_gameCell - k - 1];
                        SYGameCell *leftCell = _gameCellsCache[i][[SYGameCellModel instance].count_gameCell - k - 2];
                        if (rightCell.number != 0 &&
                            leftCell.number == 0) {
                            leftCell.number = rightCell.number;
                            rightCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
            //  合并
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
                    SYGameCell *cell = _gameCellsCache[i][j];
                    //  判断是否与左边的相同   从左向右
                    if (j > 0) {
                        SYGameCell *leftCell = _gameCellsCache[i][j - 1];
                        if (cell.number &&
                            cell.number == leftCell.number) {
                            needPlusScore = pow(2, leftCell.number);
                            leftCell.number ++;
                            cell.number = 0;
                            needAddNewCell = YES;
                        }
                    }
                }
            }
            //  向左滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j < [SYGameCellModel instance].count_gameCell - 1; j ++) {
                    /// 永远从 最右侧 向左推进
                    int k = 0;
                    /// 左边为0  就交换
                    while (k < [SYGameCellModel instance].count_gameCell-1) {
                        SYGameCell *rightCell = _gameCellsCache[i][[SYGameCellModel instance].count_gameCell - k - 1];
                        SYGameCell *leftCell = _gameCellsCache[i][[SYGameCellModel instance].count_gameCell - k - 2];
                        if (rightCell.number != 0 &&
                            leftCell.number == 0) {
                            leftCell.number = rightCell.number;
                            rightCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            //  向右滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最左边 向右推进
                    int k = j;
                    /// 左边为0  就交换
                    while (k < [SYGameCellModel instance].count_gameCell - 1) {
                        SYGameCell *rightCell = _gameCellsCache[i][k+1];
                        SYGameCell *leftCell = _gameCellsCache[i][k];
                        if (rightCell.number == 0 &&
                            leftCell.number != 0) {
                            rightCell.number = leftCell.number;
                            leftCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
            //  合并  从右向左
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 1; j > 0; j --) {
                    SYGameCell *cell = _gameCellsCache[i][j];
                    //  判断是否与左边的相同
                    if (j > 0) {
                        SYGameCell *leftCell = _gameCellsCache[i][j - 1];
                        if (cell.number &&
                            cell.number == leftCell.number) {
                            needPlusScore = pow(2, cell.number);
                            cell.number ++;
                            leftCell.number = 0;
                            needAddNewCell = YES;
                        }
                    }
                }
            }
            //  向右滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最左边 向右推进
                    int k = j;
                    /// 左边为0  就交换
                    while (k < [SYGameCellModel instance].count_gameCell - 1) {
                        SYGameCell *rightCell = _gameCellsCache[i][k+1];
                        SYGameCell *leftCell = _gameCellsCache[i][k];
                        if (rightCell.number == 0 &&
                            leftCell.number != 0) {
                            rightCell.number = leftCell.number;
                            leftCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionUp:
        {
            //  向上滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最下 向上推进
                    int k = j;
                    //  上面为0 就交换
                    while (k < [SYGameCellModel instance].count_gameCell-1) {
                        SYGameCell *downCell    = _gameCellsCache[[SYGameCellModel instance].count_gameCell-k-1][i];
                        SYGameCell *upCell      = _gameCellsCache[[SYGameCellModel instance].count_gameCell-k-2][i];
                        if (downCell.number != 0 &&
                            upCell.number == 0) {
                            upCell.number = downCell.number;
                            downCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k++;
                    }
                }
            }
            //  合并
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j <= [SYGameCellModel instance].count_gameCell - 2; j ++) {
                    SYGameCell *upCell = _gameCellsCache[j][i];
                    SYGameCell *downCell = _gameCellsCache[j+1][i];
                    if (upCell.number &&
                        upCell.number == downCell.number) {
                        downCell.number = 0;
                        needPlusScore = pow(2, upCell.number);
                        upCell.number ++;
                        needAddNewCell = YES;
                    }
                }
            }
            //  向上滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最下 向上推进
                    int k = j;
                    //  上面为0 就交换
                    while (k < [SYGameCellModel instance].count_gameCell-1) {
                        SYGameCell *downCell    = _gameCellsCache[[SYGameCellModel instance].count_gameCell-k-1][i];
                        SYGameCell *upCell      = _gameCellsCache[[SYGameCellModel instance].count_gameCell-k-2][i];
                        if (downCell.number != 0 &&
                            upCell.number == 0) {
                            upCell.number = downCell.number;
                            downCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k++;
                    }
                }
            }
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
        {
            //  向下滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j < [SYGameCellModel instance].count_gameCell - 1; j ++) {
                    /// 永远都是 从最上 向下推进
                    int k = 0;
                    //  下面为0 就交换
                    while (k < [SYGameCellModel instance].count_gameCell - 1) {
                        SYGameCell *upCell = _gameCellsCache[k][i];
                        SYGameCell *downCell = _gameCellsCache[k+1][i];
                        if (upCell.number != 0 &&
                            downCell.number == 0) {
                            downCell.number = upCell.number;
                            upCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
            //  合并
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = [SYGameCellModel instance].count_gameCell - 2; j >= 0; j --) {
                    SYGameCell *upCell = _gameCellsCache[j][i];
                    SYGameCell *downCell = _gameCellsCache[j+1][i];
                    if (upCell.number &&
                        upCell.number == downCell.number) {
                        needPlusScore = pow(2, downCell.number);
                        downCell.number ++;
                        upCell.number = 0;
                        needAddNewCell = YES;
                    }
                }
            }
            //  向下滑
            for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
                for (int j = 0; j < [SYGameCellModel instance].count_gameCell - 1; j ++) {
                    /// 永远都是 从最上 向下推进
                    int k = 0;
                    //  下面为0 就交换
                    while (k < [SYGameCellModel instance].count_gameCell - 1) {
                        SYGameCell *upCell = _gameCellsCache[k][i];
                        SYGameCell *downCell = _gameCellsCache[k+1][i];
                        if (upCell.number != 0 &&
                            downCell.number == 0) {
                            downCell.number = upCell.number;
                            upCell.number = 0;
                            needAddNewCell = YES;
                        }
                        k ++;
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }

    //  添加一个新的单元 如何 有合并或者 移动的话
    if (needAddNewCell) {
        NSUInteger x_newCell = arc4random()%[SYGameCellModel instance].count_gameCell;
        NSUInteger y_newCell = arc4random()%[SYGameCellModel instance].count_gameCell;
        while (((SYGameCell *)_gameCellsCache[x_newCell][y_newCell]).number != 0) {
            x_newCell = arc4random()%[SYGameCellModel instance].count_gameCell;
            y_newCell = arc4random()%[SYGameCellModel instance].count_gameCell;
        }
        ((SYGameCell *)_gameCellsCache[x_newCell][y_newCell]).number += arc4random()%2 + 1;
    }
    //  如果 合并了 就添加分数
    if (needPlusScore) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateScore" object:[NSNumber numberWithUnsignedInteger:needPlusScore]];
    }
}

/// 设置按钮
- (void)settingButtonAction:(UIButton *)button {
    if (!_alertView) {
        _alertView = [SYGameSizeAlertView gameSizeAlertView];
        _alertView.delegate = self;
        [_alertView show];
    }
}

#pragma mark - Private Methods


#pragma mark - NotificationCenter Action

- (void)undoButtonNotification:(NSNotification *)notification {
    NSString *type = notification.object;
    NSLog(@"type = %@",type);

    if ([SYGameCellModel instance].historyCache.count > 1) {
        NSMutableArray *numberArray = [SYGameCellModel instance].historyCache[[SYGameCellModel instance].historyCache.count - 2];
        
        for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
            for (int j = 0; j < [SYGameCellModel instance].count_gameCell; j ++) {
                SYGameCell *cell = _gameCellsCache[i][j];
                cell.number = [numberArray[i][j] unsignedIntegerValue];
            }
        }
        [[SYGameCellModel instance].historyCache removeLastObject];
    }
}

#pragma mark - GameSizeAlertView - Delegate

- (void)gameSizeAlertView:(SYGameSizeAlertView *)alertView didDisappear:(NSInteger)animation {
    _alertView = nil;
}

- (void)gameSizeAlertView:(SYGameSizeAlertView *)alertView didSelectedType:(NSInteger)type {
    //  保存到缓存
    [SYGameCellModel instance].count_gameCell = (int)type;
    
    //  刷新页面
    for (UIView *deleteView in _centerView.subviews) {
        [deleteView removeFromSuperview];
    }
    [_gameCellsCache removeAllObjects];
    _gameCellsCache = nil;
    _gameCellsCache = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
    for (int i = 0; i < [SYGameCellModel instance].count_gameCell; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:[SYGameCellModel instance].count_gameCell];
        [_gameCellsCache addObject:sectionArray];
    }
    //  更新宽度m
    _width_cell = (_screenWidth - 8) / [SYGameCellModel instance].count_gameCell;
    [self _prepareGameCells];
}

@end
