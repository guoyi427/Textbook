//
//  SYSliderView.m
//  SliderView
//
//  Created by guoyi on 15/9/21.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "SYGameView.h"

#import "SYBulletView.h"

@interface SYGameView ()
{
    CGPoint _offsetPoint;
    CGSize _screenSize;
    CGFloat _obliqueLength;
    /// 填充点
    CGPoint _paddingPoint;
    /// 是否需要发射子弹
    BOOL _needShoot;
    NSTimer *_updateTimer;
    /// 缓存所有飞行盒子
    NSMutableArray *_boxCache;
}

@end

static CGFloat Radius_Oval = 20.0f;

@implementation SYGameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _prepareData];
        [self _prepareUI];
    }
    return self;
}

#pragma mark - Prepare

- (void)_prepareData {
    _boxCache = [NSMutableArray arrayWithCapacity:10];
    _screenSize = [UIScreen mainScreen].bounds.size;
    _obliqueLength = sqrtf(2) / 2.0f * Radius_Oval;
    _paddingPoint = CGPointZero;
    _offsetPoint = CGPointMake(_screenSize.width/2.0f, _screenSize.height/2.0f);
    _needShoot = NO;

    /// 计时器
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                    target:self
                                                  selector:@selector(_updateTimerAction)
                                                  userInfo:nil
                                                   repeats:YES];

}

- (void)_prepareUI {
    UIView *box = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    box.backgroundColor = [UIColor magentaColor];
    [self addSubview:box];
    [_boxCache addObject:box];
}

#pragma mark - Private Methods

- (void)_updateTimerAction {
     //  发射子弹
    if (_needShoot) {
        SYBulletView *bullet = [SYBulletView bulletViewWithCenter:_offsetPoint];
        [self addSubview:bullet];
    }
    
    //  浮动盒子
    for (UIView *box in _boxCache) {
        CGRect newRect = box.frame;
        newRect.origin.x += ;
        newRect.origin.y += ;
        box.frame = newRect;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //// Bezier Drawing
    
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

- (void)updateViewWithOffset:(CGPoint)offsetPoint {
    _offsetPoint = offsetPoint;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = touches.anyObject;
    CGPoint touchPoint = [touche locationInView:self];
    NSLog(@"手指粗细半径 = %f, %f",touche.majorRadius,touche.majorRadiusTolerance);
    
    /// 偏移量
    _paddingPoint = CGPointMake(_offsetPoint.x - touchPoint.x, _offsetPoint.y - touchPoint.y);
    _needShoot = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touche = touches.anyObject;
    
    CGPoint point = [touche locationInView:self];
    
    [self updateViewWithOffset:CGPointMake(point.x + _paddingPoint.x, point.y + _paddingPoint.y)];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _needShoot = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}



@end
