//
//  SYGameCellModel.m
//  1024
//
//  Created by guoyi on 15/9/11.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameCellModel.h"

@implementation SYGameCellModel

+ (instancetype)instance {
    static SYGameCellModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[SYGameCellModel alloc] init];
    });
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titlesArray = @[@"",@"小班",@"中班",@"大班",@"小学",@"初中",
                             @"高中",@"大学",@"硕士",@"博士",@"博士后",@"学霸",
                             @"学神",@"金星",@"木星",@"水星",@"火星",@"土星",
                             @"天王星",@"海王星",@"冥王星",@"地球",@"",@"",
                             @"",@"",@"",@"",@"",@"",
                             @"",@"",@"",@"",@"",@""];
    }
    return self;
}

@end
