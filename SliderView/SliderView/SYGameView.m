//
//  SYSliderView.m
//  SliderView
//
//  Created by guoyi on 15/9/21.
//  Copyright © 2015年 guoyi. All rights reserved.
//

#import "SYGameView.h"

#import "SYBulletView.h"
#import "SYView.h"
#import "SYAimingView.h"

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
    
    //  UI
    SCNScene *_scene;
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
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
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
    
    // create a new scene
    _scene = [SCNScene scene];
    
    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [_scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [_scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [_scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the SCNView
    SYView *scnView = [[SYView alloc] initWithFrame:self.bounds];
    scnView.backgroundColor = [UIColor clearColor];
    [self addSubview:scnView];
    
    // set the scene to the view
    scnView.scene = _scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;
    
    
    /// Box
    SCNBox *box_scene = [SCNBox boxWithWidth:5 height:5 length:5 chamferRadius:0];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:box_scene];
    [_scene.rootNode addChildNode:boxNode];
    
    //  瞄准
    SYAimingView *aimingView = [[SYAimingView alloc]  initWithFrame:self.bounds];
    [self addSubview:aimingView];
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
<<<<<<< HEAD
//        newRect.origin.x += ;
//        newRect.origin.y += ;
=======
        newRect.origin.x += 0;
        newRect.origin.y += 0;
>>>>>>> 85464e679d1afb5096f6e14219b084ec241c3b31
        box.frame = newRect;
    }
}

- (void)updateViewWithOffset:(CGPoint)offsetPoint {
    _offsetPoint = offsetPoint;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touche = touches.anyObject;
    CGPoint touchPoint = [touche locationInView:self];
    NSLog(@"手指粗细半径 = %f, %f",touche.majorRadius,touche.majorRadiusTolerance);
    
    /// 偏移量
    _paddingPoint = CGPointMake(_offsetPoint.x - touchPoint.x, _offsetPoint.y - touchPoint.y);
    _needShoot = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touche = touches.anyObject;
    
    CGPoint point = [touche locationInView:self];
    
    [self updateViewWithOffset:CGPointMake(point.x + _paddingPoint.x, point.y + _paddingPoint.y)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    _needShoot = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}



@end
