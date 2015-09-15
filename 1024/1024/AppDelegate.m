//
//  AppDelegate.m
//  1024
//
//  Created by guoyi on 15/9/9.
//  Copyright (c) 2015年 guoyi. All rights reserved.
//

#import "AppDelegate.h"

#import "GameViewController.h"

//  Model
#import "SYGameCellModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    GameViewController *viewController = [[GameViewController alloc] init];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //  缓存数据到本地
    NSArray *gameCellLocationArray = [SYGameCellModel instance].historyCache.lastObject;
    
    //  保存当前总分到本地
    NSDictionary *cacheDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              gameCellLocationArray,k_Numbers,
                              [NSNumber numberWithUnsignedInteger:[SYGameCellModel instance].score],k_Socre, nil];

    
    //  写入本地
    [cacheDic writeToFile:[SYGameCellModel instance].cacheFilePath atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //  更新分数
    [SYGameCellModel instance].score = [[NSDictionary dictionaryWithContentsOfFile:[SYGameCellModel instance].cacheFilePath][k_Socre] unsignedIntegerValue];
    //  更新规格
    [SYGameCellModel instance].count_gameCell = [[NSDictionary dictionaryWithContentsOfFile:[SYGameCellModel instance].cacheFilePath][k_Size] intValue];
    if (![SYGameCellModel instance].count_gameCell) {
        [SYGameCellModel instance].count_gameCell = 4;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
