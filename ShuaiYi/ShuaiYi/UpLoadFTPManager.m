//
//  UpLoadFTPManager.m
//  ShuaiYi
//
//  Created by guoyi on 15/10/28.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "UpLoadFTPManager.h"


enum {
    kSendBufferSize = 32768
};

@interface UpLoadFTPManager () <NSStreamDelegate>
{

    /// 缓存下标 总公共读取长度
    size_t _bufferOffset;
    /// 每次实际读取长度
    size_t _bufferLimit;
    /// 读取文件的缓存
    uint8_t _buffer[kSendBufferSize];
}
/// 输入流
@property (nonatomic, retain) NSInputStream *inputStream;
/// 输出流
@property (nonatomic, retain) NSOutputStream *outputStream;

@end


@implementation UpLoadFTPManager

#pragma mark - Private Methods

/// 结果处理
- (void)_stopSendWithStatus:(NSString *)statusString
{
    if (_outputStream) {
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _outputStream.delegate = nil;
        [_outputStream close];
        _outputStream = nil;
    }
    if (_inputStream) {
        [_inputStream close];
        _inputStream = nil;
    }
}

#pragma mark - Public Methods

/// 上传文件
- (void)uploadFileWithPath:(NSString *)filePath {

    /// 主机名
    NSString *hostName = @"ftp://192.168.11.31/Desktop/Cache";
    /// 用户名
    NSString *userName = @"guoyi";
    /// 用户密码
    NSString *password = @"jkl;'";
    /// 写入URL
//    NSURL *writeURL = [NSURL URLWithString:[hostName stringByAppendingPathComponent:[filePath lastPathComponent]]];
    
    //  输入流 读取的本地文件 保存在此
    self.inputStream = [NSInputStream inputStreamWithFileAtPath:filePath];
    [_inputStream open];
    
    
    CFURLRef url_cf = (CFURLRef)[NSMakeCollectable(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef)[NSURL URLWithString:hostName], (CFStringRef)[filePath lastPathComponent], false)) autorelease];
    //  输出流 FTP的写入功能就在于此
    CFWriteStreamRef streamRef = CFWriteStreamCreateWithFTPURL(NULL, url_cf);
    self.outputStream = (NSOutputStream *)streamRef;
    
    //  设置账号密码
    [_outputStream setProperty:userName forKey:(NSString *)kCFStreamPropertyFTPUserName];
    [_outputStream setProperty:password forKey:(NSString *)kCFStreamPropertyFTPPassword];
    
    //  代理
    _outputStream.delegate = self;
    
    //  跑起来  傻金 (づ￣ 3￣)づ
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream open];
    
    
    NSTimer *aiyoTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}

- (void)update {
    NSLog(@"state = %lu",(unsigned long)_outputStream.streamStatus);
}

#pragma mark - NSOutputStream Delegate

/// 连接服务器代理
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"NSStreamEventOpenCompleted");
        }
            break;
        case NSStreamEventHasSpaceAvailable:
        {
            NSLog(@"NSStreamEventHasSpaceAvailable");
            //  有空间 准备写入
            if (_bufferOffset == _bufferLimit) {
                //  都等于0 的时候
                /// 实际读取大小
                NSInteger bufferBytesRead = [_inputStream read:_buffer maxLength:kSendBufferSize];
                
                if (bufferBytesRead == -1) {
                    //  读取失败
                    [self _stopSendWithStatus:@"读取文件失败"];
                } else if (bufferBytesRead == 0) {
                    //  读取完毕    并且 上传完成
                    [self _stopSendWithStatus:nil];
                } else {
                    //  读取成功 但未完成
                    _bufferOffset = 0;
                    //  保存 下次写入的范围
                    _bufferLimit = bufferBytesRead;
                }
                
                if (_bufferLimit != _bufferOffset) {
                    //  读取成功 写入数据到FTP服务器
                    NSInteger bytesWrite = [_outputStream write:&_buffer[_bufferOffset] maxLength:_bufferLimit - _bufferOffset];
                    //  是否写入成功
                    assert(bytesWrite != 0);
                    if (bytesWrite == -1) {
                        //  写入错误
                        [self _stopSendWithStatus:@"写入错误"];
                    } else {
                        //  写入成功
                        _bufferOffset += bytesWrite;
                    }
                }
            }
        }
            break;
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"NSStreamEventErrorOccurred");
            assert(NO);
        }
            break;
        case NSStreamEventEndEncountered:
        {
            NSLog(@"NSStreamEventEndEncountered");
        }
            break;
        case NSStreamEventHasBytesAvailable:
        {
            NSLog(@"NSStreamEventHasBytesAvailable");
        }
            break;
            
        default:
            break;
    }
}

@end
