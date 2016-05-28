//
//  BSNavigationController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSNavigationController.h"

#define BSBarButtonItemFont [UIFont systemFontOfSize:15]

@interface BSNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BSNavigationController
/** 
 *  为什么在这里设置？？？
 *  设置导航栏全局样式
 *  因为这个只需要设置一次，因为这个方法程序只会执行一次
 */
+ (void)load{
    /// 1.UINavigationBar
    UINavigationBar *navBarAppearence = [UINavigationBar appearance];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navBarAppearence setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [navBarAppearence setTitleTextAttributes:dict];
    
    /// 2.UIBarButtonItem
    UIBarButtonItem *barItemAppearence = [UIBarButtonItem appearance];
    NSMutableDictionary *normalDict = [NSMutableDictionary dictionary];
    normalDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    normalDict[NSFontAttributeName] = BSBarButtonItemFont;
    [barItemAppearence setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
    NSMutableDictionary *highLDict = [NSMutableDictionary dictionary];
    highLDict[NSForegroundColorAttributeName] = BSGlobalBgColor;
    highLDict[NSFontAttributeName] = BSBarButtonItemFont;
    [barItemAppearence setTitleTextAttributes:highLDict forState:UIControlStateHighlighted];
}
/*
 <UIScreenEdgePanGestureRecognizer: 0x7fe260640220; view = <UILayoutContainerView 0x7fe26062bba0>;
 target= <(action=handleNavigationTransition:,
 target=<_UINavigationInteractiveTransition 0x7fe26063f1a0>)>>
 
 1.UIScreenEdgePanGestureRecognizer 加在导航控制器的view上
 
 2.target:_UINavigationInteractiveTransition(触发手势的对象)
 
 3.action: handleNavigationTransition:(这个方法系统内部调用，不需要自己实现)
 
 触发UIScreenEdgePanGestureRecognizer就会调用target的handleNavigationTransition:方法
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // UIScreenEdgePanGestureRecognizer
    // Do any additional setup after loading the view.
    // 只要触发这个Pan手势,就会调用self对象pan方法
    // 1.创建全屏手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    // 控制手势什么时候触发
    pan.delegate = self;
    
    // 全屏滑动返回
    [self.view addGestureRecognizer:pan];
    
    // 2.禁止边缘手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    // 实现滑动返回功能
//    self.interactivePopGestureRecognizer.delegate = self;
    
    // bug:假死:程序一直运行,但是界面动不了.
    // 在根控制器的view,不需要滑动返回,
    
    // 全屏滑动返回
    // 研究下系统自带的返回手势
//    NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
}

#pragma mark - UIGestureRecognizerDelegate 
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 不是根控制器就实现滑动返回功能
    return self.childViewControllers.count != 1;
}

// 拦截控制器的push操作
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 判断是否为根控制器
    if (self.childViewControllers.count > 0) { // 非根控制器
        // 统一设置设置返回按钮
        UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] norColor:BSColor(66, 66, 66) selColor:BSColor(255, 0, 0) title:@"返回" target:self action:@selector(backClick)];
    
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        // 2.隐藏底部TabBar导航条
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

// 出栈
- (void)backClick{
    [self popViewControllerAnimated:YES];
}

@end
