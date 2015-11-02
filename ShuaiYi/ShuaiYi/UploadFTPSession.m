//
//  UploadFTPSession.m
//  ShuaiYi
//
//  Created by guoyi on 15/10/29.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "UploadFTPSession.h"

@implementation UploadFTPSession


#pragma mark - Public Methods

- (void)uploadFileWithPath:(NSString *)filePath {

    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"caiDanProfile" ofType:@"ped"]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"caiDanProfile" ofType:@"ped"]]];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:data];
    
    
    [task resume];
}

@end
