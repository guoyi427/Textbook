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
const NSUInteger Count_gameCell = 6;

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
    _gameCellsCache = [NSMutableArray arrayWithCapacity:Count_gameCell * Count_gameCell];
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
    
    //  随意两个单元格位置
    /// 上一个单元格的x
    NSUInteger x_lastCell = 0;
    /// 上一个单元格的y
    NSUInteger y_lastCell = 0;
    for (int i = 0; i < 2; i ++) {
        /// 本次单元格x
        NSUInteger x_currentCell = arc4random()%Count_gameCell;
        /// 本次单元格y
        NSUInteger y_currentCell = arc4random()%Count_gameCell;
        //  一致随机到和 上一次 xy 都不一致的位置
        while (x_lastCell == x_currentCell &&
               y_lastCell == y_currentCell) {
            //  如果一致 就在随机一边
            x_currentCell = arc4random()%Count_gameCell;
            y_currentCell = arc4random()%Count_gameCell;
        }
        //  实例化 单元格
        SYGameCell *cell = [SYGameCell gameCell];
        cell.frame = CGRectMake(x_currentCell * _width_cell + 4,
                                y_currentCell * _width_cell + 4,
                                _width_cell,
                                _width_cell);
        cell.x = x_currentCell;
        cell.y = y_currentCell;
        [_centerView addSubview:cell];
        //  更新位置缓存
        x_lastCell = x_currentCell;
        y_lastCell = y_lastCell;
        //  将单元格视图 加入到缓存 用来做 整体位移 和 碰撞比较
        [_gameCellsCache addObject:cell];
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
    switch (swipeGR.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            //  向左滑
            
            /// 第一行 单元
            NSMutableArray *section_1 = [NSMutableArray arrayWithCapacity:Count_gameCell];
            /// 第二行 单元
            NSMutableArray *section_2 = [NSMutableArray arrayWithCapacity:Count_gameCell];
            /// 第三行 单元
            NSMutableArray *section_3 = [NSMutableArray arrayWithCapacity:Count_gameCell];
            /// 第四行 单元
            NSMutableArray *section_4 = [NSMutableArray arrayWithCapacity:Count_gameCell];
            //  遍历所有的单元
            for (int i = 0; i < _gameCellsCache.count; i ++) {
                SYGameCell *cell = _gameCellsCache[i];
                NSLog(@"frame = %@ index = %lu x = %lu y = %lu",NSStringFromCGRect(cell.frame),cell.number,cell.x,cell.y);
                if (cell.x == 0) {
                    [section_1 addObject:cell];
                } else if (cell.x == 1) {
                    [section_2 addObject:cell];
                } else if (cell.x == 2) {
                    [section_3 addObject:cell];
                } else {
                    [section_4 addObject:cell];
                }
            }
            //  按照y 排序
            [self _sortHorizonalCells:section_1];
            [self _sortHorizonalCells:section_2];
            [self _sortHorizonalCells:section_3];
            [self _sortHorizonalCells:section_4];
            //  处理每一个组的单元
            /// 处理后的新缓存
            NSMutableArray *sectionBefore_1 = [NSMutableArray arrayWithCapacity:Count_gameCell];
            /// 上一个单元
            SYGameCell *lastCell = section_1.firstObject;
            /// 最左可用 x坐标
            CGFloat left_x = 4;
            /// 最上可用 y坐标
            CGFloat top_y = 4;
            while (section_1.count) {
                SYGameCell *currentCell = section_1.firstObject;
                //  判断是否为同一类
                if (currentCell.number == lastCell.number) {
                    /// 合成后的单元
                    SYGameCell *sumCell = [SYGameCell gameCell];
                    sumCell.number = currentCell.number + 1;
                    sumCell.x = i - 1;
                    sumCell.y = 0;
                    sumCell.frame = CGRectMake(left_x, top_y, _width_cell, _width_cell);
                    [sectionBefore_1 addObject:sumCell];
                    
                    left_x += _width_cell;
                    top_y += _width_cell;
                    
                } else {
                    /// 不是同一类
                    
                }

            }
            
        }
            break;
        case UISwipeGestureRecognizerDirectionRight:
        {
            //  向右滑
        }
            break;
        case UISwipeGestureRecognizerDirectionUp:
        {
            //  向上滑
        }
            break;
        case UISwipeGestureRecognizerDirectionDown:
        {
            //  向下滑
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods

/// 排序行
- (void)_sortHorizonalCells:(NSMutableArray *)cells {
    [cells sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SYGameCell *cell1 = obj1;
        SYGameCell *cell2 = obj2;
        NSComparisonResult ordered = NSOrderedSame;
        if (cell1.y > cell2.y) {
            ordered = NSOrderedDescending;
        } else if (cell2.y > cell1.y) {
            ordered = NSOrderedAscending;
        }
        return ordered;
    }];
}

/// 排序列
- (void)_sortVerticalCells:(NSMutableArray *)cells {
    [cells sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SYGameCell *cell1 = obj1;
        SYGameCell *cell2 = obj2;
        NSComparisonResult ordered = NSOrderedSame;
        if (cell1.x > cell2.x) {
            ordered = NSOrderedDescending;
        } else if (cell2.x > cell1.x) {
            ordered = NSOrderedAscending;
        }
        return ordered;
    }];
}

@end
