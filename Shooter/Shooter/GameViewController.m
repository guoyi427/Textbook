//
//  GameViewController.m
//  Shooter
//
//  Created by guoyi on 15/9/29.
//  Copyright (c) 2015年 郭毅. All rights reserved.
//

#import "GameViewController.h"
#import <SceneKit/SceneKit.h>

@interface GameViewController ()
{
    //  Data
    /// 计时器
    NSTimer *_updateTimer;
    /// 经历时间
    NSUInteger _agoTime;
    /// 记录所有浮动的盒子
    NSMutableArray *_boxCache;
    
    //  UI
    
    //  SceneKit
    SCNScene *_scene;
}

/// 准备数据
- (void)_prepareData;
/// 准备UI视图
- (void)_prepareUI;
/// 准备3D场景视图
- (void)_prepareScene;
/// 计时器更新
- (void)_updateTimerAction;

@end

/// 浮动盒子的 个数
static NSUInteger Count_Box = 10;

@implementation GameViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareUI];
    [self _prepareScene];
}

#pragma mark - Prepare

/// 准备数据
- (void)_prepareData {
    
    _agoTime = 0;
    _boxCache = [NSMutableArray arrayWithCapacity:Count_Box];
    
    _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(_updateTimerAction) userInfo:nil repeats:YES];
}

/// 准备UI视图
- (void)_prepareUI {

}

/// 准备3D场景视图
- (void)_prepareScene {
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
    SCNView *gameView = [[SCNView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:gameView];
    
    // set the scene to the view
    gameView.scene = _scene;
    
    // allows the user to manipulate the camera
//    gameView.allowsCameraControl = YES;
    
    // show statistics such as fps and timing information
    gameView.showsStatistics = YES;
    
    // configure the view
    gameView.backgroundColor = [UIColor blackColor];

}

#pragma mark - Private Methods

/// 计时器更新
- (void)_updateTimerAction {
    if (_agoTime % 20 == 0) {
        SCNBox *box = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0];
        SCNNode *node_box = [SCNNode nodeWithGeometry:box];
        node_box.position = SCNVector3Make(0, 0, 0);
        node_box.physicsBody = [SCNPhysicsBody staticBody];
        [_scene.rootNode addChildNode:node_box];
        [_boxCache addObject:node_box];
    }
    
    for (SCNNode *tempNode in _boxCache) {
        NSLog(@"postion = %f %f %f",tempNode.position.x,tempNode.position.y,tempNode.position.z);
    }
    
    _agoTime ++;
}

#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

#pragma mark - InterfaceOrientations 屏幕旋转

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
