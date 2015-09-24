//
//  SYBulletView.m
//  SliderView
//
//  Created by guoyi on 15/9/22.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "SYBulletView.h"

@implementation SYBulletView

+ (instancetype)bulletViewWithCenter:(CGPoint)center {
    SYBulletView *bullect = [[SYBulletView alloc] init];
    bullect.bounds = CGRectMake(0, 0, 10, 10);
    bullect.center = center;
    bullect.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:1
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         bullect.transform = CGAffineTransformMakeScale(3.0, 3.0f);
                         bullect.alpha = 0.1;
                     }
                     completion:^(BOOL finished) {
                         [bullect removeBullet];
                     }];
    
    return bullect;
}


- (void)removeBullet {
    [self removeFromSuperview];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //// Star Drawing
    UIBezierPath* starPath = UIBezierPath.bezierPath;
    [starPath moveToPoint: CGPointMake(5, 0)];
    [starPath addLineToPoint: CGPointMake(6.76, 2.57)];
    [starPath addLineToPoint: CGPointMake(9.76, 3.45)];
    [starPath addLineToPoint: CGPointMake(7.85, 5.93)];
    [starPath addLineToPoint: CGPointMake(7.94, 9.05)];
    [starPath addLineToPoint: CGPointMake(5, 8)];
    [starPath addLineToPoint: CGPointMake(2.06, 9.05)];
    [starPath addLineToPoint: CGPointMake(2.15, 5.93)];
    [starPath addLineToPoint: CGPointMake(0.24, 3.45)];
    [starPath addLineToPoint: CGPointMake(3.24, 2.57)];
    [starPath closePath];
    [[UIColor yellowColor] setStroke];
    starPath.lineWidth = 1.0f;
    [starPath stroke];
}


@end
