//
//  ZWWTableViewController+method.m
//  MediaTest
//
//  Created by mac on 2018/5/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWTableViewController+method.h"
#import "Reachability.h"
#import "SSZipArchive.h"
@implementation ZWWTableViewController (method)

//沙盒路径
- (void)sanbox{
    NSString *sanbox0 = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    //沙盒路径，Doc，Lib，tmp的上一层
    NSString *sanbox = NSHomeDirectory();
    ZWWLog(@"沙盒路径==%@",sanbox);
    
    NSString *tmpPath = NSTemporaryDirectory();
    ZWWLog(@"沙盒临时文件夹tmp路径==%@",tmpPath);
    
    //创建plist文件写入沙盒
    sanbox = [sanbox stringByAppendingPathComponent:@"zwwPlist"];
    NSArray *arr = @[@"beijing",@"大望路",@"赵薇"];
    [arr writeToFile:sanbox atomically:YES];
    ZWWLog(@"sandbox==%@",sanbox);
    
    //偏好设置：实质是plist文件,位置默认在Library中的Preferences中
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"tuisong"];
    [ud setObject:@"zww" forKey:@"name"];
    //马上存入沙盒
    [ud synchronize];
    
    //从NSUserDefaults 取内容
    ZWWLog(@"NSUserDefaults name==%@",[ud objectForKey:@"name"]);
    
    [ud removeObjectForKey:@"name"];
    
    
    
}

//通知监测网络状态
- (void)testNetWorkWithNoti{
    //1.创建监听通知
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    
    //2.注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeNetStatus:) name:kReachabilityChangedNotification object:nil];
    
    //3.开启监测
    [reach startNotifier];
    
    
}



- (void)changeNetStatus:(NSNotification *)noti{
    Reachability *reach = noti.object;
    switch (reach.currentReachabilityStatus) {
        case NotReachable:{
            ZWWLog(@"没有网络");
            break;
        }
        case ReachableViaWiFi:{
            ZWWLog(@"wifi网络");
            break;
        }
        case ReachableViaWWAN:{
            ZWWLog(@"收费2G,3G,4G流量网络");
            break;
        }
        default:
            break;
    }
}
//Block监测网络状态
- (void)testNetWorkWithBlock{
    //1.创建监听通知
    Reachability *reach = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    
    //2
//    reach.reachableBlock = ^(Reachability *reachability) {
//        ZWWLog(@"有网");
//    };
//    reach.unreachableBlock = ^(Reachability *reachability) {
//        ZWWLog(@"无网");
//    };
    
    reach.reachabilityBlock = ^(Reachability *reachability, SCNetworkConnectionFlags flags) {
        switch (reachability.currentReachabilityStatus) {
            case NotReachable:{
                ZWWLog(@"没有网络");
                break;
            }
            case ReachableViaWiFi:{
                ZWWLog(@"wifi网络");
                break;
            }
            case ReachableViaWWAN:{
                ZWWLog(@"收费2G,3G,4G流量网络");
                break;
            }
            default:
                break;
        }
    };
    //3.开启监测
    [reach startNotifier];
}

//NSURLConnection 异步请求
- (void)testAsynNSURLConnection{
    //1.url
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    //2.urlrequest
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //设置超时时间
//    NSURLRequestUseProtocolCachePolicy = 0,
//
//    NSURLRequestReloadIgnoringLocalCacheData = 1,       //全部请求网络
//    NSURLRequestReturnCacheDataElseLoad = 2,            //有缓存返回，没有就请求网络
//    NSURLRequestReturnCacheDataDontLoad = 3,            //只返回缓存，不请求网络
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:15];
    //3.url链接connection
    //sendAsynchronousRequest 发送异步请求
    //queue 放入的队列
    //response 请求的响应信息
    //data响应数据
    //connectionError 链接错误
    //200 返回正常 百度搜索http错误码
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        
        //获取状态码
        ZWWLog(@"response.statusCode == %@",@(res.statusCode));
        
         // 获取响应头
         ZWWLog(@"response.headers == %@",res.allHeaderFields);
//         ZWWLog(@"data == %@",data);
//        [data writeToFile:@"/Users/mac/Desktop/aaa" atomically:NO];
         ZWWLog(@"connectionError == %@",connectionError);
        
        if (connectionError) {
            ZWWLog(@"connectionError== %@",connectionError.localizedDescription);
        }else {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            ZWWLog(@"dataStr == %@",dataStr);
        }
    }];
    
}

