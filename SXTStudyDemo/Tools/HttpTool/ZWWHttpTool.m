//
//  ZWWHttpTool.m
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWHttpTool.h"
#import "AFNetworking/AFNetworking.h"


@interface AFHttpClient :AFHTTPSessionManager

//因为要访问他的很多属性，所以写个单例比较方便
+(instancetype)sharedAFHttpClient;

@end

@implementation AFHttpClient
+(instancetype)sharedAFHttpClient{
    static AFHttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        client = [[AFHttpClient alloc]initWithBaseURL:[NSURL URLWithString:kUrlRoot] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",@"image/gif",nil];
        //安全策略
        //1.使用非检验证书模式(可以使用抓包工具抓取https请求数据)
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
        //2.使用检验证书模式(不可以使用抓包工具抓取https请求数据)
        //先导入证书
//        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"hgcang" ofType:@"cer"];//证书的路径
//        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
//        
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
//        securityPolicy.pinnedCertificates = @[cerData];
//        client.securityPolicy = securityPolicy;
        //客户端是否信任非法证书
        client.securityPolicy.allowInvalidCertificates = YES;
        
        //是否在证书域名字段中验证域名
        [client.securityPolicy setValidatesDomainName:NO];
    });
    return client;
}
@end

@implementation ZWWHttpTool


+(void)getWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(HttpSuccessBlock)success failed:(HttpFailedBlock)failed{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认接收AFJSONResponseSerializer类型,AFJSONResponseSerializer类型只有三种
//    - `application/json`
//    - `text/json`
//    - `text/javascript`
//    manager.responseSerializer =
    
    //所以为了能够获得更多类型的请求数据，我们最好自定义AFHTTPSessionManager
    
    //完整请求地址
    NSString *url = [kUrlRoot stringByAppendingString:urlStr];
    [[AFHttpClient sharedAFHttpClient]GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
    
}

+(void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(HttpSuccessBlock)success failed:(HttpFailedBlock)failed{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //默认接收AFJSONResponseSerializer类型,AFJSONResponseSerializer类型只有三种
    //    - `application/json`
    //    - `text/json`
    //    - `text/javascript`
    //    manager.responseSerializer =
    
    //所以为了能够获得更多类型的请求数据，我们最好自定义AFHTTPSessionManager
    
    //完整请求地址
    NSString *url = [kUrlRoot stringByAppendingString:urlStr];
    [[AFHttpClient sharedAFHttpClient]POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
    
}

+(void)dowmloadWithUrlStr:(NSString *)urlStr
                  success:(HttpSuccessBlock)success
                   failed:(HttpFailedBlock)failed
                 progress:(HttpDownloadProgressBlock)progress{
    NSURL *URL = nil;
    if ([urlStr hasPrefix:@"http"]) {
        URL = [NSURL URLWithString:urlStr];
    } else {
        //完整请求地址
        NSString *urlString = [kUrlRoot stringByAppendingString:urlStr];
        URL = [NSURL URLWithString:urlString];
    }
  
   
    //下载是NSURLRequest方法，并不是HTTP的请求方法
//    [AFHttpClient sharedAFHttpClient] downloadTaskWithRequest:(nonnull NSURLRequest *) progress:<#^(NSProgress * _Nonnull downloadProgress)downloadProgressBlock#> destination:<#^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)destination#> completionHandler:<#^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)completionHandler#>
    
  
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedAFHttpClient] downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //获取沙盒缓存cache路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        ZWWLog(@"沙盒缓存路径==%@",documentsDirectoryURL);
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            failed(error);
        } else {
            success(filePath.path);
        }
        
    }];
    [downloadTask resume];
    
}

+(void)uploadWithUrlStr:(NSString *)urlStr
                 params:(NSDictionary *)params
              thumbName:(NSString *)imageKey
                  image:(UIImage *)image
                success:(HttpSuccessBlock)success
                 failed:(HttpFailedBlock)failed
               progress:(HttpUploadProgressBlock)progress{
    
    //完整请求地址
    NSString *urlString = [kUrlRoot stringByAppendingString:urlStr];
    //和后台约定好图片是png格式还是jpg格式
    NSData *data = UIImagePNGRepresentation(image);
    [[AFHttpClient sharedAFHttpClient]POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:imageKey fileName:@"flower.jpg" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
}

@end
