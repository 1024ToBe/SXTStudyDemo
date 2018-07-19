//
//  ZWWSessionDelegateDownFileVC.m
//  SXTStudyDemo
//
//  Created by mac on 2018/6/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWSessionDelegateDownFileVC.h"

@interface ZWWSessionDelegateDownFileVC ()<NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) NSURLSessionDownloadTask  *task;
@property (nonatomic, strong) NSURLSession              *session;
@property (nonatomic, strong) NSData                    *resumeData;
@property (nonatomic, assign) CGFloat                   progress;

@end

@implementation ZWWSessionDelegateDownFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//继续下载
- (IBAction)resume:(id)sender {
    //根据已下载的数据创建任务
    self.task = [self.session downloadTaskWithResumeData:self.resumeData];
    //继续下载
    [self.task resume];

}

//暂停下载
- (IBAction)pauseDownLoadFile:(id)sender {
    
    //暂停下载即把任务挂起
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
    
}

//开始下载
- (IBAction)startDownLoadFile:(id)sender {
    //最新中文处理
    //NSString *str = [@"ssfd" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //初始化一个含delegate的session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.session = session;
    
    NSURL *url = [NSURL URLWithString:KLocalMP4Url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
    [task resume];
    self.task = task;
}

//下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    ZWWLog(@"下载完成");
    
    
    //获取缓存路径
    NSString *cachePath = [[ NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    ZWWLog(@"下载存放的临时文件路径==%@，保存文件的路径==%@",location,cachePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:cachePath] error:nil];
    
    
}

//下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //bytesWritten:每次写入数据大小
    //totalBytesWritten:已经写入数据的大小
    //totalBytesExpectedToWrite:文件总大小
    _progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    ZWWLog(@"每次写入数据大小==%lld，已经写入文件大小==%lld,文件总大小==%lld,下载进度==%lf",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite,_progress);
    
    //回到主线程刷新UI
    //方法1
//    _totalBytesWritten = totalBytesWritten;
//    _totalBytesExpectedToWrite = totalBytesExpectedToWrite;
//    [self performSelectorOnMainThread:@selector(updateSlider) withObject:nil waitUntilDone:NO];
    
    //方法2：NSOperationQueue
//    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//        self.slider.value = self.progress;
//    }];
    
    //方法3：GCD
    dispatch_async(dispatch_get_main_queue(), ^{
        self.slider.value = self.progress;
    });
    
}

//结束请求
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    ZWWLog(@"结束请求");
}

- (void)updateSlider{
    self.slider.value = self.progress;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
