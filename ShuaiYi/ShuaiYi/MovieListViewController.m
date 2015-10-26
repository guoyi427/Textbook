//
//  MovieListViewController.m
//  ShuaiYi
//
//  Created by 郭毅 on 15/10/21.
//  Copyright © 2015年 郭毅. All rights reserved.
//

#import "MovieListViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MovieListViewController () <UITableViewDataSource, UITableViewDelegate, NSURLSessionDelegate>
{
    //  Data
    NSMutableArray *_moviePathCache;
    
    //  UI
    UITableView *_contentTableView;
}
@end

@implementation MovieListViewController

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
    //  获取 所有视频路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsAtPath:paths.firstObject];
    
    _moviePathCache = [NSMutableArray arrayWithCapacity:subPaths.count];
    
    for (NSString *subFilePath in subPaths) {
        if ([subFilePath hasPrefix:@"mov"]) {
            [_moviePathCache addObject:subFilePath];
        }
    }
}

- (void)_prepareUI {
    [self _prepareNaviBar];
    [self _prepareContentTable];
}

- (void)_prepareNaviBar {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"选择"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(editContentTableViewAction)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
}

- (void)_prepareContentTable {
    _contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                      CGRectGetWidth(self.view.frame),
                                                                      CGRectGetHeight(self.view.frame))
                                                     style:UITableViewStylePlain];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    [_contentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_contentTableView];
}

#pragma mark - Button Action

/// 选择按钮
- (void)editContentTableViewAction {
    NSLog(@"cache = %@",_moviePathCache);
    
    /// 上传服务器路径
    NSURL *uploadFileURL = [NSURL URLWithString:@"ftp://guoyi:jkl;'@192.168.11.99/Desktop/Cache/"];
    /// 上传请求
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:uploadFileURL];
    [uploadRequest setHTTPMethod:@"POST"];
    
    /// 上传文件路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *localFileURL = [NSURL URLWithString:[documentPaths.firstObject stringByAppendingPathComponent:_moviePathCache.firstObject]];
    
    /// 请求设置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30.0f;
    configuration.timeoutIntervalForResource = 60.0f;
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 1;
    
    /// 网络回话
    NSURLSession *uploadSession = [NSURLSession sessionWithConfiguration:configuration
                                                                delegate:self
                                                           delegateQueue:[NSOperationQueue mainQueue]];
    
    /// 上传任务
    NSURLSessionUploadTask *uploadTask = [uploadSession uploadTaskWithRequest:uploadRequest
                                                                     fromFile:localFileURL
                                                            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                NSLog(@"error = %@ data = %@",error,data);
                                                            }];
    [uploadTask resume];
}

#pragma mark - URLSession Delegate

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

#pragma mark - TableView Delegate & Datasources

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _moviePathCache[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _moviePathCache.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@",paths.firstObject,_moviePathCache[indexPath.row]]];
    NSLog(@"play file = %@",fileURL.absoluteString);
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
    playerVC.player = [AVPlayer playerWithURL:fileURL];
    [self presentViewController:playerVC animated:YES completion:nil];
}

@end