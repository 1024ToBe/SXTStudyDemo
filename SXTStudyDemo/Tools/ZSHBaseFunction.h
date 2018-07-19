//
//  ZSHBaseFunction.h
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/11/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSHBaseFunction : NSObject

/**
 * url加盐
 */
+ (NSString *)getFKEYWithCommand:(NSString *)cmd;
@end
