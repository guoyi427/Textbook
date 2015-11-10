//
//  PBGameViewController.m
//  PushBox
//
//  Created by guoyi on 15/11/2.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "PBGameViewController.h"

//  View
#import "PBGameBackgroundView.h"

@interface PBGameViewController ()
{
    //  Data
    CGSize _screenSize;
    
    //  UI
}
@end

/// 游戏背景的横向缝隙
static CGFloat Padding_GameBackgroundView_Horizontal = 20.0f;

@implementation PBGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _prepareData];
    [self _prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Prepare

- (void)_prepareData {
    _screenSize = [UIScreen mainScreen].bounds.size;
}

- (void)_prepareUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    /// 游戏背景
    PBGameBackgroundView *backgroundView = [PBGameBackgroundView gameBackgroundViewWithFrame:CGRectMake(0, 0,
                                                                                                        _screenSize.width - Padding_GameBackgroundView_Horizontal * 2,
                                                                                                        _screenSize.height - 150)
                                                                               andHorizontal:2
                                                                                 andVertical:2];
    backgroundView.center = self.view.center;
    [self.view addSubview:backgroundView];
    
}

@end
