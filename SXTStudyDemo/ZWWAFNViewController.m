//
//  ZWWAFNViewController.m
//  SXTStudyDemo
//
//  Created by mac on 2018/6/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWAFNViewController.h"
#import <AFNetworking.h>


#define Kboundary @"----WebKitFormBoundaryjv0UfA04ED44AhWx"

#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface ZWWAFNViewController ()

@end

@implementation ZWWAFNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

//get 请求方式1
- (IBAction)get1:(id)sender {
    
    //创建一个配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //初始化session管理类
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //get请求url
    NSString *from = @"qianqian";
    NSString *version = @"2.1";
    NSString *method = @"baidu.ting.artist.getinfo";
    NSString *format = @"json";
    NSString *tinguid = @"7994";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?from=%@&version=%@&method=%@&format=%@&tinguid=%@",KTestRequestBaseUrl,from,version,method,format,tinguid]];
    //get 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //post请求需要使用可变的request
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    //设置请求方法
//    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
           ZWWLog(@"请求失败");
        } else {
            ZWWLog(@"请求到的数据==%@",responseObject);
            
            //AFN帮我们进行了json解析
//            [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
    }];
    [dataTask resume];
    
}

//get 请求方式2
- (IBAction)get2:(id)sender {
    
    
    //初始化session管理类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramDic = @{@"from":@"qianqian",@"version":@"2.1",@"method":@"baidu.ting.artist.getinfo",@"format":@"json",@"tinguid":@"7994"};
    [manager GET:KTestRequestBaseUrl parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //AFN帮我们进行了json解析
        ZWWLog(@"请求到的数据==%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZWWLog(@"get请求失败");
    }];
    
}
- (IBAction)post1:(id)sender {
    //初始化session管理类
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramDic = @{@"from":@"qianqian",@"version":@"2.1",@"method":@"baidu.ting.artist.getinfo",@"format":@"json",@"tinguid":@"7994"};

    [manager POST:KTestRequestBaseUrl parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZWWLog(@"请求到的数据==%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZWWLog(@"post请求失败");
    }];
    
    
}
- (IBAction)post2:(id)sender {
    
     NSDictionary *paramDic = @{@"from":@"qianqian",@"version":@"2.1",@"method":@"baidu.ting.artist.getinfo",@"format":@"json",@"tinguid":@"7994"};
    
    //get请求比较简单，就不太需要用这种方式进行get请求了
    //省去手动创建NSMutableURLRequest
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:KTestRequestBaseUrl parameters:paramDic error:nil];
    
    //创建一个配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //初始化session管理类
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            ZWWLog(@"请求失败");
        } else {
            ZWWLog(@"请求到的数据==%@",responseObject);
        }
    }];
    [dataTask resume];
    
    
}

//下载
- (IBAction)download:(id)sender {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:KLocalMP4Url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //获取沙盒Documents路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        ZWWLog(@"沙盒Documents路径==%@",documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //最终完成下载文件存放的位置
        ZWWLog(@"File downloaded to: %@", filePath);
        
    }];
    [downloadTask resume];
    
}

//上传1
- (IBAction)upload1:(id)sender {
    //上传图片urlSession
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:KLocalUploadServer parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"christmass_star_2.png" withExtension:nil];
//        //FileURL:本地文件路径
//        //name:图片的key
//        //fileName:随意写，因为后台会根据时间戳重新赋值，不会根据上传的这个filename给文件命名
//        //mimeType:文件类型
//        [formData appendPartWithFileURL:fileUrl name:@"userfile00" fileName:@"christmass_star_2.png" mimeType:@"image/png" error:nil];
        
        NSURL *fileUrl1 = [NSURL URLWithString:@"http://192.168.1.113/christmass_star_2.png"];
        NSData *data = [NSData dataWithContentsOfURL:fileUrl1];
        UIImage *image = [UIImage imageWithData:data];
        NSData *data2 = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data2 name:@"userfile00" fileName:@"christmass_star_2.png" mimeType:@"image/png"];
    } error:nil];
    
   
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
   
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            ZWWLog(@"上传失败Error == %@",error);
        }else {
            ZWWLog(@"上传成功 response=%@ responseObject=%@",response,responseObject);
        }
    }];
    [uploadTask resume];
}

//上传2
- (IBAction)upload2:(id)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:KLocalUploadServer parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"flower.jpg" withExtension:nil];
        //上传表单操作
        [formData appendPartWithFileURL:fileURL name:@"userFile00" fileName:@"flower.jpg" mimeType:@"LocalServer/jpg" error:NULL];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ZWWLog(@"上传进度==%@",@(uploadProgress.fractionCompleted));
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZWWLog(@"上传成功数据==%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZWWLog(@"上传失败==%@",error);
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
