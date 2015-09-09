//
//  SYGameTapToolBar.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "SYGameTapToolBar.h"

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
}

@end
