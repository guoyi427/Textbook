//
//  PBGameManager.m
//  PushBox
//
//  Created by guoyi on 15/11/2.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "PBGameManager.h"

@implementation PBGameManager

+ (instancetype)instance {
    static PBGameManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PBGameManager alloc] init];
    });
    return manager;
}

@end
