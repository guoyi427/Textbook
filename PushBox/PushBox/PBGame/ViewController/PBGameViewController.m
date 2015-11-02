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
    PBGameBackgroundView *backgroundView = [PBGameBackgroundView gameBackgroundViewWithFrame:CGRectMake(0, 0, _screenSize.width, _screenSize.height) andHorizontal:5 andVertical:3];
    [self.view addSubview:backgroundView];
    
}

@end
