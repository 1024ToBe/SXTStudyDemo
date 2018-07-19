//
//  UIImageView+SDWebImage.h
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DownloadImageSuccessBlock)(UIImage *image);
typedef void(^DownloadImageFailedBlock)(NSError *error);
typedef void(^DownloadImageProgressBlock)(CGFloat progress);

@interface UIImageView (SDWebImage)

/**
 异步加载图片

 @param url         图片地址
 @param imageName   占位图片名
 */
- (void)downloadImage:(NSString *)url placeholder:(NSString *)imageName;



/**
 异步加载图片，可监听图片下载进度

 @param url         图片地址
 @param imageName   占位图片名
 @param success     下载成功回调
 @param failed      下载失败回调
 @param progress    下载进度
 */
- (void)downloadImage:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress;
@end
