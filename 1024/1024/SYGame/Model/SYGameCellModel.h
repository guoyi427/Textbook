//
//  SYGameCellModel.h
//  1024
//
//  Created by guoyi on 15/9/11.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYGameCellModel : NSObject

/// 标题
@property (nonatomic, strong) NSArray *titlesArray;
/// 历史缓存
@property (nonatomic, strong) NSMutableArray *historyCache;

+ (instancetype)instance;

@end
