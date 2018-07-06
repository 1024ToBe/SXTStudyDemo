//
//  ZWWDownBigFileViewController.m
//  SXTStudyDemo
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWDownBigFileViewController.h"

@interface ZWWDownBigFileViewController ()<NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (nonatomic, assign) NSUInteger totalSize;
@property (nonatomic, assign) NSUInteger currentLength;
@property (nonatomic, strong) NSFileHandle *handle;

@end

@implementation ZWWDownBigFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)downBigFile:(id)sender {
    NSURL *url = [NSURL URLWithString:KLocalMP4Url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

//返回响应头信息
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)res;
    self.totalSize = [res.allHeaderFields[@"Content-Length"]integerValue];
    
    //创建一个空文件
    [[NSFileManager defaultManager]createFileAtPath:KFileHandlePath contents:nil attributes:nil];
    
    //创建一个只写的句柄
    self.handle = [NSFileHandle fileHandleForWritingAtPath:KFileHandlePath];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //实现边下载边写入
    //把句柄移至末尾
    [self.handle seekToEndOfFile];
    
    //写入每次回传的数据
    [self.handle writeData:data];
    
    self.currentLength+=data.length;
    self.progress.progress = self.currentLength*1.0/self.totalSize;
}

//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    ZWWLog(@"下载完成");
    //关闭句柄
    [self.handle closeFile];
    
    //
    self.currentLength = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
