//
//  ZWWDownFileViewController.m
//  SXTStudyDemo
//
//  Created by mac on 2018/5/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWDownFileViewController.h"

@interface ZWWDownFileViewController ()<NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UISlider *progress;
@property (nonatomic, assign) NSUInteger  totalSize;
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation ZWWDownFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//下载小文件方法1
- (IBAction)downFileFunc1:(id)sender {
    NSString *str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527674576820&di=b00a28e8649f105fb4d0a24e34697f33&imgtype=0&src=http%3A%2F%2Fi4.download.fd.pchome.net%2Fg1%2FM00%2F12%2F04%2FoYYBAFZS2uaIR_NiADNPLO6oiewAACx_gAAyJkAM09E943.jpg";
    //如果str有中文，中文转码
//    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    
    //会阻塞主线程
    NSData *data = [NSData dataWithContentsOfURL:url];
    [data writeToFile:@"/Users/mac/Desktop/aaa.jpg" atomically:NO];
}

//下载小文件方法2
- (IBAction)downFileFunc2:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527674576820&di=b00a28e8649f105fb4d0a24e34697f33&imgtype=0&src=http%3A%2F%2Fi4.download.fd.pchome.net%2Fg1%2FM00%2F12%2F04%2FoYYBAFZS2uaIR_NiADNPLO6oiewAACx_gAAyJkAM09E943.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue: [[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        ZWWLog(@"下载完成data 长度 == %ld",@(data.length));
        [data writeToFile:@"/Users/mac/Desktop/bbb.jpg" atomically:NO];
    }];
}


//下载小文件方法3：代理模式
- (IBAction)downFile:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527674576820&di=b00a28e8649f105fb4d0a24e34697f33&imgtype=0&src=http%3A%2F%2Fi4.download.fd.pchome.net%2Fg1%2FM00%2F12%2F04%2FoYYBAFZS2uaIR_NiADNPLO6oiewAACx_gAAyJkAM09E943.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //代理方式下载文件
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}

//返回响应头信息
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    ZWWLog(@"response==%@",res.allHeaderFields);
    ZWWLog(@"文件size == %ld",[res.allHeaderFields[@"Content-Length"]integerValue]);
    self.totalSize = [res.allHeaderFields[@"Content-Length"]integerValue];
    self.data = [[NSMutableData alloc]init];
    
}


//
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    ZWWLog(@"接收到的数据== %@",data);
    [self.data appendData:data];
    self.progress.value = self.data.length *1.0/self.totalSize;
}


//请求完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.data writeToFile:@"/Users/mac/Desktop/ccc.jpg" atomically:NO];
    ZWWLog(@"下载完成");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
