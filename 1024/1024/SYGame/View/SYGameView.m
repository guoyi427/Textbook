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

/// 一行多少个
const NSUInteger Count_gameCell = 6.0f;

@interface SYGameView ()
{
    //  Data
    /// 屏幕宽
    CGFloat _screenWidth;
    /// 屏幕高
    CGFloat _screenHeight;
    /// 所有游戏单元的缓存数组
    NSMutableArray *_gameCellsCache;
    /// 单元 宽度
    /// 单元格宽
    CGFloat _width_cell;
    
    //  UI
    /// 中间视图
    UIView *_centerView;
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

#pragma mark - Prepare

- (void)_prepareData {
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _gameCellsCache = [NSMutableArray arrayWithCapacity:Count_gameCell];
    for (int i = 0; i < Count_gameCell; i ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:Count_gameCell];
        [_gameCellsCache addObject:sectionArray];
    }
    //  单元格宽
    _width_cell = (_screenWidth - 8) / Count_gameCell;
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

    [self _prepareGameCells];
    [self _prepareSwipeGR];
}

/// 准备 游戏单元 6 * 6
- (void)_prepareGameCells {

    //  随机两个单元格位置
    NSUInteger x_cell1 = arc4random()%Count_gameCell;
    NSUInteger y_cell1 = arc4random()%Count_gameCell;
    
    NSUInteger x_cell2 = arc4random()%Count_gameCell;
    NSUInteger y_cell2 = arc4random()%Count_gameCell;
    
    while (x_cell1 == x_cell2 &&
           y_cell1 == y_cell2) {
        //  不能重合 重新来
        x_cell2 = arc4random()%Count_gameCell;
        y_cell2 = arc4random()%Count_gameCell;
    }
    
    /// 准备所有按钮
    for (int i = 0; i < Count_gameCell; i ++) {
        for (int j = 0; j < Count_gameCell; j ++) {
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

#pragma mark - GestureRecognizer Action 

- (void)swipeGestureRecognizerAction:(UISwipeGestureRecognizer *)swipeGR {
    /// 记录是否需要 添加新的单元
    BOOL needAddNewCell = NO;
    switch (swipeGR.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            //  向左滑
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j < Count_gameCell - 1; j ++) {
                    /// 永远从 最右侧 向左推进
                    int k = 0;
                    /// 左边为0  就交换
                    while (k < Count_gameCell-1) {
                        SYGameCell *rightCell = _gameCellsCache[i][Count_gameCell - k - 1];
                        SYGameCell *leftCell = _gameCellsCache[i][Count_gameCell - k - 2];
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j < Count_gameCell; j ++) {
                    SYGameCell *cell = _gameCellsCache[i][j];
                    //  判断是否与左边的相同   从左向右
                    if (j > 0) {
                        SYGameCell *leftCell = _gameCellsCache[i][j - 1];
                        if (cell.number &&
                            cell.number == leftCell.number) {
                            leftCell.number ++;
                            cell.number = 0;
                            needAddNewCell = YES;
                        }
                    }
                }
            }
            //  向左滑
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j < Count_gameCell - 1; j ++) {
                    /// 永远从 最右侧 向左推进
                    int k = 0;
                    /// 左边为0  就交换
                    while (k < Count_gameCell-1) {
                        SYGameCell *rightCell = _gameCellsCache[i][Count_gameCell - k - 1];
                        SYGameCell *leftCell = _gameCellsCache[i][Count_gameCell - k - 2];
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最左边 向右推进
                    int k = j;
                    /// 左边为0  就交换
                    while (k < Count_gameCell - 1) {
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 1; j > 0; j --) {
                    SYGameCell *cell = _gameCellsCache[i][j];
                    //  判断是否与左边的相同
                    if (j > 0) {
                        SYGameCell *leftCell = _gameCellsCache[i][j - 1];
                        if (cell.number &&
                            cell.number == leftCell.number) {
                            cell.number ++;
                            leftCell.number = 0;
                            needAddNewCell = YES;
                        }
                    }
                }
            }
            //  向右滑
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最左边 向右推进
                    int k = j;
                    /// 左边为0  就交换
                    while (k < Count_gameCell - 1) {
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最下 向上推进
                    int k = j;
                    //  上面为0 就交换
                    while (k < Count_gameCell-1) {
                        SYGameCell *downCell    = _gameCellsCache[Count_gameCell-k-1][i];
                        SYGameCell *upCell      = _gameCellsCache[Count_gameCell-k-2][i];
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j <= Count_gameCell - 2; j ++) {
                    SYGameCell *upCell = _gameCellsCache[j][i];
                    SYGameCell *downCell = _gameCellsCache[j+1][i];
                    if (upCell.number &&
                        upCell.number == downCell.number) {
                        downCell.number = 0;
                        upCell.number ++;
                        needAddNewCell = YES;
                    }
                }
            }
            //  向上滑
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 1; j >= 0; j --) {
                    /// 永远都是 从最下 向上推进
                    int k = j;
                    //  上面为0 就交换
                    while (k < Count_gameCell-1) {
                        SYGameCell *downCell    = _gameCellsCache[Count_gameCell-k-1][i];
                        SYGameCell *upCell      = _gameCellsCache[Count_gameCell-k-2][i];
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j < Count_gameCell - 1; j ++) {
                    /// 永远都是 从最上 向下推进
                    int k = 0;
                    //  下面为0 就交换
                    while (k < Count_gameCell - 1) {
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
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = Count_gameCell - 2; j >= 0; j --) {
                    SYGameCell *upCell = _gameCellsCache[j][i];
                    SYGameCell *downCell = _gameCellsCache[j+1][i];
                    if (upCell.number &&
                        upCell.number == downCell.number) {
                        downCell.number ++;
                        upCell.number = 0;
                        needAddNewCell = YES;
                    }
                }
            }
            //  向下滑
            for (int i = 0; i < Count_gameCell; i ++) {
                for (int j = 0; j < Count_gameCell - 1; j ++) {
                    /// 永远都是 从最上 向下推进
                    int k = 0;
                    //  下面为0 就交换
                    while (k < Count_gameCell - 1) {
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
        NSUInteger x_newCell = arc4random()%Count_gameCell;
        NSUInteger y_newCell = arc4random()%Count_gameCell;
        while (((SYGameCell *)_gameCellsCache[x_newCell][y_newCell]).number != 0) {
            x_newCell = arc4random()%Count_gameCell;
            y_newCell = arc4random()%Count_gameCell;
        }
        ((SYGameCell *)_gameCellsCache[x_newCell][y_newCell]).number ++;
    }
    
    //  更新界面
    [self _uploadGameView];
}

#pragma mark - Private Methods

/// 刷新页面
- (void)_uploadGameView {
    
    
    [UIView animateWithDuration:0.25 animations:^{
        for (int i = 0; i < Count_gameCell; i ++) {
            for (int j = 0; j < Count_gameCell; j ++) {
                SYGameCell *cell = _gameCellsCache[i][j];
                cell.frame = CGRectMake(j * _width_cell + 4, i * _width_cell + 4, _width_cell, _width_cell);
            }
        }
    }];
   
}

@end
