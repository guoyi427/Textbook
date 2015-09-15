//
//  SYGameCellModel.h
//  1024
//
//  Created by guoyi on 15/9/11.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 单元格缓存 key
static NSString *k_Numbers  = @"number";
/// 总分缓存 key
static NSString *k_Socre    = @"socre";
/// 规格
static NSString *k_Size     = @"size";

@interface SYGameCellModel : NSObject

/// 标题
@property (nonatomic, strong) NSArray *titlesArray;
/// 历史缓存
@property (nonatomic, strong) NSMutableArray *historyCache;
/// 总分
@property (nonatomic, assign) NSUInteger score;
/// 游戏规格  4x4 6x6 8x8
@property (nonatomic, assign) int count_gameCell;
/// 缓存路径 不同的规格 使用不同的路径  在更新游戏规格的时候 此路径自动更新
@property (nonatomic, strong) NSString *cacheFilePath;

+ (instancetype)instance;

@end
