//
//  PBGameBackgroundView.h
//  PushBox
//
//  Created by guoyi on 15/11/2.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBGameBackgroundView : UIView

/// 水平个数
@property (nonatomic, assign) NSInteger horizontalCount;
/// 垂直个数
@property (nonatomic, assign) NSInteger verticalCount;

/// 便利构造器
+ (instancetype)gameBackgroundViewWithFrame:(CGRect)frame
                              andHorizontal:(NSInteger)horizontal
                                andVertical:(NSInteger)vertical;

@end