//NSURLConnection 同步请求
- (void)testSynNSURLConnection{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    ZWWLog(@"response == %@",response);
    ZWWLog(@"data == %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}

//get请求
- (void)getURLFunc{
   
   
    //如果有中文进行中文转码(比如get请求需要拼接的参数value值为中文，不转码可能会导致该url为nil)
    //url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSString *from = @"qianqian";
    NSString *version = @"2.1";
    NSString *method = @"baidu.ting.artist.getinfo";
    NSString *format = @"json";
    NSString *tinguid = @"7994";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?from=%@&version=%@&method=%@&format=%@&tinguid=%@",KTestRequestBaseUrl,from,version,method,format,tinguid]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        ZWWLog(@"response.statusCode == %@",@(res.statusCode));
        ZWWLog(@"response.headers == %@",res.allHeaderFields);
        
        if (connectionError) {
            ZWWLog(@"connectionError== %@",connectionError.localizedDescription);
        }else {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            ZWWLog(@"dataStr == %@",dataStr);
        }
    }];
    
    
}

//Post请求
- (void)postURLFunc{
    
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
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        ZWWLog(@"response.statusCode == %@",@(res.statusCode));
        ZWWLog(@"response.headers == %@",res.allHeaderFields);
        
        if (connectionError) {
            ZWWLog(@"connectionError== %@",connectionError.localizedDescription);
        }else {
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            ZWWLog(@"dataStr == %@",dataStr);
        }
    }];
    
}

//NSURLSession:get 请求
- (void)NSURLSessionGetURLFunc{
   
    //如果有中文进行中文转码(比如get请求需要拼接的参数value值为中文，不转码可能会导致该url为nil)
    //url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSString *from = @"qianqian";
    NSString *version = @"2.1";
    NSString *method = @"baidu.ting.artist.getinfo";
    NSString *format = @"json";
    NSString *tinguid = @"7994";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?from=%@&version=%@&method=%@&format=%@&tinguid=%@",KTestRequestBaseUrl,from,version,method,format,tinguid]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //创建一个会话
    //session 默认是挂起状态
    NSURLSession *session = [NSURLSession sharedSession];
    //开启一个任务:方法1.通过url开启任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ZWWLog(@"NSURLSession 请求返回数据==%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //开启一个任务:方法2.通过request开启任务
//     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//         ZWWLog(@"NSURLSession 请求返回数据==%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//    }];
    
    //执行任务
    [task resume];
    
}

//NSURLSession:post 请求
- (void)NSURLSessionPostURLFunc{
    
    
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
    
    //创建一个会话
    //session 默认是挂起状态
    NSURLSession *session = [NSURLSession sharedSession];
    
    //开启一个任务:方法2.通过request开启任务
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ZWWLog(@"NSURLSession 请求返回数据==%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //执行任务
    [task resume];
}

//NSURLSession:下载文件
- (void)NSURLSessionDownLoadFileFunc{
    NSURL *url = [NSURL URLWithString:KLocalMP4Url];
    
    //创建一个会话
    //session 默认是挂起状态
    NSURLSession *session = [NSURLSession sharedSession];
    [[session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //当前临时文件的地址
        ZWWLog(@"下载完毕，文件存储位置location==%@",location);
        
        //保存之后的地址(获取本地沙盒路径)
        NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(13, 1, 1) lastObject]stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *toURL = [NSURL fileURLWithPath:cachePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error1 = nil;
        [fileManager moveItemAtURL:location toURL:toURL error:&error1];
        ZWWLog(@"erroer==%@",error);
        
        
    }] resume];
}

//使用SSZipArchive，需要导入libz.tbd
//解压文件
- (void)unZip{
    
   BOOL unZip = [SSZipArchive unzipFileAtPath:@"/Users/mac/Desktop/logo.zip" toDestination:@"/Users/mac/Desktop/logo" uniqueId:@"logo"];
    if (unZip) {
        ZWWLog(@"解压成功");
    }else{
        ZWWLog(@"解压失败");
    }
    
}

//压缩文件
- (void)createZip{
    
  //第一个参数：压缩完成的文件zip路径名字，第二个参数：被压缩的文件路径
  BOOL createZip = [SSZipArchive createZipFileAtPath:@"/Users/mac/Desktop/btn.zip" withContentsOfDirectory:@"/Users/mac/Desktop/btn"];
    if (createZip) {
        ZWWLog(@"压缩成功");
    }else{
        ZWWLog(@"压缩失败");
    }
    
}
@end
