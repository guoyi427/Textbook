//
//  PBGameManager.h
//  PushBox
//
//  Created by guoyi on 15/11/2.
//  Copyright © 2015年 郭毅. All rights reserved.
//
//  推盒子的游戏管理类 管理包括盒子参数等游戏参数

#import <Foundation/Foundation.h>

@interface PBGameManager : NSObject

/// 正方形 盒子的宽度
@property (nonatomic, assign) float boxWidth;

+ (instancetype)instance;

@end
