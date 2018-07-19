//
//  ZWWNSURLSessionDelegateViewController.m
//  SXTStudyDemo
//
//  Created by mac on 2018/5/31.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWNSURLSessionDelegateViewController.h"

@interface ZWWNSURLSessionDelegateViewController ()<NSURLSessionDataDelegate>

@end

@implementation ZWWNSURLSessionDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //delegateQueue:写全局队列，也可以为nil
   NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc]init] ];
    
   
    NSString *from = @"qianqian";
    NSString *version = @"2.1";
    NSString *method = @"baidu.ting.artist.getinfo";
    NSString *format = @"json";
    NSString *tinguid = @"7994";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?from=%@&version=%@&method=%@&format=%@&tinguid=%@",KTestRequestBaseUrl,from,version,method,format,tinguid]];
    
    //post请求需要使用可变的request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置请求方法
    request.HTTPMethod = @"POST";
    //请求参数
    NSString *params = [NSString stringWithFormat:@"from=%@&version=%@&method=%@&format=%@&tinguid=%@",from,version,method,format,tinguid];
    //设置请求体
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    //request方法
    [[session dataTaskWithRequest:request]resume];
    //直接通过url的方法
//    [[session dataTaskWithURL:[NSURL URLWithString:@"http://www.baidu.com"]] resume];
    
}

//得到响应信息
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    ZWWLog(@"开始接收数据");
    
    //允许数据回传
    completionHandler(NSURLSessionResponseAllow);
}

//开始接收下载数据（得到服务器回传数据）：有可能调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    ZWWLog(@"接收到的数据data == %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    ZWWLog(@"数据接收完毕");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
