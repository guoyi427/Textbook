//
//  SYAimingView.m
//  SliderView
//
//  Created by guoyi on 15/9/28.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "SYAimingView.h"

@implementation SYAimingView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //// 圆圈
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(_offsetPoint.x - Radius_Oval,
                                                                                _offsetPoint.y - Radius_Oval,
                                                                                Radius_Oval*2, Radius_Oval*2)];
    [[UIColor whiteColor] setStroke];
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    /// 圆圈2
    UIBezierPath *oval2Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_offsetPoint.x - Radius_Oval/4.0f,
                                                                                _offsetPoint.y - Radius_Oval/4.0f,
                                                                                Radius_Oval/2.0f,
                                                                                Radius_Oval/2.0f)];
    [[UIColor whiteColor] setStroke];
    oval2Path.lineWidth = 1;
    [oval2Path stroke];
    
    /// 圆圈3
    UIBezierPath *oval3Path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_offsetPoint.x - Radius_Oval*2,
                                                                                _offsetPoint.y - Radius_Oval*2,
                                                                                Radius_Oval*4,
                                                                                Radius_Oval*4)];
    [[UIColor whiteColor] setStroke];
    oval3Path.lineWidth = 1;
    [oval3Path stroke];
    
    /// 左横线
    UIBezierPath *bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(0, _offsetPoint.y)];
    [bezierPath addLineToPoint: CGPointMake(_offsetPoint.x - Radius_Oval, _offsetPoint.y )];
    [[UIColor whiteColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    //// 右横线
    UIBezierPath *bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(_offsetPoint.x + Radius_Oval, _offsetPoint.y)];
    [bezier2Path addLineToPoint: CGPointMake(500, _offsetPoint.y)];
    [[UIColor whiteColor] setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    /// 上竖线
    UIBezierPath *bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint:CGPointMake(_offsetPoint.x, 0)];
    [bezier3Path addLineToPoint:CGPointMake(_offsetPoint.x, _offsetPoint.y - Radius_Oval)];
    [[UIColor whiteColor] setStroke];
    bezier3Path.lineWidth = 1;
    [bezier3Path stroke];
    
    /// 下竖线
    UIBezierPath *bezier4Path = [UIBezierPath bezierPath];
    [bezier4Path moveToPoint:CGPointMake(_offsetPoint.x, _offsetPoint.y + Radius_Oval)];
    [bezier4Path addLineToPoint:CGPointMake(_offsetPoint.x, _screenSize.height - 20)];
    [[UIColor whiteColor] setStroke];
    bezier4Path.lineWidth = 1;
    [bezier4Path stroke];
    
    /// 左上斜线
    UIBezierPath *bezier5Path = [UIBezierPath bezierPath];
    [bezier5Path moveToPoint:CGPointMake(0, 0)];
    [bezier5Path addLineToPoint:CGPointMake(_offsetPoint.x - _obliqueLength, _offsetPoint.y - _obliqueLength)];
    [[UIColor whiteColor] setStroke];
    bezier5Path.lineWidth = 1;
    [bezier5Path stroke];
    
    /// 右上斜线
    UIBezierPath *bezier6Path = [UIBezierPath bezierPath];
    [bezier6Path moveToPoint:CGPointMake(_offsetPoint.x + _obliqueLength, _offsetPoint.y - _obliqueLength)];
    [bezier6Path addLineToPoint:CGPointMake(_screenSize.width, 0)];
    [[UIColor whiteColor] setStroke];
    bezier6Path.lineWidth = 1;
    [bezier6Path stroke];
    
    /// 左下斜线
    UIBezierPath *bezier7Path = [UIBezierPath bezierPath];
    [bezier7Path moveToPoint:CGPointMake(_offsetPoint.x - _obliqueLength, _offsetPoint.y + _obliqueLength)];
    [bezier7Path addLineToPoint:CGPointMake(0, _screenSize.height)];
    [[UIColor whiteColor] setStroke];
    bezier7Path.lineWidth = 1;
    [bezier7Path stroke];
    
    /// 右下斜线
    UIBezierPath *bezier8Path = [UIBezierPath bezierPath];
    [bezier8Path moveToPoint:CGPointMake(_offsetPoint.x + _obliqueLength, _offsetPoint.y + _obliqueLength)];
    [bezier8Path addLineToPoint:CGPointMake(_screenSize.width, _screenSize.height)];
    [[UIColor whiteColor] setStroke];
    bezier8Path.lineWidth = 1;
    [bezier8Path stroke];

}


@end
