//
//  UIImageView+SDWebImage.m
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UIImageView+SDWebImage.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (SDWebImage)

//对SDWebImage二次封装的意义：
//比如SDWebImage升级版本后，setImageWithURL统一换成了 sd_setImageWithURL，我们做二次封装后就可以不用在好多处setImageWithURL替换为sd_setImageWithURL
- (void)downloadImage:(NSString *)url placeholder:(NSString *)imageName{
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority];

}

- (void)downloadImage:(NSString *)url
          placeholder:(NSString *)imageName
              success:(DownloadImageSuccessBlock)success
               failed:(DownloadImageFailedBlock)failed
             progress:(DownloadImageProgressBlock)progress{
    
    [self sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:imageName] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        progress(receivedSize*1.0/expectedSize);

    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            failed(error);
        } else {
            self.image = image;
            success(image);
        }
    }];
    
}
@end
