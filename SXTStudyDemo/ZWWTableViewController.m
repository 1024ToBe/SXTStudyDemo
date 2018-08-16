//
//  ZWWTableViewController.m
//  MediaTest
//
//  Created by mac on 2018/5/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZWWTableViewController.h"
#import "ZWWTableViewController+method.h"
#import "ZWWDownFileViewController.h"
#import "ZWWDownBigFileViewController.h"
#import "ZWWNSURLSessionDelegateViewController.h"
#import "ZWWSessionDelegateDownFileVC.h"
#import "ZWWAFNViewController.h"
#import "ZWWAFNPracticeViewController.h"
@interface ZWWTableViewController ()

@property (nonatomic, strong) NSArray  *sectionTitleArr;
@property (nonatomic, strong) NSArray  *titleArr;


@end

@implementation ZWWTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionTitleArr = @[@"day03-SDWebImage学习",@"day04-NSURLConnection",@"NSURLSession&AFN"];
    _titleArr = @[@[@"01.沙盒路径",@"02.内存中保存图片"],
                  @[@"01.网络监听通知",@"02.网络监听Block",@"03.NSURLConnection异步",@"05.NSURLConnection同步请求",@"0601.NSURLConnection Get,Post请求:get请求",@"NSURLConnection Get,Post请求:post请求",@"07.小文件下载",@"08.大文件下载"],
                  @[@"NSURLSession:get请求",@"NSURLSession:post请求",@"NSURLSession:下载文件",@"解压文件",@"压缩文件",@"NSURLSession 代理",@"NSURLSession 代理方式下载文件",@"断点续传",@"AFN详情",@"AFN封装项目实战"]
    
                  ];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"baseCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _sectionTitleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_titleArr[section]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"baseCell" forIndexPath:indexPath];
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    titleLB.backgroundColor = [UIColor cyanColor];
    [titleLB setTextAlignment:NSTextAlignmentCenter];
    titleLB.text = _sectionTitleArr[section];
    [titleLB setTextColor:[UIColor blackColor]];
    
    return titleLB;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{//day03-SDWebImage学习
            switch (indexPath.row) {
                case 0:{//沙盒路径
                    [self sanbox];
                    break;
                }
                case 1:{//沙盒路径
                    [self sanbox];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case 1:{//day04-NSURLConnection
            switch (indexPath.row) {
                case 0:{//通知监测网络
                    [self testNetWorkWithNoti];
                    break;
                }
                case 1:{//Block监测网络
                    [self testNetWorkWithBlock];
                    break;
                }
                case 2:{//NSURLConnection异步请求
                    [self testAsynNSURLConnection];
                    break;
                }
                case 3:{//NSURLConnection同步请求
                    [self testSynNSURLConnection];
                    break;
                }
                case 4:{//0601.NSURLConnection Get,Post请求:get请求
                    [self getURLFunc];
                    break;
                }
                case 5:{//06.NSURLConnection Get,Post请求:post请求
                    [self postURLFunc];
                    break;
                }
                case 6:{//小文件下载
                    ZWWDownFileViewController *downFileVC = [[ZWWDownFileViewController alloc]initWithNibName:@"ZWWDownFileViewController" bundle:nil];
                    [self.navigationController pushViewController:downFileVC animated:YES];
                    break;
                }
                case 7:{//小文件下载
                    ZWWDownBigFileViewController *downBigFileVC = [[ZWWDownBigFileViewController alloc]initWithNibName:@"ZWWDownBigFileViewController" bundle:nil];
                    [self.navigationController pushViewController:downBigFileVC animated:YES];
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case 2:{//NSURLSession&AFN
            switch (indexPath.row) {
                case 0:{//NSURLSession Get,Post请求:get请求
                    [self NSURLSessionGetURLFunc];
                    break;
                }
                case 1:{//NSURLSession Get,Post请求:post请求
                    [self NSURLSessionPostURLFunc];
                    break;
                }
                case 2:{//下载文件
                    [self NSURLSessionDownLoadFileFunc];
                    break;
                }
                case 3:{//解压文件
                    [self unZip];
                    break;
                }
                case 4:{//压缩文件
                    [self createZip];
                    break;
                }
                case 5:{//NSURLSession 代理
                    ZWWNSURLSessionDelegateViewController *sessionDeleVC = [[ZWWNSURLSessionDelegateViewController alloc]init];
                    [self.navigationController pushViewController:sessionDeleVC animated:YES];
                    break;
                }
                case 6://NSURLSession 代理方式下载文件: 可以显示下载进度
                case 7:{//断点续传
                    ZWWSessionDelegateDownFileVC *sessionDeleDownVC = [[ZWWSessionDelegateDownFileVC alloc]init];
                    [self.navigationController pushViewController:sessionDeleDownVC animated:YES];
                    break;
                }
                case 8:{//AFN详情：get请求
                    ZWWAFNViewController *AFNVC = [[ZWWAFNViewController alloc]init];
                    [self.navigationController pushViewController:AFNVC animated:YES];
                    break;
                }
                    
                case 9:{//AFN项目实战
                    ZWWAFNPracticeViewController *AFNPracticeVC = [[ZWWAFNPracticeViewController alloc]init];
                    [self.navigationController pushViewController:AFNPracticeVC animated:YES];
                    break;
                }
                default:
                    break;
            }
            
            break;
        }
        default:
            break;
    }
}

@end
