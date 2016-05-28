//
//  BSNewController.m
//  BaiSi
//
//  Created by ming on 13/12/17.
//  Copyright © 2015年 ming. All rights reserved.
//

#import "BSNewController.h"
#import "BSTagController.h"

@interface BSNewController ()

@end

@implementation BSNewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"新帖";
    
    // 1.设置导航条
//    [self setUpNav];
}

// 控制器排布子控件（这里设置最准确）
- (void)viewDidLayoutSubviews{
    
}

#pragma mark - 设置导航栏
// 设置导航条
//- (void)setUpNav{
//    // 设置标题
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//    // 设置左边按钮图片
//    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithBackgroundImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(leftItemClick)];
//    // 设置右边按钮图片
//    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithBackgroundImage:@"navigationButtonRandom" highImage:@"navigationButtonRandomClick" target:self action:@selector(rightItemClick)];
//    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.rightBarButtonItem = rightItem;
//}
//
//#pragma mark - 操作
//// 导航条左边点击 (跳转到关注标签界面)
//- (void)leftItemClick{
//    BSTagController *tagVC = [[BSTagController alloc] init];
//    
//    [self.navigationController pushViewController:tagVC animated:YES];
//}
//
//// 导航条右边点击
//- (void)rightItemClick{
//    
//}




@end
