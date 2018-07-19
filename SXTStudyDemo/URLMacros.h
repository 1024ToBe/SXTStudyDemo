//
//  URLMacros.h
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#ifndef URLMacros_h
#define URLMacros_h

#ifdef DEBUG

#define DevelopSever    0
#define TestSever       0
#define ProductSever    1

#else

#define ProductSever    1

#endif


#if DevelopSever

/**开发服务器*/
#define kUrlRoot                   @"http://192.168.1.101:8082/gemstone/"  // 振华


#elif TestSever

/**测试服务器*/
#define kUrlRoot                    @"http://192.168.1.113:8082/gemstone/"  // 振华

#elif ProductSever

/**生产服务器（阿里云）*/
#define kUrlRoot                    @"http://gem.rongyaohk.com/"


#endif


//5.app根据导航栏显示轮播图
//http://localhost:8082/gemstone/home/broadcast?BROADCAST&NAVICATION_TYPE=1
//请求参数：NAVICATION_TYPE：导航类型：1-首页，3-OTO
#define kUrlBroadCast [NSString stringWithFormat:@"/home/broadcast?FKEY=%@", [ZSHBaseFunction getFKEYWithCommand:@"BROADCAST"]]

#endif /* URLMacros_h */
