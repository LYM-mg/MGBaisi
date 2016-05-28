//
//  BSAdvertiseController.m
//  02-BaiSi
//
//  Created by ming on 13/12/18.
//  Copyright © 2015年 ming. All rights reserved.
//


#define BSCode @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"
/*
 
 ori_curl
 w
 h
 w_picurl
 
完整URL = 基本URL?请求参数
基本URL  http://mobads.baidu.com/cpro/ui/mads.php


// json解析网页
http://tool.oschina.net/codeformat/json
*/

#import "BSAdvertiseController.h"
#import "BSTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BSAdItem.h"
#import <SVProgressHUD.h>


@interface BSAdvertiseController ()
#pragma mark - 属性
/** 广告模型 */
@property (nonatomic,strong) BSAdItem *adItem;
/** 背景 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageVeiw;
/** 广告 */
@property (strong, nonatomic) UIImageView *adImageVeiw;
/** 跳过按钮 */
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
/** 定时器 */
@property (weak, nonatomic) NSTimer *timer;
/** 会话管理者 */
@property (weak, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation BSAdvertiseController
#pragma mark - 设置图片
// 懒加载
- (UIImageView *)adImageVeiw{
    if (!_adImageVeiw) {
        // 0.创建_adImageVeiw
        _adImageVeiw = [[UIImageView alloc] init];
        // 1.让图片可以交互
        self.adImageVeiw.userInteractionEnabled = YES;
        // 2.添加到父控件
        [self.view insertSubview:_adImageVeiw belowSubview:self.skipButton];
        // 3.添加点按手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jump)];
        [_adImageVeiw addGestureRecognizer:pan];
    }
    return _adImageVeiw;
}

// 监听点按手势
- (void)jump{
    NSURL *url = [NSURL URLWithString:_adItem.ori_curl];
    // 是否能打开URL
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - 开启定时器
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
     return _timer;
}

- (void)timeChange{
    static int t = 3; // 必须用static修饰
    NSString *str = [NSString stringWithFormat:@"跳过广告(%d)",t];
    [self.skipButton setTitle:str forState:UIControlStateNormal];
    if (t==-1) {
        [self skipButtonClick];
    }
    t--;
}

#pragma mark - 跳过广告
/**
 *  跳过广告按钮的点击
 */
- (IBAction)skipButtonClick {
    // 1.移除定时器
    [self.timer invalidate];
    
    // 2.取消所有任务
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 3.移除会话管理者 invalidateSessionCancelingTasks:是否需要任务完成后再取消，这里填NO
    [_manager invalidateSessionCancelingTasks:NO];
    
    /// 自己增加：转场动画的使用
    CATransition *transAnimation = [[CATransition alloc] init];
    transAnimation.type = @"rippleEffect"; // 水花
    transAnimation.duration = 0.5; // 动画时间
    [BSKeyWindow.layer addAnimation:transAnimation forKey:nil];
    
    // 3.创建TabBar控制器
    BSTabBarController *tabBarVC = [[BSTabBarController alloc] init];

    // 4.TabBar控制器成为主窗口
    BSKeyWindow.rootViewController = tabBarVC;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.屏幕适配
    [self setupScreenHeight];
    
    // 2.加载广告数据
    [self loadData];
    
    // 3.开启定时器
    [self timer];
    
//    NSLog(@"联网状态%@",);
//    NSLog(@"%ld",(long)_manager.reachabilityManager.networkReachabilityStatus);
}

#pragma mark - 屏幕适配
// 1.屏幕适配
- (void)setupScreenHeight{
    if (iPone6P) {
        _bgImageVeiw.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iPone6){
        _bgImageVeiw.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    }else if (iPone5){
        _bgImageVeiw.image = [UIImage imageNamed:@"LaunchImage-568h@2x"];
    }else if (iPone4){
    _bgImageVeiw.image = [UIImage imageNamed:@"LaunchImage"];
    }
}

#pragma mark - 加载广告数据
// 2.加载广告数据
- (void)loadData{
    // 创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    self.manager = manager;
    
    // 请求超时时间（超过这个时间就会来到fail那个Block里面）
    manager.requestSerializer.timeoutInterval = 5.0;
    
    // 第一种方法解决
    // 增加系列化的解析方式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    // 请求传递的参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = BSCode;
    
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject == nil) return;
        // 字典转模型 （模型数组）
        NSMutableArray *adArray = [BSAdItem mj_objectArrayWithKeyValuesArray:responseObject[@"ad"]];
        // 取得模型数组的最后一个模型
        BSAdItem *adItem = [adArray firstObject];
        self.adItem = adItem;
        
        // 判断一下广告模型是否为空
        if (self.adItem) {  // 有广告
            // 设置广告的尺寸
            CGFloat w = BSScreenW;
            CGFloat h = BSScreenW*adItem.h/adItem.w;
            
            self.adImageVeiw.frame = CGRectMake(0, 0, w, h);
            [self.adImageVeiw sd_setImageWithURL:[NSURL URLWithString:adItem.w_picurl]];
        }else{ // 没有广告
            [SVProgressHUD showErrorWithStatus:@"当前没有广告页面"];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        BSLog(@"%@",error);
    }];
    
}

@end
