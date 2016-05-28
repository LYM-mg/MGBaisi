//
//  BSTabBarController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSTabBarController.h"
#import "BSNavigationController.h"
#import "BSEssenceController.h"
#import "BSNewController.h"
#import "LYMPublishViewController.h"
#import "BSFriendTrendsController.h"
#import "BSMeController.h"
#import "BSTabBar.h"


#define BSColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define BSTabBarItemFont [UIFont systemFontOfSize:12]

@interface BSTabBarController ()

@end

@implementation BSTabBarController
// 初始化TabBarItem的样式
+ (void)load{
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
    // 获取TabBarItem的appearence
    UITabBarItem *itemAppearence =  [UITabBarItem appearance];
    // 正常状态
    NSDictionary *normalDict = @{
                           NSForegroundColorAttributeName: BSColor(66, 66, 66),
                           NSFontAttributeName:BSTabBarItemFont
                        };
    [itemAppearence setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
    // 选中状态
    NSDictionary *selectedDict = @{
                                   NSForegroundColorAttributeName:BSColorWithRGB(1, 1, 1),
                                   NSFontAttributeName:BSTabBarItemFont
                                   };
    [itemAppearence setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
}

#pragma mark - 初始化方法 =
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.初始化所有的子控制器
    [self setupAllChildViewController];
    
    // 2.初始化TabBar
    [self setupTabBar];
}

// 2.自定义的TabBar替换系统的TabBar
- (void)setupTabBar{
    BSTabBar *tabBar = [[BSTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    /// Block的运用（作为属性） 跳转到发布控制器
    tabBar.operationBlock = ^{
        LYMPublishViewController *publish = [[LYMPublishViewController alloc] init];
        BSNavigationController *nav = [[BSNavigationController alloc] initWithRootViewController:publish];
        [self presentViewController:nav animated:YES completion:nil];
    };
}

// 初始化所有的控制器
- (void)setupAllChildViewController{
    // 1.精华
    BSEssenceController *essence = [[BSEssenceController alloc] init];
    BSNavigationController *n1 = [[BSNavigationController alloc] initWithRootViewController:essence];
    n1.tabBarItem.title = @"精华";
    n1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    n1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    [self addChildViewController:n1];
    
    // 2.新帖
    BSNewController *new = [[BSNewController alloc] init];
    BSNavigationController *n2 = [[BSNavigationController alloc] initWithRootViewController:new];
    n2.tabBarItem.title = @"新帖";
    n2.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    n2.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_new_click_icon"];
    [self addChildViewController:n2];
    
    // 3.发布
    
    
    // 4.关注
    BSFriendTrendsController *friendTrends = [[BSFriendTrendsController alloc] init];
    BSNavigationController *n4 = [[BSNavigationController alloc] initWithRootViewController:friendTrends];
    n4.tabBarItem.title = @"关注";
    n4.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_click_icon"];
    n4.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    [self addChildViewController:n4];
    
    // 5.我的
//    BSMeController *me = [[BSMeController alloc] init];
//     从storyboard创建控制器
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:NSStringFromClass([BSMeController class]) bundle:nil];
    BSMeController *meVC = [storyBoard instantiateInitialViewController];
    BSNavigationController *n5 = [[BSNavigationController alloc] initWithRootViewController:meVC];
    n5.tabBarItem.title = @"我的";
    n5.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    n5.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBar_me_click_icon"];
    [self addChildViewController:n5];
}

@end
