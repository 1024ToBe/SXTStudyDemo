//
//  ZWWTableViewController+method.h
//  MediaTest
//
//  Created by mac on 2018/5/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWTableViewController.h"

@interface ZWWTableViewController (method)

//沙盒路径
- (void)sanbox;

//通知监测网络状态
- (void)testNetWorkWithNoti;
//Block监测网络状态
- (void)testNetWorkWithBlock;

//NSURLConnection 异步请求
- (void)testAsynNSURLConnection;
//NSURLConnection 同步请求
- (void)testSynNSURLConnection;

//NSURLConnection
//get请求
- (void)getURLFunc;
//Post请求
- (void)postURLFunc;

//NSURLSession:get 请求
- (void)NSURLSessionGetURLFunc;

//NSURLSession:post 请求
- (void)NSURLSessionPostURLFunc;

//NSURLSession:下载文件
- (void)NSURLSessionDownLoadFileFunc;

//解压文件
- (void)unZip;

//压缩文件
- (void)createZip;
@end
