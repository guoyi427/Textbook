//
//  SYTargetBoxNode.m
//  Shooter
//
//  Created by guoyi on 15/10/13.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "SYTargetBoxNode.h"

@implementation SYTargetBoxNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        //  给 靶子 添加一个 血条
        SCNBox *bloodBox = [SCNBox boxWithWidth:2 height:0.2 length:0.2 chamferRadius:0];
        SCNNode *bloodNode = [SCNNode nodeWithGeometry:bloodBox];
        bloodNode.position = SCNVector3Make(0, 1.2, 0);
        [self addChildNode:bloodNode];
    }
    return self;
}

@end
