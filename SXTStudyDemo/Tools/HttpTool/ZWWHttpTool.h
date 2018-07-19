//
//  ZWWHttpTool.h
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^HttpSuccessBlock) (id responseObject);
typedef void(^HttpFailedBlock) (NSError *error);
typedef void(^HttpDownloadProgressBlock) (CGFloat progress);
typedef void(^HttpUploadProgressBlock) (CGFloat progress);

@interface ZWWHttpTool : NSObject

/**
 get 网络请求
 
 @param urlStr  url地址
 @param params  请求参数
 @param success 请求成功：AFN有自动解析的功能，返回NSDictionary或者NSArray
 @param failed  请求失败：返回NSError
 */
+(void)getWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(HttpSuccessBlock)success failed:(HttpFailedBlock)failed;

/**
 post 网络请求
 
 @param urlStr  url地址
 @param params  请求参数
 @param success 请求成功：AFN有自动解析的功能，返回NSDictionary或者NSArray
 @param failed  请求失败：返回NSError
 */
+(void)postWithUrlStr:(NSString *)urlStr params:(NSDictionary *)params success:(HttpSuccessBlock)success failed:(HttpFailedBlock)failed;

/**
 下载文件

 @param urlStr      url地址
 @param success     下载成功
 @param failed      下载失败
 @param progress    下载进度
 */
+(void)dowmloadWithUrlStr:(NSString *)urlStr
                  success:(HttpSuccessBlock)success
                   failed:(HttpFailedBlock)failed
                 progress:(HttpDownloadProgressBlock)progress;


/**
 上传文件

 @param urlStr      url地址
 @param params      请求参数
 @param thumbName   imageKey
 @param image       上传图片
 @param success     上传成功
 @param failed      上传失败
 @param progress    上传进度
 */
+(void)uploadWithUrlStr:(NSString *)urlStr
                 params:(NSDictionary *)params
              thumbName:(NSString *)imageKey
                  image:(UIImage *)image
                success:(HttpSuccessBlock)success
                 failed:(HttpFailedBlock)failed
               progress:(HttpUploadProgressBlock)progress;
@end
