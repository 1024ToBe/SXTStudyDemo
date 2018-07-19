//
//  ZWWAFNPracticeViewController.m
//  SXTStudyDemo
//
//  Created by mac on 2018/7/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWAFNPracticeViewController.h"
#import "NSString+Hash.h"
#import "UIImageView+SDWebImage.h"
#import "ZWWHttpTool.h"
@interface ZWWAFNPracticeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *showSDIV;

@end

@implementation ZWWAFNPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}
//Base64 A~Z a~z + = 0~9生成加密后的字符。
//base64根据原数据的长度而影响加密后数据的长度，是可逆的
- (IBAction)base64Test:(id)sender {
    //ios7 之后base64 直接嵌入到框架中了，可以直接使用api
    //加密前字符串
    NSString *str1 = @"ABC";
    //转化为对应二进制
    NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    //加密后的字符串（也可以加密成NSData二进制流）
    NSString *str2 = [data1 base64EncodedStringWithOptions:0];
    ZWWLog(@"加密后的字符串==%@",str2);
    
    
    //解密后的二进制
    NSData *data2 = [[NSData alloc]initWithBase64EncodedString:str2 options:0];
    //解密后的字符串
    NSString *str3 = [[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    ZWWLog(@"解密后的字符串==%@",str3);
}

//加密图片
- (IBAction)base64ImgTest:(id)sender {
    
    NSString *imgPath = [[NSBundle mainBundle]pathForResource:@"flower.jpg" ofType:nil];

    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    ZWWLog(@"原图片==%@",img);
    NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
    
    //加密
    NSString *imgStr = [imgData base64EncodedStringWithOptions:0];
    ZWWLog(@"加密后的图片字符串==%@",imgStr);
    
    //这样在请求数据后台上传图片时，可以不再使用表单样式，可以直接和正常的参数一样采用post上传data二进制数，后台拿到后解密获取图片即可
    
    
    //解密
    NSData *data = [[NSData alloc]initWithBase64EncodedString:imgStr options:0];
    UIImage *imag2 = [UIImage imageWithData:data];
    ZWWLog(@"解密后的图片==%@",imag2);
}

//可生成32位，也可生成64位固定位数密文。所有会丢失信息，不可逆
- (IBAction)MD5Test:(id)sender {
    NSString *str = @"123456";
    NSString *encode = str.md5String;
    ZWWLog(@"MD5加密后的字符串==%@",encode);
    
    //MD5加盐：盐可以是时间戳（精确到分就可以了，因为精确到秒的话，请求服务器和服务器获取请求不在1s内，就无法验证请求的盐参数对不对）（增加安全性）
    NSString *sault = [str stringByAppendingString:@"pwd"];
    ZWWLog(@"MD5加盐加密后的字符串==%@",sault.md5String);
}

//SDWebImage二次封装
- (IBAction)packSDWebImage:(id)sender {
//    [self.showSDIV downloadImage:@"http://www.188hua.cn/photo/10207120.jpg" placeholder:@"flower.jpg"];
    
    [self.showSDIV downloadImage:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531991575840&di=506622a2b15ff0640398449bb5208315&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F15%2F33%2F49%2F27r58PIC3W6_1024.jpg" placeholder:@"flower.jpg" success:^(UIImage *image) {
        ZWWLog(@"图片下载成功");
    } failed:^(NSError *error) {
        ZWWLog(@"下载图片失败==%@",error);
    } progress:^(CGFloat progress) {
        ZWWLog(@"图片下载进度==%f",progress);
    }];
}
- (IBAction)packAFNGet:(id)sender {
}

- (IBAction)packAFNPost:(id)sender {
    
    [ZWWHttpTool postWithUrlStr:kUrlBroadCast params:@{@"NAVICATION_TYPE":@"3"} success:^(id responseObject) {
        ZWWLog(@"post请求获取的参数==%@",responseObject);
    } failed:^(NSError *error) {
        ZWWLog(@"post请求失败==%@",error);
    }];
}

- (IBAction)packAFNDownload:(id)sender {
    [ZWWHttpTool dowmloadWithUrlStr:KLocalMP4Url success:^(id responseObject) {
        ZWWLog(@"下载成功的路径位置==%@",responseObject);
    } failed:^(NSError *error) {
        ZWWLog(@"下载失败error=%@",error);
    } progress:^(CGFloat progress) {
        ZWWLog(@"下载进度==%f",progress);
    }];
}
- (IBAction)packAFNUpload:(id)sender {
    UIImage *image = [UIImage imageNamed:@"flower.jpg"];
    [ZWWHttpTool uploadWithUrlStr:@"LocalServer/jpg" params:nil thumbName:@"" image:[] success:^(id responseObject) {
        ZWWLog(@"上传成功==%@",responseObject);
    } failed:^(NSError *error) {
        ZWWLog(@"上传失败");
    } progress:^(CGFloat progress) {
        ZWWLog(@"上传进度==%f",progress);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
