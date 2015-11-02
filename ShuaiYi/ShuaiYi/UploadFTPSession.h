//
//  UploadFTPSession.h
//  ShuaiYi
//
//  Created by guoyi on 15/10/29.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFTPSession : NSObject

/// 上传文件
- (void)uploadFileWithPath:(NSString *)filePath;

@end
